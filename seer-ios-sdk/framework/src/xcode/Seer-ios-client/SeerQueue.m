//
//  SeerQueue.m
//  Seer-ios-client
//
//  Created by Tomack, Barry on 1/21/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "SeerQueue.h"
#import "SeerReporter.h"
#import "SeerUtility.h"
#import "SeerClientErrors.h"
#import "SeerByteValidator.h"

@interface SeerQueue ()

//@property (nonatomic, assign) int currentReportRequestId;   // OLD for updating record in Seer_Queue
@property (nonatomic, strong) NSMutableArray *currentBatchRequestIds; // for updating batch records in Seer_Queue
@property (nonatomic, assign) int currentReportViewRow;     // for keeping track of how many records have been processed
@property (nonatomic, assign) int totalReportViewRows;      // for keeping track of the total number of records to be processed
@property (nonatomic, assign) int currentOffsetValue;       // for keeping track of the OFFSET value when reading rows from SEER_QUEUE

@property (nonatomic, strong) NSString* currentReportRequestType;

@property (nonatomic, weak) NSString* token;
@property (nonatomic, weak) SeerEndpoints* endpoints;
@property (nonatomic, strong) SeerReporter* seerReporter;

@property (nonatomic, strong) NSString* currentBatch;

@property (nonatomic, strong) SeerByteValidator* byteValidator;

@property (nonatomic, assign) int batchIdCounter;
@property (nonatomic, strong) NSMutableDictionary *allBatches;
@property (nonatomic, strong) NSMutableDictionary *allRequestIDs;
@property (nonatomic, strong) NSMutableDictionary *allBatchTypes;
@property (nonatomic, assign) int processedBatchCounter;
@property (nonatomic, assign) BOOL areMoreQueueItemsAvailable;

@property (nonatomic, strong) NSMutableArray *oldestQueueIds; //for deleting oldest items if DB max size is exceeded
@property (nonatomic, strong) NSMutableArray *oldestDeletedRequestIds; //for reporting to the client the deleted oldest items if DB max size is exceeded
@property (nonatomic, assign) NSUInteger oldItemsTotalSize;

@end

@implementation SeerQueue

NSString* const kSEER_TincanReportForBatch          = @"SeerTincanReport";
NSString* const kSEER_ActivityStreamReportForBatch  = @"SeerActivityStreamReport";
NSString* const kSEER_ActivityStreamBatch           = @"ActivityStreamBatch";
NSString* const kSEER_TincanBatch                   = @"TincanBatch";

- (void) performSeerQueueSetUp
{
    NSLog(@"Running set up for SeerQueue...");
    
    self.seerReporter = [SeerReporter new];
    self.byteValidator = [SeerByteValidator new];
    self.currentBatch = nil;
    self.currentBatchRequestIds = [[NSMutableArray alloc] init];
    self.batchIdCounter = 0;
    self.allBatches = [[NSMutableDictionary alloc] init];
    self.allRequestIDs = [[NSMutableDictionary alloc] init];
    self.allBatchTypes = [[NSMutableDictionary alloc] init];
    self.processedBatchCounter = 0;
    self.oldestQueueIds = [[NSMutableArray alloc] init];
    self.oldestDeletedRequestIds = [[NSMutableArray alloc] init];
    
    [self dbManager]; //init dbManager
    
    serialQueueForSeerItems = dispatch_queue_create("com.pearsoned.mobileplatform.seer.QueueForSeerItems", NULL);
    batchReportingSerialQueue = dispatch_queue_create("com.pearsoned.mobileplatform.seer.ReportQueue", NULL);
    batchReportingSemaphore = dispatch_semaphore_create(0);
}

-(SeerDatabaseManager*) dbManager {

    if(!_dbManager) {
        NSLog(@"Initializing dbManager...");
        _dbManager = [[SeerDatabaseManager alloc] initDatabase];
    }
    return _dbManager;
}

- (SeerQueueResponse*) queueSeerServerRequest:(SeerServerRequest*)request
                     removeOldItemsWhenFullDB:(BOOL)removeOldItems
{
    __block SeerQueueResponse *queueResponse;
    
    dispatch_sync(serialQueueForSeerItems, ^{ //ensuring thread safety storing seer item
        
        queueResponse = [self serialQueueSeerServerRequest:request
                                  removeOldItemsWhenFullDB:removeOldItems];
    });
    
    return queueResponse;
}

- (SeerQueueResponse*) serialQueueSeerServerRequest:(SeerServerRequest*)request
                           removeOldItemsWhenFullDB:(BOOL)removeOldItems
{
    SeerQueueResponse* qResponse = [SeerQueueResponse new];
    qResponse.success = NO;
    [self.oldestDeletedRequestIds removeAllObjects];
    
    NSUInteger itemSize = [[request.requestJSON dataUsingEncoding:NSUTF8StringEncoding] length];
    NSLog(@"Attempting to insert item with size %lu, removedOldItems: %d", (unsigned long)itemSize, removeOldItems);
    
    if (([self.dbManager databaseSize] + itemSize) > kSEER_QueueDBMaxSize)
    {
        //NSLog(@"DB Max size  of %ld will be reached if we insert this item with size %ld into DB with size %ld",
        //      (long)kSEER_QueueDBMaxSize, (long)itemSize, (long)[self.dbManager databaseSize]);
        
        if (!removeOldItems) {
            //NSLog(@"Full DB - App asked not to remove old items...");
            qResponse.error = [self queueErrorWithCode:SeerQueueFullDBError
                                               message:
                               @"Error: Queue is at maximum size alotted - unable to insert the queue item."];
            return qResponse;
        }
        if (![self didRemoveOldestItemsForNewItemWithSize:itemSize]) {
            qResponse.error = [self queueErrorWithCode:SeerQueueFullDBError message:
                               @"Error: Queue is at maximum size alotted - unable to allocate more space for item"];
            return qResponse;
        } else {
            [self removeEmptySapceFromDatabase];
            qResponse.deletedOldestQueueItems = self.oldestDeletedRequestIds;
        }
    }
    
    int sqliteReturnCode = [self insertQueueItemForRequest:request];
    
    if (sqliteReturnCode == SQLITE_DONE)
    {
        qResponse.success = YES;
    }
    else
    {
        if (sqliteReturnCode == SQLITE_FULL) {
            qResponse = [self fullDiskQueueSeerServerRequest:request
                                    removeOldItemsWhenFullDB:removeOldItems
                                                    itemSize:itemSize];
        }
        else { //error inserting to queue
            qResponse.error = [self queueErrorWithCode:SeerQueueError
                                               message:@"Error: Unable to insert request into Queue."];
        }
    }
    
    return qResponse;
}

-(int) insertQueueItemForRequest:(SeerServerRequest*)request {
    
    return [self.dbManager
            insertSeerQueueRowForSqlStatement:[self.dbManager createSeeqQueueInsertStatementForRequest:request]];
}

- (SeerQueueResponse*) fullDiskQueueSeerServerRequest:(SeerServerRequest*)request
                             removeOldItemsWhenFullDB:(BOOL)removeOldItems
                                             itemSize: (NSUInteger)itemSize {
    
    SeerQueueResponse* qResponse = [SeerQueueResponse new];
    qResponse.success = NO;
    
    NSLog(@"In fullDiskQueueSeerServerRequest and removeOldItems is %d", removeOldItems);
    if (!removeOldItems) {
        qResponse.error = [self queueErrorWithCode:SeerQueueFullDiskError
                                           message: @"Error: Unable to insert the queue item due to full disk."];
        return qResponse;
    }
    
    if ([self didRemoveOldestItemsForNewItemWithSize:itemSize]) {
        [self removeEmptySapceFromDatabase];
        qResponse.deletedOldestQueueItems = self.oldestDeletedRequestIds;
        
        NSLog(@"Made enough room - let's try inserting");
        int sqliteReturnCode = [self insertQueueItemForRequest:request];
        if (sqliteReturnCode == SQLITE_DONE) {
            qResponse.success = YES;
        }
        else if (sqliteReturnCode == SQLITE_FULL) { //corner case
            NSLog(@"Full disk - corner case - made enough room but sqlite still reports full disk");
            qResponse.error = [self queueErrorWithCode:SeerQueueFullDiskError
                                               message: @"Error: Unable to insert the queue item due to full disk."];
        }
        else {
            qResponse.error = [self queueErrorWithCode:SeerQueueError
                                               message: @"Error: Unable to insert request into Queue."];
        }
    }
    else {
        qResponse.error = [self queueErrorWithCode:SeerQueueFullDiskError message:
                           @"Error: Unable to insert the queue item due to full disk."];
    }
    
    return qResponse;
}

- (BOOL) didRemoveOldestItemsForNewItemWithSize:(NSUInteger)newItemSize {
    self.currentOffsetValue = 0;
    self.oldItemsTotalSize = 0;
    
    if (![self didObtainCurrentOldItemsTotalSize]) {
        return false;
    }
    
    while (newItemSize > self.oldItemsTotalSize) { //true if we haven't made enough room for item yet
        
        if (![self didObtainCurrentOldItemsTotalSize]) { //guarding against infinite while loop - in case there are no more old itmes
            NSLog(@"Couldn't find more needed oldest items to remove...");
            return false;
        }
    }
    
    BOOL deleted = [self deletedOldestItemsFromQueue];
    [self.oldestQueueIds removeAllObjects];
    
    if (!deleted) {
        [self.oldestDeletedRequestIds removeAllObjects];
    }
    
    return deleted;
}

- (BOOL) didObtainCurrentOldItemsTotalSize {
    NSInteger nextItemSize = [[[self getOldestItemFromQueue] dataUsingEncoding:NSUTF8StringEncoding] length];
    if (nextItemSize == 0) {
        return false;
    }
    //NSLog(@"Next item to delete is %lu", (long)nextItemSize);
    self.oldItemsTotalSize += nextItemSize;
    
    return true;
}

- (NSString*) getOldestItemFromQueue {
    
    NSString *statement = [self.dbManager createGetSeerQueueOldestRowStatementForOffset:self.currentOffsetValue];
    SeerQueueDBItem *oldestItem = [self.dbManager getSeerQueueRowForStatement:statement];
    
    if (oldestItem) {
        [self.oldestQueueIds addObject:[NSNumber numberWithInt:(int)oldestItem.queueId]];
        [self.oldestDeletedRequestIds addObject:[NSNumber numberWithInt:(int)oldestItem.requestId]]; //for reporting purposes back to client
        self.currentOffsetValue++;
        
        return oldestItem.payload;
    }
    else {
        return nil;
    }
}

- (BOOL) deletedOldestItemsFromQueue {
    
    return [self.dbManager deleteSeerQueueRowsForQueueIds:self.oldestQueueIds];
}

# pragma mark REPORT QUEUE SEQUENCE Begins

- (void) reportQueueWithToken:(NSString*)token
                 forEndpoints:(SeerEndpoints*)endpoints
{
    //NSLog(@"Attempting to enter batchReportingSerialQueue - thread id is: %@", [NSThread currentThread]);
    dispatch_async(batchReportingSerialQueue, ^{ //non-blocking to the calling thread
        NSLog(@"Request in batch reporting serial queue - thread id is: %@", [NSThread currentThread]);
        
        self.token = token;
        self.endpoints = endpoints;
        
        [self reportQueueRequests];
    });
}

- (void) reportQueueRequests
{
    NSLog(@"Reporting this queue request for token %@", self.token);
    
    SeerReporterComplete seerReporterOnComplete = ^(NSData* response, int batchId, NSError* error)
    {
        NSLog(@"In on complete and the batch id is %d and thread id is %@", batchId, [NSThread currentThread]);
        
        self.processedBatchCounter++;
        
        NSArray *requestIDsToUpdate = (NSArray*)[self.allRequestIDs objectForKey:[NSNumber numberWithInt:batchId]];
        
        SeerServerRequestStatus requestStatus = kServerRequestStatusPending;
        
        SeerClientBatchResponse* seerClientBatchResponse = [self setSeerBatchResponseForError:error
                                                                                requestStatus:&requestStatus
                                                                                   andBatchId:batchId];
        
        if ([self updateBatchSeerServerRequestStatus:requestStatus forItemsWithIds:requestIDsToUpdate])
        {
            seerClientBatchResponse.requestIds = requestIDsToUpdate;
            [self.delegate reportQueueRequestBatch:seerClientBatchResponse];
        }
        
        if (self.processedBatchCounter == self.batchIdCounter) { //last batch
            NSLog(@"Processed last batch - will clean up and report. self.processedBatchCounter is %d and self.batchIdCounter is %d", self.processedBatchCounter, self.batchIdCounter);
            [self respondToCompletedBatchingProcess];
        }
        
        dispatch_semaphore_signal(batchReportingSemaphore);
    };
    
    [self processSeerServerRequestWithToken:self.token
                               ForEndpoints:self.endpoints
                                 OnComplete:seerReporterOnComplete];
    
    //NSLog(@"Will wait for semaphore to signal... - thread id is: %@", [NSThread currentThread]);
    dispatch_semaphore_wait(batchReportingSemaphore, DISPATCH_TIME_FOREVER); //We are waiting until the last batch finishes processing
    //NSLog(@"Opening semaphore after last batch in completion handler ran... - thread id is: %@", [NSThread currentThread]);
}

- (SeerClientBatchResponse*) setSeerBatchResponseForError:(NSError*)error
                                            requestStatus:(SeerServerRequestStatus*)requestStatus
                                               andBatchId:(int)batchId {
    
    SeerClientBatchResponse* seerClientBatchResponse = [SeerClientBatchResponse new];
    
    if ([[self.allBatchTypes objectForKey:[NSNumber numberWithInt:batchId]] isEqualToString:kSEER_ActivityStreamBatch]) {
        seerClientBatchResponse.requestType = kSEER_ActivityStreamReportForBatch;
    }
    else {
        seerClientBatchResponse.requestType = kSEER_TincanReportForBatch;
    }
    
    if (error)
    {
        seerClientBatchResponse.success = NO;
        seerClientBatchResponse.error = error;
        seerClientBatchResponse.queued = YES;
        
        if (error.code < 0)
        {
            if (error.code == SeerReporterError) // Reporter error
            {
                // Error from iOS device
                //okToContinue = NO;
            }
            *requestStatus = kServerRequestStatusError;
        } else {
            *requestStatus = kServerRequestStatusFailure;
        }
    } else {
        seerClientBatchResponse.success = YES;
        seerClientBatchResponse.queued = NO;
        *requestStatus = kServerRequestStatusSuccess;
    }
    
    return seerClientBatchResponse;
}

- (void) respondToCompletedBatchingProcess {
    SeerQueueResponse* qResponse = [SeerQueueResponse new];
    qResponse.success = [self deleteSuccessfulServerRequests];
    if(! qResponse.success)
    {
        qResponse.error = [self queueErrorWithCode:SeerQueueError
                                           message:@"Error removing successful server requests from queue."];
    }
    [self.delegate reportQueueRequestComplete:qResponse];
    [self removeEmptySapceFromDatabase]; //shrink DB - eliminate overhead in DB size
    [self resetBatches];
}

- (void) resetBatches {
    self.batchIdCounter = 0;
    self.processedBatchCounter = 0;
    [self.allBatches removeAllObjects];
    [self.allBatchTypes removeAllObjects];
    [self.allRequestIDs removeAllObjects];
}

- (void) processSeerServerRequestWithToken:(NSString*)token
                              ForEndpoints:(SeerEndpoints*)endpoints
                                OnComplete:(SeerReporterComplete)onComplete
{
    [self prepareAllBatches];
    
    NSLog(@"self.batchIdCounter is %d of %lu batches", self.batchIdCounter, (unsigned long)[self.allBatchTypes count]);
    
    if (self.batchIdCounter == 0) {
        SeerQueueResponse* qResponse = [SeerQueueResponse new];
        qResponse.success = YES;
        [self.delegate reportQueueRequestComplete:qResponse];
        
        //NSLog(@"No batches to process - signaling via semaphore.");
        dispatch_semaphore_signal(batchReportingSemaphore); //no batches - releasing semaphore
        
        return;
    }
    
    [self sendSeerServerRequestWithToken:token
                            ForEndpoints:endpoints
                              OnComplete:onComplete];
    
}

- (void) sendSeerServerRequestWithToken:(NSString*)token
                           ForEndpoints:(SeerEndpoints*)endpoints
                             OnComplete:(SeerReporterComplete)onComplete
{
    for (int i=1; i <= self.batchIdCounter; i++) { //iterate through all batches (both types)
        
        NSString* url = [endpoints urlStringForEndpoint:[self.allBatchTypes objectForKey:[NSNumber numberWithInt:i]]];
        
        if (url && ![url isEqualToString:@""])
        {
            NSLog(@"Sending batch %d to Seer...", i);
            [self.seerReporter reportJSONStringToSeer:[self.allBatches objectForKey:[NSNumber numberWithInt:i]]
                                                atURL:url
                                            withToken:token
                                           forBatchId:i
                                           onComplete:onComplete];
        }
        else
        {
            NSError* error = [NSError errorWithDomain:kSEER_ErrorDomain
                                                 code:SeerQueueError
                                             userInfo:@{NSLocalizedDescriptionKey: @"bad url"}];
            
            onComplete(nil, i, error);
        }
    }
}

- (void) prepareAllBatches {
    
    [self prepareAllActivityStreamBatches];
    
    [self prepareAllTinCanBatches];
}

- (void) prepareAllActivityStreamBatches {
    self.areMoreQueueItemsAvailable = true;
    self.currentOffsetValue = 0;
    
    while (self.areMoreQueueItemsAvailable) {
        [self prepareBundlePayloadForRequestType:kSEER_ActivityStreamReportForBatch];
        
        if (self.currentBatch) {
            [self assignIDsToBatches];
            
            [self.allBatchTypes setObject:kSEER_ActivityStreamBatch forKey:[NSNumber numberWithInt:self.batchIdCounter]];
        }
    }
}

- (void) prepareAllTinCanBatches {
    self.areMoreQueueItemsAvailable = true;
    self.currentOffsetValue = 0;
    
    while (self.areMoreQueueItemsAvailable) {
        [self prepareBundlePayloadForRequestType:kSEER_TincanReportForBatch];
        
        if (self.currentBatch) {
            [self assignIDsToBatches];
            
            [self.allBatchTypes setObject:kSEER_TincanBatch forKey:[NSNumber numberWithInt:self.batchIdCounter]];
        }
    }
}

- (void) assignIDsToBatches {
    self.batchIdCounter++;
    
    [self.allBatches setObject:[NSMutableString stringWithString:self.currentBatch] forKey:[NSNumber numberWithInt:self.batchIdCounter]];
    
    [self.allRequestIDs setObject:[self createRequestIDArrayForBatch] forKey:[NSNumber numberWithInt:self.batchIdCounter]];
    [self.currentBatchRequestIds removeAllObjects];
}

- (NSArray*) createRequestIDArrayForBatch {
    return [[NSArray alloc] initWithArray:self.currentBatchRequestIds];
}

- (void) prepareBundlePayloadForRequestType:(NSString*)type
{
    self.currentBatch = nil;
    NSMutableString *tempBundle = [NSMutableString new];
    
    NSString *itemPayload = [self getItemFromQueueForRequestType:type];
    if (!itemPayload) {
        self.areMoreQueueItemsAvailable = false;
        
        return;
    }
    
    while ([self isSizeValidForCurrentBundle:&tempBundle andCurrentItem:itemPayload]) {
        
        self.currentBatch = tempBundle;
        
        itemPayload = [self getItemFromQueueForRequestType:type];
        if (!itemPayload) {
            break;
        }
    }
    
    if (itemPayload) { //batch reached max size but we still have items in table for this type; will pick up in next batch
        self.currentOffsetValue--;
        [self.currentBatchRequestIds removeLastObject];
    }
}

- (BOOL) isSizeValidForCurrentBundle:(NSString**)bundle
                      andCurrentItem:(NSString*)item
{
    ValidationResult *validationResult = [self.byteValidator validDataStringSize:[self addCurrentItem:item
                                                                                      toCurrentBundle:&*bundle]];
    return validationResult.valid;
}
                                          
- (NSString*) addCurrentItem:(NSString*)item
             toCurrentBundle:(NSString**)bundle
{
    if ([*bundle isEqualToString:@""]) {
        *bundle = [NSString stringWithFormat:@"{\"activities\":[%@]}", item];
    }
    else {
        *bundle = [NSString stringWithFormat:@"%@,%@]}",[*bundle substringToIndex:[*bundle length]-2], item];
    }
    return *bundle;
}

- (NSString*) getItemFromQueueForRequestType:(NSString*)type
{
    NSString *statement = [self.dbManager createGetSeerQueueViewStatementForRequestType:type
                                                                                 offset:self.currentOffsetValue];
    SeerQueueDBItem *seerQueueViewRow = [self.dbManager getSeerQueueViewRowForStatement:statement];
    
    if (seerQueueViewRow) {
        [self.currentBatchRequestIds addObject:[NSNumber numberWithInt:(int)seerQueueViewRow.requestId]];
        self.currentOffsetValue++;
        
        return seerQueueViewRow.payload;
    }
    else {
        return  nil;
    }
}

- (BOOL) deleteSuccessfulServerRequests
{
    return [self.dbManager deleteSeerQueueRowForStatement:
            [self.dbManager createDeleteSeerQueueRowStatementForRequestStatus:kServerRequestStatusSuccess]];
}

- (BOOL) updateBatchSeerServerRequestStatus:(SeerServerRequestStatus)status
                            forItemsWithIds:(NSArray*)requestIdArray
{
    return [self.dbManager updateSeerQueueItems:requestIdArray
                                     withStatus:status];
}

- (void) removeEmptySapceFromDatabase
{
    [self.dbManager removeEmptyPagesFromDB];
}

- (NSInteger) getMaxRequestId {
    return [self.dbManager getSeerQueueMaxRequestIdValue];
}

# pragma mark REPORT QUEUE SEQUENCE Ends

- (NSError*) queueErrorWithCode:(SeerClientErrorCode)errorCode
                        message:(NSString*) errorMessage;
{
    NSError* error = [[NSError alloc] initWithDomain:kSEER_ErrorDomain
                                                code:errorCode
                                            userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
    return error;
}

@end
