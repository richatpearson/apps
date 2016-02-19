//
//  PGMPiClientLoginOptions.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 6/2/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMPiClientLoginOptions : NSObject

@property (nonatomic, assign, readonly) BOOL requestTokens;
@property (nonatomic, assign, readonly) BOOL requestUserId;

@property (nonatomic, assign) BOOL requestAffiliation;
@property (nonatomic, assign) BOOL requestConsent;
@property (nonatomic, assign) BOOL requestCredentials;
@property (nonatomic, assign) BOOL requestEscrow;
@property (nonatomic, assign) BOOL requestFederatedCredentials;
@property (nonatomic, assign) BOOL requestAlternateId;
@property (nonatomic, assign) BOOL requestIdentityEmail;
@property (nonatomic, assign) BOOL requestIdentityProfile;
@property (nonatomic, assign) BOOL requestIdentityProvider;
@property (nonatomic, assign) BOOL requestIdentity;
@property (nonatomic, assign) BOOL requestUserComposite;

@end
