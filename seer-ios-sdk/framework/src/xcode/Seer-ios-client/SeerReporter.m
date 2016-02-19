//
//  SeerReporter.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/17/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "SeerReporter.h"
#import "SeerEndpoints.h"
#import "SeerClientErrors.h"

@interface SeerReporter ()

@property (nonatomic, strong) NSOperationQueue* queue;
@property (nonatomic, strong) NSMutableData* responseData;
@property (nonatomic, strong) NSURLResponse *response;

@property (nonatomic,readwrite) NSTimeInterval timeout;

@property (nonatomic, strong) SeerEndpoints* seerEndpoints;

@property (nonatomic,readwrite, strong) SeerReporterComplete onComplete;

@end

@implementation SeerReporter

- (id) init
{
    if(self = [super init])
    {
        self.queue      = [[NSOperationQueue alloc] init];
        self.timeout    = 10.0;
    }
    return self;
}

- (void) reportDictionaryToSeer:(NSDictionary*)dataDict
                          atURL:(NSString*)urlString
                      withToken:(NSString*)token
                     onComplete:(SeerReporterComplete)onComplete
{
    int batchId = 0;
    NSLog(@"Json dictionary to send to SEER: %@", dataDict);
    NSLog(@"...with this URL: %@", urlString);
    NSLog(@"...and with token: %@", token);
    
    NSData* jsonData = [self convertDataDictToJSONData:dataDict];
    
    //check jsonData here, if nil then do onComplete
    if (!jsonData) {
        NSError* error = [self seerReporterErrorMessage:@"SeerReporter could not convert to JSON data object in report."];
        onComplete(nil, batchId, error);
        return;
    }
    
    
    
    [self reportDataToSeer:jsonData
                     atURL:urlString
                 withToken:token
                forBatchId:batchId
                onComplete:onComplete];
}


- (NSData*) convertDataDictToJSONData:(NSDictionary*)activityStream
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:activityStream
                                                       options:kNilOptions
                                                         error:&error];
    return jsonData;
}

- (void) reportJSONStringToSeer:(NSString*)jsonString
                          atURL:(NSString*)urlString
                      withToken:(NSString*)token
                       forBatchId:(int)batchId
                     onComplete:(SeerReporterComplete)onComplete
{
    NSLog(@"Json string to send to SEER: %@",jsonString);
    NSLog(@"...with this URL: %@", urlString);
    NSLog(@"...and with token: %@", token);
    
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    [self reportDataToSeer:jsonData
                     atURL:urlString
                 withToken:token
                forBatchId:batchId
                onComplete:onComplete];
}

- (void) reportDataToSeer:(NSData*)jsonData
                    atURL:(NSString*)urlString
                withToken:(NSString*)token
               forBatchId:(int)batchId
               onComplete:(SeerReporterComplete)onComplete
{
    self.onComplete = onComplete;//not used though
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:self.timeout];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:jsonData];
    
    [self performNetworkCallWithRequest:request
                   andCompletionHandler:onComplete
                                batchId:batchId];
}


- (NSError*) seerReporterErrorMessage:(NSString*)errorStr
{
    NSError* error = [[NSError alloc] initWithDomain:@"SeerReporter"
                                                code:SeerReporterError
                                            userInfo:@{NSLocalizedDescriptionKey:errorStr}];
    return error;
}

-(void) performNetworkCallWithRequest:(NSURLRequest*)request
                 andCompletionHandler:(SeerReporterComplete)onComplete
                              batchId:(int)batchId {
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *sessionDataTask =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   [self handleResponse:response withData:data error:error batchId:batchId OnComplete:onComplete];
               }];
    
    [sessionDataTask resume];
}

-(void) handleResponse:(NSURLResponse*)response
              withData:(NSData*)data
                 error:(NSError*)error
               batchId:(int)batchId
            OnComplete:(SeerReporterComplete)onComplete {
    if (error) {
        NSLog(@"Networking error: %@", error.description);
        onComplete(nil, batchId, [self seerReporterErrorMessage:@"Error executing NSURL session task"]);
    }
    else {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
            NSInteger httpStatusCode = [httpURLResponse statusCode];
            NSLog(@"[HTTP statusCode is] %ld - on thread %@", (long)httpStatusCode, [NSThread currentThread]);
            if (httpStatusCode >= 200 && httpStatusCode < 300) { //200-level success
                NSLog(@"Executing onComplete in completion of network requester.");
                onComplete(data, batchId, nil);
            }
            else {
                onComplete(data, batchId, [self seerReporterErrorMessage:@"Non-200 HTTP status code"]);
            }
        }
        else {
            onComplete(nil, batchId, [self seerReporterErrorMessage:@"Response type is not NSHTTPURLResponse"]);
        }
    }
}

@end
