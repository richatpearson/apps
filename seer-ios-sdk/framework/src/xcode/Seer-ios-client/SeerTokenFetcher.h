//
//  SeerTokenFetcher.h
//  Seer-ios-client
//
//  Created by Tomack, Barry on 12/16/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerTokenResponse.h"

typedef void (^SeerTokenFetcherBlock)(SeerTokenResponse *tokenResponse, NSError *error);

@protocol SeerTokenFetchDelegate <NSObject>

- (void) seerTokenFetchReturnData:(SeerTokenResponse*)tokenResponse
                            error:(NSError*)err
                        requestId:(NSInteger)requestId;

@end

@interface SeerTokenFetcher : NSObject <NSURLConnectionDelegate>

@property (nonatomic, weak) id delegate;

- (id) initWithUrlString:(NSString*)urlString;

- (void) fetchTokenWithClientId:(NSString*)username
                    clientSecret:(NSString*)password
                      requestId:(NSInteger)requestId
                 onCompletion:(SeerTokenFetcherBlock)completion;

@end
