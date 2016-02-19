//
//  SeerReporter.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/17/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tincan.h"

@protocol SeerReporterDelegate <NSObject>

- (void) seerReporterResponse:(NSString*)response
                        error:(NSError*)err;

@end

typedef void (^SeerReporterComplete)(NSData*, int, NSError*);

@interface SeerReporter : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, weak) id delegate;

- (void) reportDictionaryToSeer:(NSDictionary*)dataDict
                          atURL:(NSString*)urlString
                      withToken:(NSString*)token
                     onComplete:(SeerReporterComplete)onComplete;

- (void) reportJSONStringToSeer:(NSString*)jsonString
                          atURL:(NSString*)urlString
                      withToken:(NSString*)token
                     forBatchId:(int)batchId
                     onComplete:(SeerReporterComplete)onComplete;

@end
