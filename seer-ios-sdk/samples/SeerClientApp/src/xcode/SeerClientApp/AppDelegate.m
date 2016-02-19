//
//  AppDelegate.m
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/6/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "AppDelegate.h"
#import "TestFlight.h"
#import <Core-ios-sdk/PGMCoreReachability.h>

@interface AppDelegate ()

@property (nonatomic, strong) SeerClient* seerClient;
@property (nonatomic, weak) PGMCoreReachability *networkReachability;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.actorName = [NSString new];
    
    [self initSeerClient];
    [self listenForNetworkChanges];
    
    // Session History is a requirement for this app
    self.sessionHistory = [NSMutableArray new];
    
    [TestFlight takeOff:@"75f54e5d-1bf7-45ae-8096-7e8b768875a3"];
    
    return YES;
}

- (void) startClient {
    [self.seerClient startSeerSession];
}

- (void) initSeerClient
{
    self.seerClient = [[SeerClient alloc] initWithClientId: @"mp_seer_client"
                                              clientSecret: @"iSNla38gEUFg"
                                                    apiKey: nil];
    
    self.seerClient.autoReportQueue = YES;
    self.seerClient.receiveQueuedItemResponses = YES;
    self.seerClient.removeOldItemsWhenFullDB = YES;
    
    self.seerClient.delegate = self;
    
}

- (void) listenForNetworkChanges
{
    self.networkReachability = [PGMCoreReachability sharedReachability];
    [self.networkReachability startListening];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:PGMCoreReachabilityChanged object:nil];
}

- (void) reportDataDictionary:(NSDictionary*)dataDict
                  requestType:(NSString*)requestType
{
    SeerClientResponse* seerClientResponse = [SeerClientResponse new];
    
    if ([requestType isEqualToString:kSEER_ActivityStreamReport])
    {
        seerClientResponse = [self.seerClient reportActivityStreamPayload:dataDict];
    }
    else if ([requestType isEqualToString:kSEER_TincanReport])
    {
        seerClientResponse = [self.seerClient reportTincanStatement:dataDict];
    }
    
    if (seerClientResponse.error)
    {
        [self showAlertMessageWithTitle:[NSString stringWithFormat:@"%@ Error", requestType]
                                message:seerClientResponse.error.localizedDescription];
    }
    else
    {
        [self storeData:dataDict
            requestType:requestType
           forRequestId:seerClientResponse.requestId
                 queued:NO];
    }
}

// Stores SeerRequests so that they can be viewed in SessionView
- (void) storeData:(NSDictionary*)dataDict
       requestType:(NSString*)requestType
      forRequestId:(NSInteger)requestId
            queued:(BOOL)queued
{
    SessionRequest* sessionRequest = [SessionRequest new];
    sessionRequest.jsonDict = dataDict;
    sessionRequest.requestType = requestType;
    sessionRequest.status = kRequestStatusPending;
    sessionRequest.requestId = @(requestId);
    sessionRequest.queued = queued;
    
    [self.sessionHistory addObject:sessionRequest];
}

- (SeerClientResponse*) queueDataDictionary:(NSDictionary*)dataDict
                                requestType:(NSString*)requestType
{
    SeerClientResponse* seerClientResponse = [SeerClientResponse new];
    NSLog(@"AppDelegate queueDataDictionary");
    if ([requestType isEqualToString:kSEER_ActivityStreamReport])
    {
        NSLog(@"QUEUING ACTIVITYSTREAM");
        seerClientResponse = [self.seerClient queueActivityStreamPayload:dataDict];
    }
    else if ([requestType isEqualToString:kSEER_TincanReport])
    {
        seerClientResponse = [self.seerClient queueTincanStatement:dataDict];
    }
    
    if (seerClientResponse.error)
    {
        [self showAlertMessageWithTitle:[NSString stringWithFormat:@"%@ Error", requestType]
                                message:seerClientResponse.error.localizedDescription];
    }
    else
    {
        [self storeData:dataDict
            requestType:requestType
           forRequestId:seerClientResponse.requestId
                 queued:seerClientResponse.queued];
    }
    
    return seerClientResponse;
}

- (void) reportQueue
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(reportQueueComplete:)
                                                 name: kSEER_RequestReportQueue
                                               object: nil];
    [self.seerClient reportQueue];
}

- (void) seerClientDelegateResponse:(SeerClientResponse*)seerClientResponse
{
    NSLog(@"seerClientRequestSuccess: %@,\n Error %@,\n RequestType: %@,\n RequestId: %lu,\n QUEUED: %@,\n oldest items deleted: %lu",
           seerClientResponse.success?@"YES":@"NO", seerClientResponse.error, seerClientResponse.requestType, (long)seerClientResponse.requestId, seerClientResponse.queued?@"YES":@"NO", (long)[seerClientResponse.deletedOldestQueueItems count]);
    
    SeerRequestStatus status = [self setRequestStatusPerResponseSuccess:seerClientResponse.success
                                                               andError:seerClientResponse.error];
    
    [self updateRequestStatus:status
             forRequestWithId:@(seerClientResponse.requestId)
                  requestType:seerClientResponse.requestType
                        queue:seerClientResponse.queued
           deletedOldestItems:seerClientResponse.deletedOldestQueueItems];
}

- (SeerRequestStatus) setRequestStatusPerResponseSuccess:(BOOL)success
                                                andError:(NSError*)error {
    SeerRequestStatus status = kRequestStatusPending;
    
    if(success)
    {
        status = kRequestStatusSuccess;
    }
    else
    {
        if(error.code <= -2100)
        {
            // SeerClientApp Error
            status = kRequestStatusError;
        } else {
            // Seer Server Error
            status = kRequestStatusFailure;
        }
    }
    
    return status;
}

- (void) seerClientDelegateBatchResponse:(SeerClientBatchResponse*)seerClientBatchResponse {
    NSLog(@"seerClientBatchRequestSuccess: %@,\n Error %@,\n RequestType: %@,\n RequestId: %@,\n QUEUED: %@",
          seerClientBatchResponse.success?@"YES":@"NO", seerClientBatchResponse.error, seerClientBatchResponse.requestType, seerClientBatchResponse.requestIds.description, seerClientBatchResponse.queued?@"YES":@"NO");
    
    SeerRequestStatus status = [self setRequestStatusPerResponseSuccess:seerClientBatchResponse.success
                                                               andError:seerClientBatchResponse.error];
    
    for (int i = 0; i < seerClientBatchResponse.requestIds.count; i++) { //all request IDs in the batch
        [self updateRequestStatus:status
                 forRequestWithId:[seerClientBatchResponse.requestIds objectAtIndex:i]
                      requestType:seerClientBatchResponse.requestType
                            queue:seerClientBatchResponse.queued
               deletedOldestItems:nil]; //nil??
    }
}

- (void) updateRequestStatus:(SeerRequestStatus) status
            forRequestWithId:(NSNumber*)requestId
                 requestType:(NSString*)requestType
                       queue:(BOOL)queue
          deletedOldestItems:(NSArray*)deletedOldestQueueItems
{
    //NSLog(@"In updateRequestStatus for status %ld requestType %@ with id %@ and isQueued %d", (long unsigned)status, requestType, requestId, queue);
    if ([requestType isEqualToString:kSEER_ActivityStreamReport] ||
        [requestType isEqualToString:kSEER_TincanReport])
    {
        for ( NSUInteger i = 0; i < [self.sessionHistory count]; i++)
        {
            //NSLog(@"Iterating through session history array...");
            SessionRequest* origRequest = [self.sessionHistory objectAtIndex:i];
            NSString* origRequestType = origRequest.requestType;
            NSNumber* origRequestId = origRequest.requestId;
            
            if (origRequest.status != kRequestStatusSuccess) { //NOTE: only update non-Success items (Pending, Error, etc)
                
                //NSLog(@"Orig. req. status is: %ld and queued is: %d with req. type: %@ and req. id: %@", (long unsigned)origRequest.status, origRequest.queued, origRequestType, origRequestId);
                if ([origRequestType isEqualToString:requestType] &&
                    ([origRequestId isEqualToNumber:requestId]) ) // was: == requestId which failes on 64-bit
                {
                    origRequest.status = status;
                    origRequest.queued = queue;
                    NSLog(@"Changed the orgig. req status to: %ld and queued to: %d", (long unsigned)origRequest.status, origRequest.queued);
                    [self.sessionHistory replaceObjectAtIndex:i withObject:origRequest];
                    break;
                }
            } else {
                //NSLog(@"Original request status is success - %ld", (long unsigned)origRequest.status);
            }
            //see if there are any oldest items deleted - need to remove them in UI
            //NSLog(@"orig request id is %@ and the removed request id is %@", origRequest.requestId, [deletedOldestQueueItems objectAtIndex:0]);
            if ([deletedOldestQueueItems containsObject:origRequest.requestId]) {
                NSLog(@"Found item in sessionHistory that was deleted to make room for newer queued item - will remove it.");
                [self.sessionHistory removeObjectAtIndex:i];
            }
        }
        
        if ([self.sessionHistory count] > 0) {
            //NSLog(@"Still in updateRequestStatus - will dispatch kSessionItemsUpdated...");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kSessionItemsUpdated object:nil];
            });
        }
        
    }
    else {
        [self sessionUpdated];
    }
}

- (void) sessionUpdated
{
    //NSLog(@"In sessionUpdated - will dispatch kSessionUpdate");
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kSessionUpdate object:nil];
    });
}

- (void) clearSession
{
    [self.sessionHistory removeAllObjects];
    [self sessionUpdated];
}

- (void) showAlertMessageWithTitle:(NSString*)title
                           message:(NSString*)message;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (NSNumber*)itemsInQueue
{
    return [self.seerClient getQueueItemCount];
}

- (NSNumber*)sizeOfQueue
{
    return [self.seerClient getQueueSize];
}

- (void) reportQueueComplete:(NSNotification*) notification
{
    NSLog(@"In reportQueueComplete - will dispatch kSessionUpdate");
    //this is necessary when nothing is in queue and when an error occurs
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kSessionUpdate object:nil];
    });
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSEER_RequestReportQueue object:nil];
}

- (void) networkChanged:(NSNotification*)notification
{
    PGMCoreReachabilityStatus status = (PGMCoreReachabilityStatus)[[notification userInfo] objectForKey:PGMCoreReachabilityNotificationStatus];
    NSLog(@"NETWORK CHANGED: %@", [[notification userInfo] objectForKey:PGMCoreReachabilityNotificationStatusText]);
    if (status > 0)
    {
        [self reportQueue];
    }
    else if (status == 0 || status ==-1)
    {
        // Do something when device goes offline.
    }
}

- (void) changeAutoReportQueue:(BOOL)option {
    self.seerClient.autoReportQueue = option;
}

- (void) changeRemoveOldItemsWhenFullDB:(BOOL)option {
    self.seerClient.removeOldItemsWhenFullDB = option;
}

#pragma set batch size

- (ValidationResult *) userSetBatchSize:(NSInteger)bundleSize {
    ValidationResult *result = [self.seerClient validateAndSetBundleSize:bundleSize];
    return result;
}

@end
