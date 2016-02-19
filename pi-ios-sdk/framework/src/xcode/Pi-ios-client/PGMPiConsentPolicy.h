//
//  PGMPiConsentPolicy.h
//  Pi-ios-client
//
//  Created by Richard Rosiak on 6/13/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMPiConsentPolicy : NSObject

@property (nonatomic, strong) NSString *policyId;
@property (nonatomic, strong) NSString *consentPageUrl;
@property (nonatomic, assign) BOOL isConsented;
@property (nonatomic, assign) BOOL isReviewed;

- (id) initWithPolicyId:(NSString*)policyId
             consentUrl:(NSString*)consentUrl
            isConsented:(BOOL)isConsented
             isReviewed:(BOOL)isReviewed;

@end
