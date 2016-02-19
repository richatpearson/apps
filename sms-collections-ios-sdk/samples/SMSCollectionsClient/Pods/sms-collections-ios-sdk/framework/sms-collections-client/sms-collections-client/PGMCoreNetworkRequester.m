//
//  PGMCoreNetworkRequester.m
//  gridmobilesdk
//
//  Created by Richard Rosiak on 11/11/14.
//  Copyright (c) 2014 Richard Rosiak. All rights reserved.
//

#import "PGMCoreNetworkRequester.h"
#import "PGMSmsError.h"

@implementation PGMCoreNetworkRequester

-(void) performNetworkCallWithRequest:(NSURLRequest*)request
                 andCompletionHandler:(NetworkRequestComplete)onComplete {
    //NSLog(@"In Core network requester....");
    if (!request) {
        NSError *noRequestError = [PGMSmsError createErrorForErrorCode:PGMSmsNetworkCallError
                                                        andDescription:@"No request for network call"];
        onComplete(nil, nil, noRequestError);
    }
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *sessionDataTask =
        [session dataTaskWithRequest:request
                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                              [self handleResponse:response withData:data error:error OnComplete:onComplete];
                          }];
    
    [sessionDataTask resume];
}

-(void) handleResponse:(NSURLResponse*)response
              withData:(NSData*)data
                 error:(NSError*)error
            OnComplete:(NetworkRequestComplete)onComplete {
    if (error) {
        NSLog(@"Networking error: %@", error.description);
        onComplete(nil, response, [PGMSmsError createErrorForErrorCode:PGMSmsNetworkCallError
                                              andDescription:@"Error executing NSURL session task"]);
    }
    else {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
            NSInteger statusCodeNSInteger = [httpURLResponse statusCode];
            NSLog(@"[statusCodeNSInteger] %ld", (long)statusCodeNSInteger);
            if (statusCodeNSInteger >= 200 && statusCodeNSInteger < 300) { //200-level success
                //NSLog(@"Executing onComplete in completion of network requester.");
                onComplete(data, response, nil);
            }
            else {
                onComplete(data, response, [PGMSmsError createErrorForErrorCode:PGMSmsNetworkCallError
                                                       andDescription:@"Non-200 HTTP status code"]);
            }
        }
        else {
            onComplete(nil, response, [PGMSmsError createErrorForErrorCode:PGMSmsNetworkCallError
                                                  andDescription:@"Response type is not NSHTTPURLResponse"]);
        }
    }
}

@end
