//
//  SeerClient.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/16/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "SeerClient.h"
#import "SeerEndpoints.h"
#import "SeerTokenResponse.h"
#import "SeerTokenFetcher.h"
#import "SeerReporter.h"
#import "SeerQueue.h"
#import "SeerQueueResponse.h"
#import "ActivityStreamValidator.h"
#import "TincanValidator.h"
#import "SeerByteValidator.h"
#import "Tincan.h"
#import <UIKit/UIApplication.h>
#import "SeerClientErrors.h"


@interface SeerClient()

@property (nonatomic, strong) ActivityStreamValidator* activityStreamValidator;
@property (nonatomic, strong) TincanValidator* tincanValidator;
@property (nonatomic, strong) SeerByteValidator* byteValidator;

@property (nonatomic, strong) NSString* clientId;
@property (nonatomic, strong) NSString* clientSecret;
@property (nonatomic, strong) NSString* apiKey;

@property (nonatomic, strong) SeerEndpoints* seerEndpoints;
@property (nonatomic, strong) SeerReporter* seerReporter;
@property (nonatomic, strong) SeerQueue* seerQueue;
@property (nonatomic, strong) SeerTokenResponse* seerTokenResponse;

@property (nonatomic, strong) SeerRequestComplete tokenRequestComplete;
@property (nonatomic, strong) SeerRequestComplete reportComplete;
@property (nonatomic, strong) SeerRequestComplete startSessionComplete;

@property (nonatomic, strong) NSMutableDictionary* requestCompleteBlockHistory;

@property (nonatomic, assign) BOOL logging;

@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;

@end

@implementation SeerClient

NSString* const kSEER_TokenFetch                    = @"SeerTokenFetch";
NSString* const kSEER_TincanReport                  = @"SeerTincanReport";
NSString* const kSEER_ActivityStreamReport          = @"SeerActivityStreamReport";
NSString* const kSEER_InstrumentationReport         = @"SeerInstrumentationReport";

NSString* const kSEER_RequestStartSession           = @"SeerRequestStartSession";
NSString* const kSEER_RequestReportQueue            = @"SeerRequestReportQueue";
NSString* const kSEER_RequestResultForQueuedBatch   = @"SeerRequestResultForQueuedBatch";

NSString* const kSEER_BundleSizeLimit               = @"SeerBundleSizeLimit";


- (id) initWithClientId:(NSString*) clientId
           clientSecret:(NSString*) clientSecret
                 apiKey:(NSString*) apiKey
{
    self = [super init];
    
    if(self)
    {
        self.clientId = clientId;
        self.clientSecret = clientSecret;
        self.apiKey = apiKey;
        
        self.activityStreamValidator = [ActivityStreamValidator new];
        self.tincanValidator = [TincanValidator new];
        self.byteValidator = [SeerByteValidator new];
        
        // Set default endpoints
        if(self.apiKey)
        {
            self.seerEndpoints = [[SeerEndpoints alloc] initWithApiKey:self.apiKey];
        } else {
            self.seerEndpoints = [SeerEndpoints new];
        }
        
        [self addEndpoint:@"/sactivity" forName:kSEER_ActivityStreamReport];
        [self addEndpoint:@"/sinstrumentation" forName:kSEER_InstrumentationReport];
        [self addEndpoint:@"/tincan" forName:kSEER_TincanReport];
        [self addEndpoint:@"/oauth/access_token" forName:kSEER_TokenFetch];
        [self addEndpoint:@"/sactivity/batch" forName:kSEER_ActivityStreamBatch];
        [self addEndpoint:@"/tincan/batch" forName:kSEER_TincanBatch];
        
        self.requestCompleteBlockHistory = [NSMutableDictionary new];
        
        self.seerReporter = [SeerReporter new];
        
        self.seerQueue = [SeerQueue new];
        [self.seerQueue performSeerQueueSetUp];
        self.seerQueue.delegate = self;
        
        // Default settings
        self.autoReportQueue = YES;
        self.receiveQueuedItemResponses = NO;
        self.removeOldItemsWhenFullDB = YES;
    }
    
    return self;
}

/******************** START SESSION METHODS BEGIN ********************/

- (void) startSeerSession
{
    if(self.autoReportQueue)
    {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(enteredBackground:)
                                                     name: UIApplicationDidEnterBackgroundNotification //UIApplicationWillEnterForegroundNotification
                                                   object: nil];
    }
    
    if(! self.startSessionComplete)
    {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(startSeerSessionComplete:)
                                                     name: kSEER_TokenFetch
                                                   object: nil];
    }
    
    [self requestSeerAuthorizationToken];
}

- (void) startSeerSessionAndOnComplete:(SeerRequestComplete)onComplete
{
    self.startSessionComplete = onComplete;
    [self startSeerSession];
}

- (void) startSeerSessionComplete:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSEER_RequestStartSession object:nil];
    
    SeerClientResponse* seerClientResponse = (SeerClientResponse*)notification.object;
    seerClientResponse.requestType = kSEER_RequestStartSession;
    
    if(self.autoReportQueue && seerClientResponse.success)
    {
        [self reportQueue];
    }
    
    if(self.startSessionComplete)
    {
        self.startSessionComplete(seerClientResponse);
        self.startSessionComplete = nil;
    }
    
    /* //this delegation method is more for report and queue
    if (self.delegate)
    {
        [self.delegate seerClientDelegateResponse:seerClientResponse];
    }
    */
    [self dispatchNotificationForEvent:kSEER_RequestStartSession object:seerClientResponse];
}

/******************** START SESSION METHODS END ********************/

/********************* ENDPOINT METHODS BEGINS *********************/

- (void) enteredBackground:(NSNotification*)notification
{
    if(self.autoReportQueue)
    {
        //NSLog(@"App is in the background - will add observer for kSEER_RequestReportQueue and report the queue...");
        self.bgTask = UIBackgroundTaskInvalid;
        self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"QueueReportingInBackground"
                                                                   expirationHandler:^{
                                                                       [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
                                                                   }];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(reportQueueInBackgroundComplete:)
                                                     name: kSEER_RequestReportQueue
                                                   object: nil];
        [self reportQueue];
    }
}

- (void) addEndpoint:(NSString*)endpoint forName:(NSString*)name
{
    [self.seerEndpoints addEndpoint:endpoint forName:name];
}

- (NSDictionary*) getEndpoints
{
    return [self.seerEndpoints seerEndpoints];
}

- (void) changeSeerBaseURL:(NSString*)newBaseURL
{
    [self.seerEndpoints changeSeerBaseURL:newBaseURL];
}

- (NSString*) getSeerBaseURL
{
    return [self.seerEndpoints getSeerBaseURL];
}

/********************* ENDPOINT METHODS ENDS *********************/

/******************* SIZE LIMIT METHODS BEGINS *******************/

- (ValidationResult*) validateAndSetBundleSize:(NSInteger)bundleSize {
    ValidationResult* bundleSizeResult = [self.byteValidator limitBundleSize:bundleSize];
    
    return bundleSizeResult;
}

- (NSInteger) bundleSizeLimit
{
    return self.byteValidator.bundleSizeLimit;
}
- (NSInteger) maxBundleSizeLimit
{
    return [self.byteValidator maxBundleSize];
}
- (NSInteger) defaultBundleSizeLimit
{
    return [self.byteValidator defaultBundleSize];
}
- (NSInteger) maxBundleSizeLowerBoundLimit
{
    return [self.byteValidator maxBundelSizeLowerBound];
}

/********************* SIZE LIMIT METHODS ENDS *********************/

/******************** REPORT CALL METHODS BEGIN ********************/

- (SeerClientResponse*) reportActivityStream:(ActivityStream*)activityStream
{
    return [self reportActivityStreamPayload:[activityStream asDictionary]];
}

- (SeerClientResponse*) reportActivityStreamPayload:(NSDictionary*)activityStreamPayload
{
    SeerClientResponse* seerClientResponse = [SeerClientResponse new];
    
    ValidationResult* validActivityStream = [self validActivityStreamPayload:activityStreamPayload];
    if (validActivityStream.valid)
    {
        seerClientResponse = [self reportDataDictionary:activityStreamPayload
                                             toEndpoint:kSEER_ActivityStreamReport];
    }
    else
    {
        NSError* invalidActivityStream = [NSError errorWithDomain:kSEER_ErrorDomain
                                                             code:SeerActivityStreamError
                                                         userInfo:@{NSLocalizedDescriptionKey:validActivityStream.detail}];
        seerClientResponse.requestId = [self generateReportingId];
        seerClientResponse.error = invalidActivityStream;
    }
    
    return seerClientResponse;
}

- (SeerClientResponse*) reportActivityStream:(ActivityStream*)activityStream
                                  onComplete:(SeerRequestComplete)onComplete
{
    return [self reportActivityStreamPayload:[activityStream asDictionary]
                                  onComplete:onComplete];
}

- (SeerClientResponse*) reportActivityStreamPayload:(NSDictionary*)activityStreamPayload
                                         onComplete:(SeerRequestComplete)onComplete
{
    SeerClientResponse* seerClientResponse = [self reportActivityStreamPayload:activityStreamPayload];
    
    if(! seerClientResponse.error)
    {
        NSNumber* keyNum = @(seerClientResponse.requestId);
        [self.requestCompleteBlockHistory setObject:onComplete forKey:keyNum];
    }
    
    return seerClientResponse;
}

- (SeerClientResponse*) reportInstrumentation:(ActivityStream*)instrumentation
{
    return [self reportInstrumentationPayload:[instrumentation asDictionary]];
}

- (SeerClientResponse*) reportInstrumentationPayload:(NSDictionary*)instrumentationPayload
{
    SeerClientResponse* seerClientResponse = [SeerClientResponse new];
    
    ValidationResult* validInstrumentation = [self validActivityStreamPayload:instrumentationPayload];
    
    if (validInstrumentation.valid)
    {
        seerClientResponse = [self reportDataDictionary:instrumentationPayload
                                              toEndpoint:kSEER_InstrumentationReport];
    }
    else
    {
        NSError* invalidInstrumentation = [NSError errorWithDomain:kSEER_ErrorDomain
                                                              code:SeerInstrumentationError
                                                          userInfo:@{NSLocalizedDescriptionKey:validInstrumentation.detail}];
        
        seerClientResponse.requestId = [self generateReportingId];
        seerClientResponse.error = invalidInstrumentation;
    }
    
    return seerClientResponse;
}

- (SeerClientResponse*) reportInstrumentation:(ActivityStream*)instrumentation
                                   onComplete:(SeerRequestComplete)onComplete
{
    return [self reportInstrumentationPayload:[instrumentation asDictionary]
                                   onComplete:onComplete];
}

- (SeerClientResponse*) reportInstrumentationPayload:(NSDictionary*)instrumentationPayload
                                          onComplete:(SeerRequestComplete)onComplete
{
    SeerClientResponse* seerClientResponse = [self reportInstrumentationPayload:instrumentationPayload];
    
    if(! seerClientResponse.error)
    {
        NSNumber* keyNum = @(seerClientResponse.requestId);
        [self.requestCompleteBlockHistory setObject:onComplete forKey:keyNum];
    }
    
    return seerClientResponse;
}

- (SeerClientResponse*) reportTincan:(Tincan*)tincan
{
    return [self reportTincanStatement:[tincan asDictionary]];
}

- (SeerClientResponse*) reportTincanStatement:(NSDictionary*)tincanStatement
{
    SeerClientResponse* seerClientResponse = [SeerClientResponse new];
    
    ValidationResult* validTincan = [self validTincanStatement:tincanStatement];
    if ( validTincan.valid )
    {
        seerClientResponse = [self reportDataDictionary:tincanStatement
                                             toEndpoint:kSEER_TincanReport];
    }
    else
    {
        NSError* invalidTincan = [NSError errorWithDomain:kSEER_ErrorDomain
                                                     code:SeerTinCanError
                                                 userInfo:@{NSLocalizedDescriptionKey:validTincan.detail}];
        seerClientResponse.requestId = [self generateReportingId];
        seerClientResponse.error = invalidTincan;
    }
    
    return seerClientResponse;
}

- (SeerClientResponse*) reportTincan:(Tincan*)tincan
                          onComplete:(SeerRequestComplete)onComplete
{
    return [self reportTincanStatement:[tincan asDictionary]
                            onComplete:onComplete];
}

- (SeerClientResponse*) reportTincanStatement:(NSDictionary*)tincanStatement
                                   onComplete:(SeerRequestComplete)onComplete
{
    SeerClientResponse* seerClientResponse = [self reportTincanStatement:tincanStatement];
    
    if(! seerClientResponse.error)
    {
        NSNumber* keyNum = @(seerClientResponse.requestId);
        [self.requestCompleteBlockHistory setObject:onComplete forKey:keyNum];
    }
    
    return seerClientResponse;
}

- (SeerClientResponse*) reportDataDictionary:(NSDictionary*)dataDict
                                  toEndpoint:(NSString*)endpoint
{
    SeerClientResponse* seerClientResponse = [SeerClientResponse new];
    seerClientResponse.requestId = [self generateReportingId];
    seerClientResponse.requestType = endpoint;
    
    if(self.seerTokenResponse)
    {
        [self uploadSeerDataDictionary:dataDict
                            toEndpoint:endpoint
                                withId:seerClientResponse.requestId];
    }
    else
    {
        NSError* missingSeerToken = [NSError errorWithDomain:kSEER_ErrorDomain
                                                        code:SeerAuthorizationTokenError
                                                    userInfo:@{NSLocalizedDescriptionKey:@"SeerClient is missing or has an invalid authorization token"}];
        
        seerClientResponse.success = NO;
        seerClientResponse.error = missingSeerToken;
    }
    
    return seerClientResponse;
}

- (SeerClientResponse*) reportDataDictionary:(NSDictionary*)dataDict
                                  toEndpoint:(NSString*)endpoint
                                  onComplete:(SeerRequestComplete)onComplete
{
    SeerClientResponse* seerClientResponse = [self reportDataDictionary:dataDict
                                                             toEndpoint:endpoint];
    
    if(! seerClientResponse.error)
    {
        NSNumber* keyNum = @(seerClientResponse.requestId);
        [self.requestCompleteBlockHistory setObject:onComplete forKey:keyNum];
    }
    
    return seerClientResponse;
}

- (NSInteger) generateReportingId
{
    NSInteger newCnt;
    @synchronized(self)
    {
        newCnt = [self.seerQueue.dbManager getSeerQueueMaxRequestIdValue] + 1;
    }
    return newCnt;
}

/******************** REPORT CALL METHODS END ********************/

/******************** VALIDATION METHODS BEGIN ********************/

- (ValidationResult*) validActivityStream:(ActivityStream*)activityStream
{
    return [self validActivityStreamPayload:[activityStream asDictionary]];
}

- (ValidationResult*) validActivityStreamPayload:(NSDictionary*)activityStreamPayload
{
    ValidationResult* validationResult = [self.byteValidator validDataSize:activityStreamPayload];
    if (! validationResult.valid)
    {
        return validationResult;
    }
    return [self.activityStreamValidator validActivityStream:activityStreamPayload];
}

- (ValidationResult*) validInstrumentation:(ActivityStream*)instrumentation
{
    return [self validInstrumentationPayload:[instrumentation asDictionary]];
}

- (ValidationResult*) validInstrumentationPayload:(NSDictionary*)instrumentationPayload
{
    ValidationResult* validationResult = [self.byteValidator validDataSize:instrumentationPayload];
    if (! validationResult.valid)
    {
        return validationResult;
    }
    return [self.activityStreamValidator validActivityStream:instrumentationPayload];
}

- (ValidationResult*) validTincan:(Tincan*)tincan
{
    return [self validTincanStatement:[tincan asDictionary]];
}

- (ValidationResult*) validTincanStatement:(NSDictionary*)tincanStatement
{
    ValidationResult* validationResult = [self.byteValidator validDataSize:tincanStatement];
    if (! validationResult.valid)
    {
        return validationResult;
    }
    return [self.tincanValidator validTincan:tincanStatement];
}

/******************** VALIDATION METHODS END ********************/

/*********** UPLOAD METHOD FOR DIRECT REPORTING BEGIN ***********/

- (void) uploadSeerDataDictionary:(NSDictionary*)dataDict
                       toEndpoint:(NSString*)endPoint
                           withId:(NSUInteger)requestId
{
    NSString* urlString = [self.seerEndpoints urlStringForEndpoint:endPoint];
    
    if( ![urlString isEqualToString:@""])
    {
        SeerReporterComplete seerReporterOnComplete = ^ (NSData* response, int batchId, NSError* error)
        {
            BOOL success = YES;
            if (error)
            {
                success = NO;
                
                if([self shouldUpdateToken:error])
                {
                    [self requestSeerAuthorizationToken];
                }
                [self queueDataDictionary:dataDict
                              forEndpoint:endPoint
                                requestId:requestId];
            }
            
            SeerClientResponse* seerClientResponse = [SeerClientResponse new];
            seerClientResponse.success = success;
            seerClientResponse.error = error;
            seerClientResponse.requestType = endPoint;
            seerClientResponse.requestId = requestId;
            
            if([self.requestCompleteBlockHistory objectForKey:@(requestId)])
            {
                self.reportComplete = [self.requestCompleteBlockHistory objectForKey:@(requestId)];
                
                self.reportComplete(seerClientResponse);
                
                [self.requestCompleteBlockHistory removeObjectForKey:@(requestId)];
            }
            else if(self.delegate)
            {
                [self.delegate seerClientDelegateResponse:seerClientResponse];
            }
        };
        
        if (self.seerTokenResponse == nil || [self.seerTokenResponse isExpired])
        {
            [self requestSeerAuthorizationTokenAndOnComplete: ^(SeerClientResponse* seerClientResponse){
                //can check seerClientResponse but self.seerTokenResponse is what's important
                
                    [self.seerReporter reportDictionaryToSeer:dataDict
                                                        atURL:urlString
                                                    withToken:[self.seerTokenResponse tokenString]
                                                   onComplete:seerReporterOnComplete];
                
            }];
        } else {
            [self.seerReporter reportDictionaryToSeer:dataDict
                                                atURL:urlString
                                            withToken:[self.seerTokenResponse tokenString]
                                           onComplete:seerReporterOnComplete];
        }
    }
}

/*********** UPLOAD METHOD FOR DIRECT REPORTING ENDS ***********/

- (BOOL) shouldUpdateToken:(NSError*)error
{
    if(error.code == 401 && [error.localizedDescription isEqualToString:@"invalidToken"])
    {
        return YES;
    }
    return NO;
}

/********************* QUEUE METHODS BEGIN *********************/

- (SeerClientResponse*) queueActivityStream:(ActivityStream*)activityStream
{
    return [self queueActivityStreamPayload:[activityStream asDictionary]];
}

- (SeerClientResponse*) queueActivityStreamPayload:(NSDictionary*)activityStreamPayload
{
    //NSLog(@"queueActivityStreamPayload");
    SeerClientResponse* seerClientResponse = [SeerClientResponse new];
    
    ValidationResult* validActivityStream = [self validActivityStreamPayload:activityStreamPayload];
    
    if (validActivityStream.valid)
    {
        seerClientResponse = [self queueDataDictionary:activityStreamPayload
                                           forEndpoint:kSEER_ActivityStreamReport];
    }
    else
    {
        NSError* invalidActivityStream = [NSError errorWithDomain:kSEER_ErrorDomain
                                                             code:SeerActivityStreamError
                                                         userInfo:@{NSLocalizedDescriptionKey:validActivityStream.detail}];
        seerClientResponse.requestId = [self generateReportingId];
        seerClientResponse.error = invalidActivityStream;
    }
    
    return seerClientResponse;
}

- (SeerClientResponse*) queueInstrumentation:(ActivityStream*)instrumentation
{
    return [self queueInstrumentationPayload:[instrumentation asDictionary]];
}

- (SeerClientResponse*) queueInstrumentationPayload:(NSDictionary*)instrumentationPayload
{
    SeerClientResponse* seerClientResponse = [SeerClientResponse new];
    
    ValidationResult* validInstrumentation = [self validActivityStreamPayload:instrumentationPayload];
    
    if (validInstrumentation.valid)
    {
        seerClientResponse = [self queueDataDictionary:instrumentationPayload
                                           forEndpoint:kSEER_InstrumentationReport];
    }
    else
    {
        NSError* invalidInstrumentation = [NSError errorWithDomain:kSEER_ErrorDomain
                                                              code:SeerInstrumentationError
                                                          userInfo:@{NSLocalizedDescriptionKey:validInstrumentation.detail}];
        seerClientResponse.requestId = [self generateReportingId];
        seerClientResponse.error = invalidInstrumentation;
    }
    
    return seerClientResponse;
}

- (SeerClientResponse*) queueTincan:(Tincan*)tincan
{
    return [self queueTincanStatement:[tincan asDictionary]];
}

- (SeerClientResponse*) queueTincanStatement:(NSDictionary*)tincanStatement
{
    SeerClientResponse* seerClientResponse = [SeerClientResponse new];
    
    ValidationResult* validTincan = [self validTincanStatement:tincanStatement];
    if ( validTincan.valid )
    {
        seerClientResponse = [self queueDataDictionary:tincanStatement
                                           forEndpoint:kSEER_TincanReport];
    }
    else
    {
        NSError* invalidTincan = [NSError errorWithDomain:kSEER_ErrorDomain
                                                     code:SeerTinCanError
                                                 userInfo:@{NSLocalizedDescriptionKey:validTincan.detail}];
        seerClientResponse.requestId = [self generateReportingId];
        seerClientResponse.error = invalidTincan;
    }
    
    return seerClientResponse;
}

- (SeerClientResponse*) queueActivityStream:(ActivityStream*)activityStream
                                 onComplete:(SeerRequestComplete)onComplete
{
    return [self queueActivityStreamPayload:[activityStream asDictionary]
                                 onComplete:onComplete];
}

- (SeerClientResponse*) queueActivityStreamPayload:(NSDictionary*)activityStreamPayload
                                        onComplete:(SeerRequestComplete)onComplete
{
    SeerClientResponse* seerClientResponse = [self queueActivityStreamPayload:activityStreamPayload];
    
    if(! seerClientResponse.error)
    {
        NSNumber* keyNum = @(seerClientResponse.requestId);
        [self.requestCompleteBlockHistory setObject:onComplete forKey:keyNum];
    }
    
    return seerClientResponse;
}

- (SeerClientResponse*) queueInstrumentation:(ActivityStream*)instrumentation
                                  onComplete:(SeerRequestComplete)onComplete
{
    return [self queueInstrumentationPayload:[instrumentation asDictionary]
                                  onComplete:onComplete];
}

- (SeerClientResponse*) queueInstrumentationPayload:(NSDictionary*)instrumentationPayload
                                         onComplete:(SeerRequestComplete)onComplete
{
    SeerClientResponse* seerClientResponse = [self queueActivityStreamPayload:instrumentationPayload];
    
    if(! seerClientResponse.error)
    {
        NSNumber* keyNum = @(seerClientResponse.requestId);
        [self.requestCompleteBlockHistory setObject:onComplete forKey:keyNum];
    }
    
    return seerClientResponse;
}

- (SeerClientResponse*) queueTincan:(Tincan*)tincan
                         onComplete:(SeerRequestComplete)onComplete
{
    return [self queueTincanStatement:[tincan asDictionary]
                           onComplete:onComplete];
}

- (SeerClientResponse*) queueTincanStatement:(NSDictionary*)tincanStatement
                                  onComplete:(SeerRequestComplete)onComplete
{
    SeerClientResponse* seerClientResponse = [self queueTincanStatement:tincanStatement];
    
    if(! seerClientResponse.error)
    {
        NSNumber* keyNum = @(seerClientResponse.requestId);
        [self.requestCompleteBlockHistory setObject:onComplete forKey:keyNum];
    }
    
    return seerClientResponse;
}


- (SeerClientResponse*) queueDataDictionary:(NSDictionary*)dataDict
                                forEndpoint:(NSString*)endpoint
{
    NSUInteger requestId = [self generateReportingId];
    SeerClientResponse* response = [self queueDataDictionary:dataDict
                                                 forEndpoint:endpoint
                                                   requestId:requestId];
    return response;
}

- (SeerClientResponse*) queueDataDictionary:(NSDictionary*)dataDict
                                forEndpoint:(NSString*)endpoint
                                  requestId:(NSUInteger)requestId
{
    SeerClientResponse* response = [SeerClientResponse new];
    response.requestId = requestId;
    response.requestType = endpoint;
    
    //Seer Server Request
    SeerServerRequest* request = [SeerServerRequest new];
    
    id conversionToString = [request payloadAsJSONString:dataDict];
    if([conversionToString isKindOfClass:[NSError class]])
    {
        response.error = conversionToString;
        response.success = NO;
        response.queued = NO;
    }
    else
    {
        request.requestId = requestId;
        request.requestType = endpoint;
        request.requestJSON = conversionToString;
        NSLog(@"conversionToString: %@", conversionToString);
        SeerQueueResponse* qResponse = [self.seerQueue queueSeerServerRequest:request
                                                     removeOldItemsWhenFullDB:self.removeOldItemsWhenFullDB];
        
        response.queued = qResponse.success;
        response.success = qResponse.success;
        response.deletedOldestQueueItems = qResponse.deletedOldestQueueItems;
        
        if(!qResponse.success)
        {
            response.error  = qResponse.error;
        }
        
        //this is called ahead of time before sessionRequest is added to sessionHistory array - happens when this sessionRequest being the first entry
        if(self.delegate)
        {
            [self.delegate seerClientDelegateResponse:response];
        }
    }
    
    return response;
}

- (void) reportQueue
{
    if (self.seerTokenResponse == nil || [self.seerTokenResponse isExpired])
    {
        [self requestSeerAuthorizationTokenAndOnComplete: ^(SeerClientResponse* seerClientResponse){
            if (self.seerTokenResponse) {
                [self.seerQueue reportQueueWithToken:[self.seerTokenResponse tokenString]
                                        forEndpoints:self.seerEndpoints];
            }
            else {
                SeerQueueResponse* qResponse = [SeerQueueResponse new];
                qResponse.success = NO;
                [self reportQueueRequestComplete:qResponse];
            }
        }];
    }
    else
    {
        [self.seerQueue reportQueueWithToken:[self.seerTokenResponse tokenString]
                                forEndpoints:self.seerEndpoints];
    }
}

- (void) reportQueueInBackgroundComplete:(NSNotification*) notification
{
    //NSLog(@"In reportQueueInBackgroundComplete - will signal to background task...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSEER_RequestReportQueue object:nil];
    
    if (self.bgTask != UIBackgroundTaskInvalid)
    {
        NSLog(@"Ending background task...");
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
    }
}

- (NSNumber*)getQueueSize
{
    return [NSNumber numberWithInteger:[self.seerQueue.dbManager databaseSize]];
}

- (NSNumber*)getQueueItemCount
{
    return [NSNumber numberWithInteger:[self.seerQueue.dbManager requestSeerQueueRowCount]]; //[self.seerQueue requestCount]];
}

/******************** QUEUE METHODS END ********************/

/******************** TOKEN METHODS BEGINS ********************/

- (void) requestSeerAuthorizationTokenAndOnComplete:(SeerRequestComplete)onComplete
{
    //self.tokenRequestComplete = onComplete; set but not used
    [self requestSeerAuthorizationTokenWithComplete:onComplete];
}

- (void) requestSeerAuthorizationTokenWithComplete:(SeerRequestComplete)completion
{
    SeerTokenFetcher* seerTokenFetcher = [[SeerTokenFetcher alloc] initWithUrlString:[self.seerEndpoints urlStringForEndpoint:kSEER_TokenFetch]];
    seerTokenFetcher.delegate = self;
    
    NSInteger requestId = [self generateReportingId];
    [seerTokenFetcher fetchTokenWithClientId:self.clientId
                                clientSecret:self.clientSecret
                                   requestId:requestId
                                onCompletion:^(SeerTokenResponse *tokenResponse, NSError *error) {
                                    
                                    SeerClientResponse* seerClientResponse = [SeerClientResponse new];
                                    seerClientResponse.error = error;
                                    seerClientResponse.requestId = requestId;
                                    
                                    BOOL success = NO;
                                    
                                    if(tokenResponse)
                                    {
                                        self.seerTokenResponse = tokenResponse;
                                        success = YES;
                                    }
                                    else {
                                        self.seerTokenResponse = nil;
                                    }
                                    
                                    seerClientResponse.success = success;
                                    seerClientResponse.requestType = kSEER_TokenFetch;
                                    
                                    if (completion)
                                        completion(seerClientResponse);
                                    
                                    }];
}

- (void) requestSeerAuthorizationToken
{
    SeerTokenFetcher* seerTokenFetcher = [[SeerTokenFetcher alloc] initWithUrlString:[self.seerEndpoints urlStringForEndpoint:kSEER_TokenFetch]];
    //seerTokenFetcher.delegate = self;
    
    NSInteger requestId = [self generateReportingId];
    [seerTokenFetcher fetchTokenWithClientId:self.clientId
                                clientSecret:self.clientSecret
                                   requestId:requestId
                                onCompletion:^(SeerTokenResponse *tokenResponse, NSError *error) {
                                    
                                    SeerClientResponse* seerClientResponse = [SeerClientResponse new];
                                    seerClientResponse.error = error;
                                    seerClientResponse.requestId = requestId;
                                    
                                    BOOL success = NO;
                                    
                                    if(tokenResponse)
                                    {
                                        self.seerTokenResponse = tokenResponse;
                                        success = YES;
                                    }
                                    else {
                                        self.seerTokenResponse = nil;
                                    }
                                    
                                    seerClientResponse.success = success;
                                    seerClientResponse.requestType = kSEER_TokenFetch;
                                    
                                    [self dispatchNotificationForEvent:kSEER_TokenFetch object:seerClientResponse];
                                }];
}


/*
- (void) seerTokenFetchReturnData:(SeerTokenResponse*)tokenResponse
                            error:(NSError*)error
                        requestId:(NSInteger)requestId

{
    BOOL success = YES;
    if(error)
    {
        success = NO;
    }
    
    if(tokenResponse)
    {
        self.seerTokenResponse = tokenResponse;
    }
    
    SeerClientResponse* seerClientResponse = [SeerClientResponse new];
    seerClientResponse.success = success;
    seerClientResponse.error = error;
    seerClientResponse.requestId = requestId;
    seerClientResponse.requestType = kSEER_TokenFetch;
    
    [self dispatchNotificationForEvent:kSEER_TokenFetch object:seerClientResponse];
}
*/
/******************** TOKEN METHODS END ********************/

/******************** SEERQUEUE DELEGATE METHODS BEGINS ********************/

- (void) reportQueueRequestBatch:(SeerClientBatchResponse*)seerClientBatchResponse
{
    //NSLog(@"SEERCLIENT reportQueueRequestItem response: %@", seerClientResponse);
    if (self.receiveQueuedItemResponses)
    {
        if (self.delegate)
        {
            //[self.delegate seerClientDelegateResponse:seerClientBatchResponse];
            [self.delegate seerClientDelegateBatchResponse:seerClientBatchResponse];
        }
        
        [self dispatchNotificationForEvent:kSEER_RequestResultForQueuedBatch object:seerClientBatchResponse];
    }
}


- (void) reportQueueRequestComplete:(SeerQueueResponse*)qResponse
{
    //NSLog(@"Reporting queue complete delegate method running...on thread %@", [NSThread currentThread]);
    [self dispatchNotificationForEvent:kSEER_RequestReportQueue object:nil];
}

/******************** SEERQUEUE DELEGATE METHODS END ********************/

- (void) dispatchNotificationForEvent:(NSString*)event object:(NSObject*)obj
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:event object:obj];
    });
}

@end
