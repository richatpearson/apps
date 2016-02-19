//
//  PGMPiClientLoginOptions.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 6/2/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiClientLoginOptions.h"

@interface PGMPiClientLoginOptions ()

@property (nonatomic, assign, readwrite) BOOL requestTokens;
@property (nonatomic, assign, readwrite) BOOL requestUserId;

@end

@implementation PGMPiClientLoginOptions

- (id)init
{
    self = [super init];
    if( self )
    {
//        self.requestAccessCode = YES;
        
        // Not configurable
        self.requestTokens = YES;
        self.requestUserId = YES;
        
        // Configurable
        self.requestAffiliation = NO;
        self.requestConsent = NO;
        self.requestCredentials = NO;
        self.requestEscrow = NO;
        self.requestFederatedCredentials = NO;
        self.requestAlternateId = NO;
        self.requestIdentityEmail = NO;
        self.requestIdentityProfile = NO;
        self.requestIdentityProvider = NO;
        self.requestIdentity = NO;
        self.requestUserComposite = NO;
    }
    
    return self;
}

- (NSString*) description
{
    NSMutableString *desc = [NSMutableString new];
    [desc appendFormat:@"Pi Client Login Options"];
    [desc appendFormat:@": Request Tokens: %@", self.requestTokens?@"YES":@"NO"];
    [desc appendFormat:@": Request User Id: %@", self.requestUserId?@"YES":@"NO"];
    [desc appendFormat:@": Request Affiliation: %@", self.requestAffiliation?@"YES":@"NO"];
    [desc appendFormat:@": Request Consent: %@", self.requestConsent?@"YES":@"NO"];
    [desc appendFormat:@": Request Credentials: %@", self.requestCredentials?@"YES":@"NO"];
    [desc appendFormat:@": Request Alternate Id: %@", self.requestEscrow?@"YES":@"NO"];
    [desc appendFormat:@": Request Tokens: %@", self.requestFederatedCredentials?@"YES":@"NO"];
    [desc appendFormat:@": Request Tokens: %@", self.requestAlternateId?@"YES":@"NO"];
    [desc appendFormat:@": Request Identity Emails: %@", self.requestIdentityEmail?@"YES":@"NO"];
    [desc appendFormat:@": Request Identity Profile: %@", self.requestIdentityProfile?@"YES":@"NO"];
    [desc appendFormat:@": Request Identity Providers: %@", self.requestIdentityProvider?@"YES":@"NO"];
    [desc appendFormat:@": Request Identity: %@", self.requestIdentity?@"YES":@"NO"];
    [desc appendFormat:@": Request User Composite: %@", self.requestUserComposite?@"YES":@"NO"];
    
    return desc;
}

@end
