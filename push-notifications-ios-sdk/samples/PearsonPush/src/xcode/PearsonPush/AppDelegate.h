//
//  AppDelegate.h
//  PearsonPush
//
//  Created by Tomack, Barry on 8/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <PushNotifications/PearsonPushNotifications.h>
#import "NotificationHistory.h"
#import "RumbaUtility.h"
#import "SMSUtility.h"

#import <Pi-ios-client/PGMPiClient.h>

#define PI_AUTHENTICATION_SUCCESS @"piAuthenticationSuccess"
#define PI_AUTHENTICATION_FAILURE @"piAuthenticationFailure"

/**
 Stored Notifications data was updated (a new one was received or the data was cleared)
 */

@interface AppDelegate : UIResponder <UIApplicationDelegate, RumbaUtilityDelegate, SMSUtilityDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PearsonPushNotifications* pushNotifications;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) NSString* pushApiKey;
@property (nonatomic, strong) NSString* orgID;
@property (nonatomic, strong) NSString* appID;
@property (nonatomic, strong) NSString* notificationBaseURL;

@property (nonatomic, strong) RumbaUtility* rumbaUtility;
@property (nonatomic, strong) SMSUtility *smsUtility;

@property (nonatomic, strong) PGMPiClient *piClient;

@property (nonatomic, weak) id registrationDelegate;

@property (nonatomic, weak) NSString* clientId;
@property (nonatomic, weak) NSString* authorizationValue;

@property (nonatomic, assign) NSUInteger authProvider;

- (void)alert:(NSString *)message title:(NSString *)title;

/**
 Object used for storing notifications coming into app.
 The total number of notifcations stored is determined by the capacity set in the intialization method.
 This object is never allocated if the capacity is set to 0.
 */
@property (strong, nonatomic) NotificationHistory* notificationHistory;

- (UIButton*) styleButton:(UIButton*)button;

- (void) loginWithUsername:(NSString*)username
                  password:(NSString*)password
              authProvider:(NSUInteger)authProvider;

- (void) logout;

- (void) unregisterWithAppServices;

- (NSString*) currentUserId;
- (NSString*) currentAuthToken;

- (void) addUserToGroup:(NSString*)groupName;
- (void) removeUserFromGroup:(NSString*)groupName;

@end
