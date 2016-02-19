//
//  PGMCoreSessionAuthorizationDelegate.h
//  Core-ios-sdk
//
//  Created by Darrel Wright on 7/15/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PGMCoreSessionManager;

@protocol PGMCoreSessionAuthorizationDelegate <NSObject>

- (void) coreSessionManager:(PGMCoreSessionManager*)manager
                       task:(NSURLSessionTask *)task
        didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
          completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler;

- (void) coreSessionManager:(PGMCoreSessionManager*)manager
        didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
          completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler;

- (void) coreSessionManager:(PGMCoreSessionManager*)manager
        authenticateRequest:(NSMutableURLRequest *)request
        withCompletionBlock:(void (^)(NSMutableURLRequest *authenticatedRequest))completionBlock;

@end
