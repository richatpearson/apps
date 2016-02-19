//
//  PGMAppDelegate.h
//  PiClient
//
//  Created by Richard Rosiak on 5/29/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Pi-ios-client/PGMPiClient.h>
#import <Pi-ios-client/PGMPiCredentials.h>
#import "PGMPiLoginViewController.h"

@interface PGMPiAppDelegate : UIResponder <UIApplicationDelegate, PGMPiClientDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) PGMPiCredentials *piCredentials;
@property (nonatomic, strong) PGMPiToken *piToken;
@property (nonatomic, strong) NSArray *consentPolicies;
@property (nonatomic, strong) NSString *currentUsername;
@property (nonatomic, strong) NSString *currentPassword;
@property (nonatomic, strong) PGMPiLoginViewController *loginView;

- (BOOL) storeUsername:(NSString*)username andPassword:(NSString*)password;

- (PGMPiCredentials*) retrieveCredentials;

-(BOOL) deleteCredentials;

-(void) loginWithUsername:(NSString*)username
                 password:(NSString*)password
                  options:(PGMPiClientLoginOptions*)options
         storeCredentials:(BOOL)storeCreds;

- (PGMPiResponse *) checkToken;
- (void) tokenRefresh;

- (void) logout;

- (PGMPiClientLoginOptions*)getLoginOptions;

- (void) submitConsentPolicies:(NSArray*)policies;

- (void) forgotPasswordForUsername:(NSString*)userName;

- (void) forgotUsernameForEmail:(NSString*)email;

//- (void) addLoginObservers;

@end
