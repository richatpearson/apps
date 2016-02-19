//
//  AppDelegate.m
//  PearsonPush
//
//  Created by Tomack, Barry on 8/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "AppDelegate.h"
//#import "TestFlight.h"
#import "OpeningViewController.h"
#import <PushNotifications/PearsonPushNotifications.h>
#import <PearsonAppServicesiOSSDK/PearsonMonitoringOptions.h>
#import <PearsonAppServicesiOSSDK/PearsonMonitoringClient.h>
#import "NotificationHistory.h"
#import <PearsonAppServicesiOSSDK/PearsonLogger.h>

#import <Pi-ios-client/PGMPiClient.h>
#import <Pi-ios-client/PGMPiEnvironment.h>

typedef NS_ENUM(NSUInteger, AuthenticationEnvironment) {
    Staging = 0,
    Prod
};

@interface AppDelegate ()

@property (nonatomic, assign) AuthenticationEnvironment authEnvironment;

@property (nonatomic, strong) NSString *identityId;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString* bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    [self setNotificationProperties: bundleName];
    
    if([bundleName isEqualToString:@"MobileApp4"] || [bundleName isEqualToString:@"MobileAppDemo"])
    {
        // Initialize PushNotifications with default monitoring
        self.pushNotifications = [[PearsonPushNotifications alloc] initWithOrganization:self.orgID
                                                                            application:self.appID
                                                                                 apiKey:self.pushApiKey
                                                                      monitoringOptions:[self userDefaultMonitoringOptions]
                                                                                baseURL:self.notificationBaseURL];
    }
    else
    {
        // Initialize PushNotifications with no monitoring
        PearsonMonitoringOptions* monitoringOptions = [[PearsonMonitoringOptions alloc] init];
        monitoringOptions.monitoringEnabled = NO;
        
        self.pushNotifications = [[PearsonPushNotifications alloc] initWithOrganization:self.orgID
                                                                            application:self.appID
                                                                                 apiKey:self.pushApiKey
                                                                      monitoringOptions:monitoringOptions
                                                                                baseURL:self.notificationBaseURL];
    }
    
    [self.pushNotifications showLogging:YES];
    
    [self.pushNotifications registerApplicationWithAPN:[PearsonPushNotificationType getTypeWithBadge:YES Sound:YES Alert:YES Newsstand:NO]];
    
    [self.pushNotifications notifyWhenNetworkChangesOccur:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kPN_NetworkConnectionChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:kPN_IncomingNotification object:nil];
    
    // Forward any notification info in the launch options to the application
    if(launchOptions != nil)
    {
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
            [self application:application didReceiveRemoteNotification:dictionary];
        }
    }
    
    // Initialize app's notification storage
    self.notificationHistory = [[NotificationHistory alloc] initWithCapacity: 50];
    
    // Set up to play custom sound file played in AVAudioPlayer when notification is received
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Jungle.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    // Pi Client
    [self setPiClientProperties:bundleName];
    
    PearsonLogDebug(@"AppDelegate", @"PearsonPush AppDelegate didFinishLaunching %@", bundleName);
#ifdef DEBUG
    PearsonLogDebug(@"AppDelegate", @"PearsonPush AppDelegate in Debug mode");
#endif
    return YES;
}

- (PearsonMonitoringOptions*) userDefaultMonitoringOptions
{
    PearsonMonitoringOptions* monitoringOptions = [[PearsonMonitoringOptions alloc] init];
    // Get User Default Settings
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"monitoringEnabled"]) {
        monitoringOptions.monitoringEnabled = [defaults boolForKey:@"monitoringEnabled"];
    }
    if ([defaults valueForKey:@"crashReportingEnabled"]) {
        monitoringOptions.crashReportingEnabled = [defaults boolForKey:@"crashReportingEnabled"];
    }
    if ([defaults valueForKey:@"interceptNetworkCalls"]) {
        monitoringOptions.interceptNetworkCalls = [defaults boolForKey:@"interceptNetworkCalls"];
    }
    if ([defaults valueForKey:@"showDebuggingInfo"]) {
        monitoringOptions.showDebuggingInfo = [defaults boolForKey:@"showDebuggingInfo"];
    }
    
    return monitoringOptions;
}

// Properties for each of the apps in this project
- (void) setNotificationProperties:(NSString*)bundleName
{
    if ([bundleName isEqualToString:@"MobileApp4"])
    {
        self.orgID = @"pearsonlt";
        self.appID = @"mobileapp4";
        self.pushApiKey = @"1AJAR9Ll6XzK6CGh3lPsyMVZ7ywxq6Yh";
        self.notificationBaseURL = @"https://pearsonbuild-staging.apigee.net/mobile/appservices/";
        //self.notificationBaseURL = @"http://pearsonbuild-dev.apigee.net/mobile/appservices/";
        //[TestFlight takeOff:@"34522de0-12e3-4259-bbfe-e9fd3a007537"];
        self.clientId = @"uHYY8AYBGzLuDZmeAlxsEEzCrhAZd2lE";
        self.authorizationValue = @"dUhZWThBWUJHekx1RFptZUFseHNFRXpDcmhBWmQybEU6ZktDSWVBWnplRkpwaU50MA==";
        self.authEnvironment = Staging;
    }
    else if ([bundleName isEqualToString:@"MobileAppDemo"])
    {
        self.orgID = @"demo";
        self.appID = @"pushdemo-test";
        self.pushApiKey = @"VgMypFtR2l1UAAUS0NA2OTwkyQwpoFgc";
        self.notificationBaseURL = @"https://mobileservices.openclasslabs.com/appservices/";
        //[TestFlight takeOff:@"34522de0-12e3-4259-bbfe-e9fd3a007537"];
        self.clientId = @"SQ9SBg1af8Lboj9AbWDAM4gFy7fnZNB4";
        self.authorizationValue = @"U1E5U0JnMWFmOExib2o5QWJXREFNNGdGeTdmblpOQjQ6SlBJTkVJS1ZlbkFoVHJodg==";
        self.authEnvironment = Prod;
    }
}

- (void) setPiClientProperties:(NSString*)bundleName
{
    if (self.authEnvironment == Staging)
    {
        self.piClient = [[PGMPiClient alloc] initWithClientId:@"wkLZmUJAsTSMbVEI9Po6hNwgJJBGsgi5"
                                                 clientSecret:@"SAftAexlgpeSTZ7n"
                                                  redirectUrl:@"http://int-piapi.stg-openclass.com/pi_group12client"];
        
        [self.piClient setEnvironment:[PGMPiEnvironment stagingEnvironment]];
    }
    else if (self.authEnvironment == Prod)
    {
        self.piClient = [[PGMPiClient alloc] initWithClientId:@"GgXYn6HjbT2CzKXm5jh9aIGC7htBNWk1"
                                                 clientSecret:@"pKAsAPi4DAEPesbw"
                                                  redirectUrl:@"http://piapi.openclass.com/pi_group12client"];
        
        [self.piClient setEnvironment:[PGMPiEnvironment productionEnvironment]];
    }
}

// Protocol Methods
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self.pushNotifications application:application didRegisterWithNewDeviceToken:deviceToken];
    NSLog(@"AppDelegate didRegisterForRemoteNotificationsWithDeviceToken");
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
    [self alert: error.localizedDescription title: @"Push Registration Error"];
    [self.pushNotifications application:application didFailToRegisterWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"AppDelegate didReceiveRemoteNotification: %@", userInfo);
    
    [self.pushNotifications application:application didReceivePushNotification:userInfo];
}

- (void)notificationReceived:(NSNotification*)nsNotification
{
    PearsonNotification* notification = (PearsonNotification*)nsNotification.object;
    NSLog(@"AppDelelgate Notification Received: %@", notification);
    
    if (notification.alert)
    {
        [self alert:notification.alert title:@"Incoming Notification"];
    }
    else if (notification.alertDict)
    {
        if ([notification.alertDict objectForKey:@"body"])
        {
             [self alert:[notification.alertDict objectForKey:@"body"] title:@"Incoming Notification"];
        }
        else
        {
            [self alert:[notification.alertDict description] title:@"Incoming Notification"];
        }
    }
    [self playCustomSound];
    // Store the notification
    if (self.notificationHistory.capacity > 0)
    {
        if ([self.notificationHistory addToHistory:notification])
        {
            if(self.pushNotifications.applicationIsRegisteredForNotifications && self.pushNotifications.userIsRegisteredWithAppServices)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPN_NotificationsUpdate object:nil];
                });
            }
        }
    }
}

- (void) loginWithUsername:(NSString*)username
                  password:(NSString*)password
              authProvider:(NSUInteger)authProvider
{
    self.authProvider = authProvider;
    if(authProvider == 0)
    {
        [self piLoginWithUser:username
                     password:password];
    }
    if(authProvider == 1)
    {
        [self rumbaLoginWithUser:username
                        password:password];
    }
    if(authProvider == 2)
    {
        [self smsLoginWithUser:username
                      password:password];
    }
}

- (void) logout
{
    [self unregisterWithAppServices];
    if(self.authProvider == 0)
    {
        [self logoutPi];
    }
    if(self.authProvider == 1)
    {
        [self logoutRumba];
    }
    if(self.authProvider == 2)
    {
        [self logoutSMS];
    }
}

#pragma mark Rumba Authentication - BEGIN
- (void) rumbaLoginWithUser:(NSString*)username
                   password:(NSString*)password
{
    self.rumbaUtility = [self setRumbaUtilityForEnvironment:self.authEnvironment]; //[RumbaUtility new];
    self.rumbaUtility.delegate = self;
    
    [self.rumbaUtility requestRumbaAuthenticationWithUsername:username
                                                     password:password];
}

-(RumbaUtility*) setRumbaUtilityForEnvironment:(AuthenticationEnvironment)environment
{
    RumbaUtility *utility = [RumbaUtility new];
    
    NSLog(@"Auth env is %lu", (long)environment);
    
    if (environment == Staging) {
        [utility setTokenPath:@"https://sso.rumba.int.pearsoncmg.com/sso/loginService?service=https://cert.api.pearsoncmg.com/authentication/v1/user/authentication/okurl?authservice=rumbasso&gateway=true&username=%@&password=%@"];
        [utility setIdRetrievalPath:@"https://cert.api.pearsoncmg.com/authentication/v1/user/authentication/validate?api_key=2d946ef787869984f5af49179e6c49de"];
    }
    if (environment == Prod) {
        [utility setTokenPath:@"https://sso.rumba.pearsoncmg.com/sso/loginService?service=https://api.pearsoncmg.com/authentication/v1/user/authentication/okurl?authservice=rumbasso&gateway=true&username=%@&password=%@"];
        [utility setIdRetrievalPath:@"https://api.pearsoncmg.com/authentication/v1/user/authentication/validate?api_key=cfed90570890b0635ccc8b97072c86c3"];
    }
    
    return utility;
}

- (void) logoutRumba
{
    [self.rumbaUtility clearRumbaAuthentication];
}

- (void)rumbaAuthenticationFailed:(NSError*)error
{
    NSLog(@"RumbaAuthenticationFailed: %@", error);
    NSString* errorMsg = [NSString stringWithFormat:@"%@. Code: %ld", error.localizedDescription, (long)error.code];
    [self alert:errorMsg title:@"Authentication Error"];
}

- (void)rumbaAuthenticationSuccess:(RumbaResponse*)response
{
    NSLog(@"APPDELEGATE RumbaAuthenticationSuccess token: %@ ::: userId: %@", [response authToken], [response userId]);
    [self.pushNotifications authenticationProvider:PearsonMIAuthentication];
    [self registerWithAppsServicesWithAuthToken:[response authToken]
                                         userId:[response userId]];
}

#pragma mark Rumba Authentication - END


#pragma mark SMS Authentication - BEGIN
- (void) smsLoginWithUser:(NSString*)username
                 password:(NSString*)password
{
    self.smsUtility = [self setSMSUtilityForEnvironment:self.authEnvironment];  //[[SMSUtility alloc] init];
    self.smsUtility.delegate = self;
    
    [self.smsUtility requestSMSAuthenticationWithUsername:username
                                                 password:password];
}

-(SMSUtility*) setSMSUtilityForEnvironment:(AuthenticationEnvironment)environment {
    SMSUtility *utility = [[SMSUtility alloc] init];
    
    NSLog(@"Auth env is %lu", (long)environment);
    
    if (environment == Staging) {
        [utility setAuthenticationPath:@"https://cert.api.pearsoncmg.com/authentication/v1/user/authentication/login"];
    }
    if (environment == Prod) {
        [utility setAuthenticationPath:@"https://api.pearsoncmg.com/authentication/v1/user/authentication/login"];
    }
    
    return utility;
}

- (void) logoutSMS
{
    [self.smsUtility clearSMSAuthentication];
}

- (void)smsAuthenticationFailed:(NSError*)error
{
    NSLog(@"SMSAuthenticationFailed: %@", error);
    NSString* errorMsg = [NSString stringWithFormat:@"%@. Code: %ld", error.localizedDescription, (long)error.code];
    [self alert:errorMsg title:@"Authentication Error"];
}

- (void)smsAuthenticationSuccess:(SMSResponse*)response
{
    NSLog(@"APPDELEGATE SMSAuthenticationSuccess token: %@ ::: userId: %@", [response authToken], [response userId]);
    [self.pushNotifications authenticationProvider:PearsonMIAuthentication];
    [self registerWithAppsServicesWithAuthToken:[response authToken]
                                         userId:[response userId]];
}

#pragma mark Pi Authentication - END

#pragma mark Pi Authentication - BEGIN
- (void) piLoginWithUser:(NSString*)username
                password:(NSString*)password
{
    PiRequestComplete loginCompletionHandler = ^(PGMPiResponse *response)
    {
        if(response.error)
        {
            NSLog(@"The error desc from login is %@ with code of %lu", response.error.description, (long)response.error.code);
            NSString *errorStr = @"";
            if (response.error.code == 3840) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:PI_AUTHENTICATION_FAILURE object:response];
                });
                errorStr = @"Bad Credentials. the username or password used was incorrect.";
            }
            else if (response.error.code == 7) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:PI_AUTHENTICATION_FAILURE object:response];
                });
                errorStr = @"No consent on file.";
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:PI_AUTHENTICATION_FAILURE object:response];
                });
                errorStr = @"there was an error loggin into the service. Please try again.";
            }
            
            NSString* errorMsg = [NSString stringWithFormat:@"%@. Code: %ld", errorStr, (long)response.error.code];
            [self alert:errorMsg title:@"Authentication Error"];
        }
        else
        {
            NSLog(@"PiClientApp LOGINCOMPLETE token: %@ ::: Credentials: %@", [response getObjectForOperationType:PiTokenOp], [response getObjectForOperationType:PiUserIdOp]);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginComplete" object:response];
//            });
            [self.pushNotifications authenticationProvider:PearsonPIAuthentication];
            PGMPiToken *piToken = [response getObjectForOperationType:PiTokenOp];
            PGMPiCredentials *creds = [response getObjectForOperationType:PiUserIdOp];
            
            NSLog(@"AccessToken: %@", piToken.accessToken);
            NSLog(@"userId: %@", creds.identity.identityId);
            self.identityId = creds.identity.identityId;
            [self registerWithAppsServicesWithAuthToken:[NSString stringWithFormat:@"Bearer %@", piToken.accessToken ]
                                                 userId:self.identityId];
        }
    };
    
    self.piClient.secureStoreCredentials = NO;
    
    [self.piClient loginWithUsername:username
                            password:password
                             options:nil
                          onComplete:loginCompletionHandler];
}

- (void) logoutPi
{
    [self.piClient logout];
}


#pragma mark Pi Authentication - END


- (void) registerWithAppsServicesWithAuthToken:(NSString*)authToken
                                        userId:(NSString*)userId
{
    [self.pushNotifications registerWithAppServicesUsingAuthorizationToken:authToken
                                                                    userId:userId];
}

- (void) unregisterWithAppServices
{
    NSString* authToken = [self currentAuthToken];
    NSString* userId = [self currentUserId];
    NSLog(@"APP DELEGATE unregisterWithAppServices: authToken: %@", authToken);
    if(authToken != nil)
    {
        [self.pushNotifications unregisterWithAppServicesUsingAuthorizationToken:authToken
                                                                          userId:userId];
    }
}

- (void)alert:(NSString *)message title:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
                                                        message: message
                                                       delegate: self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
    [alertView show];
}

- (void) playCustomSound
{
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.volume = 0.15;
    
    if (self.audioPlayer == nil)
    {
        NSLog(@"Error playing notification sound effect");
    }
    else
    {
        [self.audioPlayer play];
    }
}

- (void) storeNotification:(PearsonNotification*)notification
{
    if(self.notificationHistory.capacity > 0)
    {
        [self.notificationHistory addToHistory: notification];
        // Update anything watching for a change in the notifications array
    }
}

- (void) clearStoredNotifications
{
    if (self.notificationHistory.capacity > 0)
    {
        NSString* userId = [self currentUserId];
        [self.notificationHistory clearStoredNotificationsForUserId:userId];
    }
}

- (UIButton*) styleButton:(UIButton*)button
{
    [[button layer] setCornerRadius:8.0f];
    [[button layer] setMasksToBounds:YES];
    [[button layer] setBorderWidth:0.5f];
    
    return button;
}

- (NSString*) currentUserId
{
    NSString* userId = @"";
    
    if(self.authProvider == 0)
    {
        userId = self.identityId;
    }
    if(self.authProvider == 1)
    {
        userId =[self.rumbaUtility userId];
    }
    if(self.authProvider == 2)
    {
        userId =[self.smsUtility userId];
    }
    
    return userId;
}

- (NSString*) currentAuthToken
{
    NSString* tokenStr = @"";
    if(self.authProvider == 0)
    {
        tokenStr = [NSString stringWithFormat:@"Bearer %@", [self.piClient validAccessToken].accessToken];
    }
    if(self.authProvider == 1)
    {
        tokenStr =[self.rumbaUtility authToken];
    }
    if(self.authProvider == 2)
    {
        tokenStr =[self.smsUtility authToken];
    }
    
    return tokenStr;
}

- (void) networkChanged:(NSNotification*)notification
{
    NSString* reachable = (NSString *)[notification object];
    
    if ([reachable isEqualToString:kPN_NetworkReachable])
    {
        [self.pushNotifications saveStoredNotificationPreferencesWithAuthToken:[self currentAuthToken]];
    } else if ([reachable isEqualToString:kPN_NetworkUnreachable]){
        // Do something when device goes offline.
    }
}

- (void) addUserToGroup:(NSString*)groupName
{    
    [self.pushNotifications addUserWithId:self.currentUserId
                             toGroupNamed:groupName
                           usingAuthToken:self.currentAuthToken];
}

- (void) removeUserFromGroup:(NSString*)groupName
{
    [self.pushNotifications removeUserWithId:self.currentUserId
                              fromGroupNamed:groupName
                           usingAuthToken:self.currentAuthToken];
}

@end
