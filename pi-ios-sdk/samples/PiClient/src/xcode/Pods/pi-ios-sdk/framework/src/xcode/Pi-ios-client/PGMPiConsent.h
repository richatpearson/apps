//
//  PGMPiConsent.h
//  Pi-ios-client
//
//  Created by Richard Rosiak on 6/13/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMPiEnvironment.h"

//typedef void (^ConsentPostComplete)(PGMPiResponse*);

@interface PGMPiConsent : NSObject

@property (nonatomic, strong) NSArray *consentPolicies;

-(NSArray*) requestPoliciesWithEscrowTicket:(NSString*)ticket
                                 environment:(PGMPiEnvironment*)environment;

-(void) postConsentForPolicyIds:(NSArray*)policyIds
                andEscrowTicket:(NSString*)escrowTicket
                 forEnvironment:(PGMPiEnvironment*)environment
             withResponseObject:(PGMPiResponse*)response
                      onComplete:(PiRequestComplete)onComplete;

@end
