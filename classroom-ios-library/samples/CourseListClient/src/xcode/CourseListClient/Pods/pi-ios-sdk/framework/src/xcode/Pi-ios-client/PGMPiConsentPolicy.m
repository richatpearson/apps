//
//  PGMPiConsentPolicy.m
//  Pi-ios-client
//
//  Created by Richard Rosiak on 6/13/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiConsentPolicy.h"

@implementation PGMPiConsentPolicy

- (id) initWithPolicyId:(NSString*)policyId
             consentUrl:(NSString*)consentUrl
            isConsented:(BOOL)isConsented
             isReviewed:(BOOL)isReviewed
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    self.policyId = policyId;
    self.consentPageUrl = consentUrl;
    self.isConsented = isConsented;
    self.isReviewed = isReviewed;
    
    return self;
}

@end
