//
//  PearsonPushNotifications.m
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 9/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "PearsonPushNotifications.h"
#import "PearsonNotification.h"
#import "PearsonDeviceRegistrationOperation.h"
#import "PearsonDeviceUnregistrationOperation.h"
#import "PearsonUserRegistrationOperation.h"
#import "PearsonDeviceUserConnectionOperation.h"
#import "PearsonDeviceUserDisconnectionOperation.h"
#import "PearsonNotificationErrors.h"
#import "PearsonNotificationsValidator.h"

#import <PearsonAppServicesiOSSDK/PearsonClient.h>
#import <PearsonAppServicesiOSSDK/PearsonDataClient.h>
#import <PearsonAppServicesiOSSDK/PearsonClientResponse.h>
#import <PearsonAppServicesiOSSDK/PearsonDevice.h>
#import <PearsonAppServicesiOSSDK/PearsonReachability.h>
#import <PearsonAppServicesiOSSDK/PearsonMonitoringOptions.h>

@interface PearsonPushNotifications ()

/* TODO: Current iOS 5 deployment target does not support weak references */

/**
 The organization name supplied by the MobilePlatform team
 */
@property (strong, nonatomic) NSString* orgName;

/**
 The application name supplied by MobilePlatform team
 */
@property (strong, nonatomic) NSString* appName;

/**
 The unique API key
 Assigned and supplied by the MobilePlatform team
 */
@property (strong, nonatomic) NSString* apiKey;

/**

 */
@property (strong, nonatomic) NSString* baseURL;

/**

 */
@property (strong, nonatomic) NSString* notifierName;

/**
 The user ID
 Passed in from App
 */
@property (strong, nonatomic) NSString* userID;

@property (assign, nonatomic) BOOL logging;
@property (assign, nonatomic) BOOL applicationIsRegistered;
@property (assign, nonatomic) BOOL deviceIsRegistered;
@property (assign, nonatomic) BOOL userIsRegistered;
@property (assign, nonatomic) BOOL userDeviceConnected;
@property (assign, nonatomic) BOOL deviceEntityUpdated;

@property (assign, nonatomic) BOOL alertNetworkChanges;
@property (assign, nonatomic) BOOL autoUpdatePreferences;
@property (assign, nonatomic) BOOL createMissingGroups;

@property (strong, nonatomic) PearsonDevice* device;
@property (strong, nonatomic) PearsonUser* currentUser;

@property (strong, nonatomic) NSData* deviceToken;

@property (strong, nonatomic) PearsonClient* pearsonClient;

@property (strong, nonatomic) NSString* currentOp;
@property (strong, nonatomic) id currentOpObject;

@property (strong, nonatomic) NSOperationQueue* pushNotificationsQueue;

@property (strong, nonatomic) PearsonNotificationPreferences* pushPreferences;

@property (strong) PearsonReachability *reachability;

@property (assign, nonatomic) NSUInteger authenticationType;

@end

@implementation PearsonPushNotifications

NSString* const kPN_AppRegistrationRequest          = @"appRegistrationRequest";
NSString* const kPN_AppUnregistrationRequest        = @"appUnregistrationRequest";
NSString* const kPN_DeviceRegistrationRequest       = @"deviceRegistrationRequest";
NSString* const kPN_DeviceUnregistrationRequest     = @"deviceUnregistrationRequest";
NSString* const kPN_UserRegistrationRequest         = @"userRegistrationRequest";
NSString* const kPN_UserUnregistrationRequest       = @"userUnregistrationRequest";
NSString* const kPN_UserDeviceConnectionRequest     = @"userDeviceConnectionRequest";
NSString* const kPN_UserDeviceDisconnectionRequest  = @"userDeviceDisconnectionRequest";
NSString* const kPN_UserDeviceReconnectionRequest   = @"userDeviceReconnectionRequest";
NSString* const kPN_AddUserToGroupRequest           = @"addUserToGroupRequest";
NSString* const kPN_RemoveUserFromGroupRequest      = @"removeUserFromGroupRequest";
NSString* const kPN_GetGroupRequest                 = @"getGroupRequest";
NSString* const kPN_CreateGroupRequest              = @"createGroupRequest";
NSString* const kPN_RegisteredWithAppServices       = @"registeredWithAppServices";
NSString* const kPN_UnregisteredWithAppServices     = @"unregisteredWithAppServices";
NSString* const kPN_ReregisteredWithAppServices     = @"reregisteredWithAppServices";
NSString* const kPN_DeviceEntityUpdateRequest       = @"deviceEntityUpdateRequest";
NSString* const kPN_SaveNotificationPreferences     = @"saveNotificationPreferences";
NSString* const kPN_NetworkConnectionChange         = @"networkConnectionChange";
NSString* const kPN_NetworkReachable                = @"networkReachable";
NSString* const kPN_NetworkUnreachable              = @"networkUnreachable";
NSString* const kPN_PushNotificationReady           = @"pushNotificationsReady";
NSString* const kPN_IncomingNotification            = @"incomingNotification";

NSString* const kPN_NotifierName                    = @"apple";

NSString* const kPN_PearsonDefaultNotificationBaseURL = @"https://mobileservices.openclasslabs.com/appservices/";


-(id)init
{
    // You are not allowed to init without a UIApplication, a launch options dictionary
    // You can't init with [PearsonPushNotifications new]. You must call
    // self.pushNotifications = [[PearsonPushNotifications alloc] initWithOrganization:{YourOrganizationName}
    //                                                                     application:{YourApplicationName"
    //                                                                          apiKey:{YourAPIKey}
    //
    // It is best to do this from your app delegate's start up method...
    // - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    //
    assert(0);
    return nil;
}

- (id)initWithOrganization:(NSString*)orgName
               application:(NSString*)appName
                    apiKey:(NSString*)apiKey
{
    PearsonMonitoringOptions* monitoringOptions = [[PearsonMonitoringOptions alloc]init];
    monitoringOptions.monitoringEnabled = NO;
    
    return [self initWithOrganization:orgName
                          application:appName
                               apiKey:apiKey
                    monitoringOptions:monitoringOptions
                              baseURL:kPN_PearsonDefaultNotificationBaseURL];
}

- (id)initWithOrganization:(NSString*)orgName
               application:(NSString*)appName
                    apiKey:(NSString*)apiKey
                   baseURL:(NSString*)baseURL
{
    PearsonMonitoringOptions* monitoringOptions = [[PearsonMonitoringOptions alloc]init];
    monitoringOptions.monitoringEnabled = NO;
    
    return [self initWithOrganization:orgName
                          application:appName
                               apiKey:apiKey
                    monitoringOptions:monitoringOptions
                              baseURL:baseURL];
}

- (id) initWithOrganization:(NSString*)orgName
                application:(NSString*)appName
                     apiKey:(NSString*)apiKey
                 monitoring:(BOOL)monitoring
{
    PearsonMonitoringOptions* monitoringOptions = [[PearsonMonitoringOptions alloc]init];
    
    if(monitoring)
    {
        // monitoring options as nil => default monitoring options
        monitoringOptions = nil;
    }
    else
    {
        monitoringOptions.monitoringEnabled = NO;
    }
    
    return [self initWithOrganization:orgName
                          application:appName
                               apiKey:apiKey
                    monitoringOptions:monitoringOptions
                              baseURL:kPN_PearsonDefaultNotificationBaseURL];
}

- (id) initWithOrganization:(NSString*)orgName
                application:(NSString*)appName
                     apiKey:(NSString*)apiKey
          monitoringOptions:(PearsonMonitoringOptions*)monitoringOptions
                    baseURL:(NSString*)baseURL
{
    self = [super init];
    if ( self )
    {
        self.orgName    = orgName;
        self.appName    = appName;
        self.apiKey     = apiKey;
        
        self.baseURL    = baseURL;
        
        self.createMissingGroups = YES;
        
        [self initializeOperationQueueProperties];
        [self initializePearsonClient:monitoringOptions];
        [self restoreNotificationPreferences];
    }
    return self;
}

- (void) initializeOperationQueueProperties
{
    // Initialize operation queue
    self.pushNotificationsQueue = [[NSOperationQueue alloc] init];
    
    [self.pushNotificationsQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    
    self.currentOp = @"";
}

- (void) initializePearsonClient:(PearsonMonitoringOptions*)monitoringOptions
{
    // Connect and login to App Services
    NSString* queryString = [NSString stringWithFormat:@"api_key=%@", self.apiKey];
    
    self.pearsonClient = [[PearsonClient alloc] initWithOrganizationId:self.orgName
                                                         applicationId:self.appName
                                                               baseURL:self.baseURL
                                                              urlTerms:queryString
                                                               options:monitoringOptions];
}

- (void) showLogging:(BOOL)logging
{
    if(logging)
    {
        self.logging = logging;
    }
    else
    {
        self.logging = NO;
    }
    if(self.logging)
    {
        [self.pearsonClient.dataClient setLogging:true];
    }
}

- (void) authenticationProvider:(PearsonAuthenticationType)pearsonAuthenticationType
{
    self.authenticationType = pearsonAuthenticationType;
}

- (void) setNotifier:(NSString *)notifierName
{
    self.notifierName = notifierName;
}

- (void) notifyWhenNetworkChangesOccur:(BOOL)alertMe
{
    self.alertNetworkChanges = alertMe;
    if(alertMe)
    {
        if( ! self.reachability)
        {
            [self enableReachability:YES];
        }
    }
}

- (BOOL) okToCreateGroups
{
    return self.createMissingGroups;
}

- (void) onlyAddUserToExistingGroups:(BOOL)createGroups
{
    self.createMissingGroups = !createGroups;
}

- (void) autoUpdateUnsavedPreferences:(BOOL)autoUpdate
{
    self.autoUpdatePreferences = autoUpdate;
    if (autoUpdate)
    {
        if( ! self.reachability)
        {
            [self enableReachability:YES];
        }
    }
}

- (void) enableReachability:(BOOL)enable
{
    if (enable)
    {
        if( ! self.reachability)
        {
            self.reachability = [PearsonReachability reachabilityForInternetConnection];
            [self.reachability startNotifier];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(networkConnectionDidChange:)
                                                         name:kReachabilityChangedNotification
                                                       object:nil];
        }
    }
    else
    {
        if( self.reachability )
        {
            [self.reachability stopNotifier];
            self.reachability = nil;
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:kReachabilityChangedNotification
                                                          object:nil];
        }
    }
}

- (NSString*) notifier
{
    if(!self.notifierName)
    {
        return kPN_NotifierName;
    }
    return self.notifierName;
}

- (void) application:(UIApplication*)application didRegisterWithNewDeviceToken:(NSData*)newDeviceToken
{
    self.applicationIsRegistered = YES;
    
    // Register device with AppServices
    self.deviceToken = newDeviceToken;
    
    [self dispatchNotificationForEvent:kPN_AppRegistrationRequest object:newDeviceToken];
    [self pushLog:@"PearsonPushNotifications successfully registered application with Apple Push Services"];
}

- (void) application:(UIApplication*)application didFailToRegisterWithError:(NSError*)error
{
    self.applicationIsRegistered = NO;
    [self dispatchNotificationForEvent:kPN_AppRegistrationRequest object:error];
    [self pushLog:@"PearsonPushNotifications failed to register application with Apple Push Services"];
}

- (PearsonNotification*) application:(UIApplication*)application didReceivePushNotification:(NSDictionary *)userInfo
{
    [self pushLog:@"PearsonPushNotifications did receive push notification"];
    // Create a new notification object
    PearsonNotification* notification = [[PearsonNotification alloc] initWithDictionary:userInfo forUserID:self.userID];

    // Notify all listeners that there is a new notification object
    if([self applicationIsRegisteredForNotifications] && [self deviceIsRegisteredWithAppServices] && [self userIsRegisteredWithAppServices])
    {
        [self pushLog:[NSString stringWithFormat:@"PearsonPushNotifications dispatching notification for event: %@", kPN_IncomingNotification]];
        [self dispatchNotificationForEvent:kPN_IncomingNotification object:notification];
    }
    
    return notification;
}

#pragma mark CALLBACKS

/**************************** DEVICE ****************************/

- (void) deviceDidRegisterWithAppServices:(PearsonClientResponse*)response
{
    self.deviceIsRegistered = YES;
    
    self.device = (PearsonDevice*)[response firstEntity];
    
    [self addNotificationPreferencesToDevice];
    
    [self dispatchNotificationForEvent:kPN_DeviceRegistrationRequest object:response];
    [self pushLog:[NSString stringWithFormat:@"PearsonPushNotifications successfully registered device with App Services: %@", self.device.uuid]];
}

- (void) deviceDidFailToRegisterWithWithAppServices:(PearsonClientResponse*)response
{
    [self.pushNotificationsQueue cancelAllOperations];
    self.deviceIsRegistered = NO;
    
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:response.errorDescription forKey:NSLocalizedDescriptionKey];
    NSError* error  = [NSError errorWithDomain:kPN_ErrorDomain code:kPN_DeviceRegistrationError userInfo:errorDetail];
    
    [self dispatchNotificationForEvent:kPN_DeviceRegistrationRequest object:error];
    [self pushLog:@"PearsonPushNotifications application failed to register device with App Services"];
}

- (void) deviceDidUnregisterWithAppServices:(PearsonClientResponse*)response
{
    self.deviceIsRegistered = NO;
    
    self.device = (PearsonDevice*)[response firstEntity];
    
    [self dispatchNotificationForEvent:kPN_DeviceUnregistrationRequest object:response];
    [self pushLog:@"PearsonPushNotifications successfully unregistered device with App Services"];
}

- (void) deviceDidFailToUnregisterWithWithAppServices:(PearsonClientResponse*)response
{
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:response.errorDescription forKey:NSLocalizedDescriptionKey];
    NSError* error  = [NSError errorWithDomain:kPN_ErrorDomain code:kPN_DeviceUnregistrationError userInfo:errorDetail];
    
    [self dispatchNotificationForEvent:kPN_DeviceRegistrationRequest object:error];
    [self pushLog:@"PearsonPushNotifications application failed to unregister device with App Services"];
}

/**************************** USER ****************************/

- (void) userDidRegisterWithAppServices:(PearsonClientResponse*)response
{
    self.userIsRegistered = YES;
    
    self.currentUser = (PearsonUser*)[response firstEntity];
    
    [self dispatchNotificationForEvent:kPN_UserRegistrationRequest object:response];
    [self pushLog:[NSString stringWithFormat:@"PearsonPushNotifications successfully registered user with App Services: %@", self.currentUser.uuid]];
}

- (void) userDidFailToRegisterWithAppServices:(PearsonClientResponse*)response
{
    [self.pushNotificationsQueue cancelAllOperations];
    self.userIsRegistered = NO;
    
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    
    if(errorDetail)
    {
        [errorDetail setValue:response.errorDescription forKey:NSLocalizedDescriptionKey];
    }
    else
    {
        [errorDetail setValue:@"Error registering user with AppServices" forKey:NSLocalizedDescriptionKey];
    }
    NSError* error  = [NSError errorWithDomain:kPN_ErrorDomain code:kPN_AppServicesRegistrationError userInfo:errorDetail];
    [self dispatchNotificationForEvent:kPN_DeviceRegistrationRequest object:error];
    [self pushLog:@"PearsonPushNotifications failed to register user with App Services"];
}

/**
 Not currently unregistering user
 */
- (void) userDidUnregisterForRemoteNotificationsWithAuthToken:(PearsonClientResponse*)response
{
    
}

/**************************** USER-DEVICE ****************************/

- (void) userDeviceConnectionSuccess:(PearsonClientResponse*)response
{
    self.userDeviceConnected = YES;
    [self pushLog:@"PearsonPushNotifications succesfully connected user with device"];
    
    [self dispatchNotificationForEvent:kPN_UserDeviceConnectionRequest object:response];
}

- (void) userDeviceConnectionFailure:(PearsonClientResponse*)response
{
    self.userDeviceConnected = NO;
    [self pushLog:@"PearsonPushNotifications failed to connect user with device"];
    [self dispatchNotificationForEvent:kPN_UserDeviceConnectionRequest object:response];
}

- (void) userDeviceDisconnectionSuccess:(PearsonClientResponse*)response
{
    self.userDeviceConnected = NO;
    [self pushLog:@"PearsonPushNotifications succesfully disconnected user with device"];
    
    [self dispatchNotificationForEvent:kPN_UserDeviceDisconnectionRequest object:response];
}

- (void) userDeviceDisconnectionFailure:(PearsonClientResponse*)response
{
    self.userDeviceConnected = YES;
    [self pushLog:@"PearsonPushNotifications failed to disconnect user with device"];
    [self dispatchNotificationForEvent:kPN_UserDeviceDisconnectionRequest object:response];
}

/********************** DEVICE ENTITY UPDATES **********************/
- (void) deviceEntityUpdateSuccess:(PearsonClientResponse*)response
{
    self.deviceEntityUpdated = YES;
    [self pushLog:@"PearsonPushNotifications succesfully updated device entity"];
    [self dispatchNotificationForEvent:kPN_DeviceEntityUpdateRequest object:response];
}
- (void) deviceEntityUpdateFailure:(PearsonClientResponse*)response
{
    self.deviceEntityUpdated = NO;
    [self pushLog:@"PearsonPushNotifications failed to update device entity"];
    [self dispatchNotificationForEvent:kPN_DeviceEntityUpdateRequest object:response];
}

/************************* GROUPS *************************/
- (void) userGroupConnectionSuccess:(PearsonClientResponse*)response
{
    [self pushLog:@"PearsonPushNotifications succesfully added User to Group"];
    [self dispatchNotificationForEvent:kPN_AddUserToGroupRequest object:response];
}

- (void) userGroupConnectionFailure:(PearsonClientResponse*)response
{
    [self pushLog:@"PearsonPushNotifications failed to add User to Group"];
    [self dispatchNotificationForEvent:kPN_AddUserToGroupRequest object:response];
}

- (void) userGroupDisconnectionSuccess:(PearsonClientResponse*)response
{
    [self pushLog:@"PearsonPushNotifications succesfully removed User from Group"];
    [self dispatchNotificationForEvent:kPN_RemoveUserFromGroupRequest object:response];
}

- (void) userGroupDisconnectionFailure:(PearsonClientResponse*)response
{
    [self pushLog:@"PearsonPushNotifications failed to remove User from Group"];
    [self dispatchNotificationForEvent:kPN_RemoveUserFromGroupRequest object:response];
}

- (void) getGroupSuccess:(PearsonClientResponse *)response
{
    [self pushLog:@"PearsonPushNotifications succesfully found Group"];
    [self dispatchNotificationForEvent:kPN_GetGroupRequest object:response];
}

- (void) getGroupFailure:(PearsonClientResponse *)response
{
    [self pushLog:@"PearsonPushNotifications failed to find Group"];
    [self dispatchNotificationForEvent:kPN_GetGroupRequest object:response];
}

- (void) createGroupSuccess:(PearsonClientResponse *)response
{
    [self pushLog:@"PearsonPushNotifications succesfully created Group"];
    [self dispatchNotificationForEvent:kPN_CreateGroupRequest object:response];
}

- (void) createGroupFailure:(PearsonClientResponse *)response
{
    [self pushLog:@"PearsonPushNotifications failed to create Group"];
    [self dispatchNotificationForEvent:self.currentOp object:response];
}

/******************** UTILITY METHODS ********************/

- (void) registerApplicationWithAPN:(NSUInteger)notificationType
{
    NSUInteger uintType = notificationType;
    [self pushLog:[NSString stringWithFormat:@"PushNotifications registering application with APN types: %lu", (unsigned long)uintType]];
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        NSLog(@"iOS 8 - will register user for notification settings...");
        
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:nil];
        [application registerUserNotificationSettings:notificationSettings];
        [application registerForRemoteNotifications];
    } else {
        NSLog(@"iOS 7 or less - will register for remote notification the old way...");
        [application registerForRemoteNotificationTypes:notificationType];
    }
}

- (void) unregisterApplicationWithAPN
{
    [self pushLog:@"PushNotifications unregistering application with APN"];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    self.applicationIsRegistered = NO;
    
    [self dispatchNotificationForEvent:kPN_AppUnregistrationRequest object:nil];
}

- (void) registerWithAppServicesUsingAuthorizationToken:(NSString*)authToken
                                                 userId:(NSString*)userId
{
    if (self.applicationIsRegistered)
    {
        [self pushLog:@"PushNotifications registering with App Services"];
        self.currentOp = kPN_RegisteredWithAppServices;
        
        self.userID = userId;
        
        NSOperation* registerDeviceOp       = [self operationToRegisterDeviceWithAuthToken:authToken];
        NSOperation* registerUserOp         = [self operationToRegisterUser:userId withAuthToken:authToken];
        NSOperation* connectUserToDeviceOp  = [self operationToConnectUser:userId ToDeviceWithAuthToken:authToken];
        NSOperation* updateDeviceEntity     = [self operationToUpdateDeviceEntityWithAuthToken: authToken];
        
        [connectUserToDeviceOp addDependency:registerDeviceOp];
        [connectUserToDeviceOp addDependency:registerUserOp];
        
        [updateDeviceEntity addDependency:connectUserToDeviceOp];
        
        [self.pushNotificationsQueue addOperation: registerDeviceOp];
        [self.pushNotificationsQueue addOperation: registerUserOp];
        [self.pushNotificationsQueue addOperation: connectUserToDeviceOp];
        [self.pushNotificationsQueue addOperation: updateDeviceEntity];
    }
    else
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"Cannot register with AppServices because app is not registered with APNs.", @"Cannot register with AppServices because app is not registered with APNs")
                       forKey:NSLocalizedDescriptionKey];
        NSError* error  = [NSError errorWithDomain:kPN_ErrorDomain code:kPN_AppServicesRegistrationError userInfo:errorDetail];
        [self dispatchNotificationForEvent:kPN_RegisteredWithAppServices object:error];
    }
}

- (void) unregisterWithAppServicesUsingAuthorizationToken:(NSString*)authToken
                                                   userId:(NSString*)userId
{
    [self pushLog:@"PushNotifications unregistering with App Services authToken :%@"];
    
    self.currentOp = kPN_UnregisteredWithAppServices;
    
    NSOperation* disconnectUserToDeviceOp = [self operationToDisconnectUser:userId ToDeviceWithAuthToken:authToken];
    NSOperation* unregisterDeviceOp = [self operationToUnregisterDeviceWithAuthToken:authToken];
    
    [unregisterDeviceOp addDependency:disconnectUserToDeviceOp];
    
    [self.pushNotificationsQueue addOperation: disconnectUserToDeviceOp];
    [self.pushNotificationsQueue addOperation: unregisterDeviceOp];
}

- (void) reregisterWithAppServicesUsingAuthorizationToken:(NSString*)authToken
                                                   userId:(NSString*)userId
{
    [self pushLog:@"PushNotifications reregistering with App Services"];
    self.currentOp = kPN_ReregisteredWithAppServices;
    
    NSOperation* registerDeviceOp       = [self operationToRegisterDeviceWithAuthToken:authToken];
    NSOperation* connectUserToDeviceOp  = [self operationToConnectUser:userId ToDeviceWithAuthToken:authToken];
    NSOperation* updateDeviceEntity     = [self operationToUpdateDeviceEntityWithAuthToken: authToken];
    
    [connectUserToDeviceOp addDependency:registerDeviceOp];
    [updateDeviceEntity addDependency:connectUserToDeviceOp];
    
    [self.pushNotificationsQueue addOperation: registerDeviceOp];
    [self.pushNotificationsQueue addOperation: connectUserToDeviceOp];
    [self.pushNotificationsQueue addOperation: updateDeviceEntity];
}

- (void) saveNotificationPreferences:(PearsonNotificationPreferences*)preferences
                       withAuthToken:(NSString*)authToken
{
    [self pushLog:@"PushNotifications saving Notification Preferences"];
    self.currentOp = kPN_SaveNotificationPreferences;
    self.deviceEntityUpdated = NO;
    if(preferences)
    {
        [self setNotificationPreferences:preferences];
    }
    [self addNotificationPreferencesToDevice];
    
    NSOperation* updateDeviceEntity = [self operationToUpdateDeviceEntityWithAuthToken: authToken];
    
    [self.pushNotificationsQueue addOperation: updateDeviceEntity];
}

- (void) saveStoredNotificationPreferencesWithAuthToken:(NSString*)authToken
{
    [self saveNotificationPreferences:nil
                        withAuthToken:(NSString*)authToken];
}

- (void) addUserWithId:(NSString*)userId
          toGroupNamed:(NSString*)groupName
        usingAuthToken:(NSString*)authToken
{
    PearsonNotificationsValidator* validator = [PearsonNotificationsValidator new];
    
    if ([validator validGroupName:groupName])
    {
        [self pushLog:[NSString stringWithFormat:@"PushNotifications adding User %@ to group %@", userId, groupName]];
        self.currentOp = kPN_AddUserToGroupRequest;
        
        NSOperation* getGroupOp = [self operationToGetGroup:groupName withAuthToken:authToken];
        NSOperation* addUserToGroupOp = [self operationToAddUser:userId toGroup:groupName withAuthToken:authToken];
        
        if(self.createMissingGroups)
        {
            NSOperation* createGroupOp = [self operationToCreateGroup:groupName withAuthToken:authToken];
            
            [createGroupOp addDependency:getGroupOp];
            [addUserToGroupOp addDependency:createGroupOp];
            
            [self.pushNotificationsQueue addOperation: getGroupOp];
            [self.pushNotificationsQueue addOperation: createGroupOp];
            [self.pushNotificationsQueue addOperation: addUserToGroupOp];
        }
        else
        {
            [addUserToGroupOp addDependency:getGroupOp];
            
            [self.pushNotificationsQueue addOperation: getGroupOp];
            [self.pushNotificationsQueue addOperation: addUserToGroupOp];
        }
    }
    else
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"Invalid group name.", @"Invalid group name")
                       forKey:NSLocalizedDescriptionKey];
        NSError* error  = [NSError errorWithDomain:kPN_ErrorDomain code:kPN_AddUserToGroupError userInfo:errorDetail];
        [self dispatchNotificationForEvent:kPN_AddUserToGroupRequest object:error];
    }
}

- (void) removeUserWithId:(NSString*)userId
           fromGroupNamed:(NSString*)groupName
           usingAuthToken:(NSString*)authToken;
{
    PearsonNotificationsValidator* validator = [PearsonNotificationsValidator new];
    if ([validator validGroupName:groupName])
    {
        [self pushLog:[NSString stringWithFormat:@"PushNotifications removing User %@ from group %@", userId, groupName]];
        self.currentOp = kPN_RemoveUserFromGroupRequest;
        
        NSOperation* getGroupOp = [self operationToGetGroup:groupName withAuthToken:authToken];
        NSOperation* removeUserFromGroupOp = [self operationToRemoveUser:userId fromGroup:groupName withAuthToken:authToken];
        
        [removeUserFromGroupOp addDependency:getGroupOp];
            
        [self.pushNotificationsQueue addOperation: getGroupOp];
        [self.pushNotificationsQueue addOperation: removeUserFromGroupOp];
    }
    else
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"Invalid group name.", @"Invalid group name")
                       forKey:NSLocalizedDescriptionKey];
        NSError* error  = [NSError errorWithDomain:kPN_ErrorDomain code:kPN_RemoveUserFromGroupError userInfo:errorDetail];
        [self dispatchNotificationForEvent:kPN_RemoveUserFromGroupRequest object:error];
    }
}

/******************** OPERATION GET METHODS ********************/

- (PearsonDeviceRegistrationOperation*) operationToRegisterDeviceWithAuthToken:(NSString*)authToken
{
    [self pushLog:[NSString stringWithFormat:@"PearsonPushNotifications registering device with app services"]];

    PearsonDeviceRegistrationOperation* registerDeviceOperation = [[PearsonDeviceRegistrationOperation alloc] initWithDeviceToken:self.deviceToken
                                                                                                                         notifier:[self notifier]
                                                                                                                    authProvider:[self authProvider]
                                                                                                                        authToken:authToken
                                                                                                                           client:self.pearsonClient.dataClient];
    
    registerDeviceOperation.delegate = self;
    
    return registerDeviceOperation;
}

- (PearsonDeviceUnregistrationOperation*) operationToUnregisterDeviceWithAuthToken:(NSString*)authToken
{
    [self pushLog:[NSString stringWithFormat:@"PearsonPushNotifications unregistering device with app services"]];
    
    PearsonDeviceUnregistrationOperation* unregisterDeviceOperation = [[PearsonDeviceUnregistrationOperation alloc] initWithDeviceToken:self.deviceToken
                                                                                                                               notifier:[self notifier]
                                                                                                                           authProvider:[self authProvider]
                                                                                                                              authToken:authToken
                                                                                                                                 client:self.pearsonClient.dataClient];
    unregisterDeviceOperation.delegate = self;
    
    return unregisterDeviceOperation;
}

- (PearsonUserRegistrationOperation*) operationToRegisterUser:(NSString*)userId
                                                withAuthToken:(NSString*)authToken
{
    [self pushLog:[NSString stringWithFormat:@"PearsonPushNotifications registering user %@ with app services", userId]];
    
    PearsonUserRegistrationOperation* userRegistrationOp = [[PearsonUserRegistrationOperation alloc] initWithUserId:userId
                                                                                                       authProvider:[self authProvider]
                                                                                                          authToken:authToken
                                                                                                             client:self.pearsonClient.dataClient];
    userRegistrationOp.delegate = self;
    
    return userRegistrationOp;
}

- (PearsonDeviceUserConnectionOperation*) operationToConnectUser:(NSString*)userId
                                           ToDeviceWithAuthToken:(NSString*)authToken
{
    [self pushLog: [NSString stringWithFormat:@"PearsonPushNotifications connecting User with Device"]];

    PearsonDeviceUserConnectionOperation* connectDeviceUserOp = [[PearsonDeviceUserConnectionOperation alloc ]initWithUserId:userId
                                                                                                                authProvider:[self authProvider]
                                                                                                                   authToken:authToken
                                                                                                                      client:self.pearsonClient.dataClient];
    connectDeviceUserOp.delegate = self;
    
    return connectDeviceUserOp;
}

- (PearsonDeviceUserDisconnectionOperation*) operationToDisconnectUser:(NSString*)userId
                                                 ToDeviceWithAuthToken:(NSString*)authToken
{
    [self pushLog: [NSString stringWithFormat:@"PearsonPushNotifications disconnecting User %@ with Device", userId]];

    PearsonDeviceUserDisconnectionOperation* disconnectDeviceUserOp = [[PearsonDeviceUserDisconnectionOperation alloc ]initWithUserId:userId
                                                                                                                         authProvider:[self authProvider]
                                                                                                                            authToken:authToken
                                                                                                                               client:self.pearsonClient.dataClient];
    disconnectDeviceUserOp.delegate = self;
    
    return disconnectDeviceUserOp;
}

- (PearsonUpdateDeviceEntityOperation*) operationToUpdateDeviceEntityWithAuthToken:(NSString*) authToken
{
    [self pushLog: [NSString stringWithFormat:@"PearsonPushNotifications updating device entity"]];
    
    PearsonUpdateDeviceEntityOperation* updateDeviceEntityOp = [[PearsonUpdateDeviceEntityOperation alloc ]initWithAuthToken:authToken
                                                                                                                authProvider:[self authProvider]
                                                                                                                  dataClient:self.pearsonClient.dataClient];
    updateDeviceEntityOp.delegate = self;
    
    return updateDeviceEntityOp;
}

- (PearsonGetGroupOperation*) operationToGetGroup:(NSString*)groupName withAuthToken:(NSString*) authToken
{
    PearsonGetGroupOperation* getGroupOp = [[PearsonGetGroupOperation alloc] initWithGroup:groupName
                                                                              authProvider:[self authProvider]
                                                                                 authToken:authToken
                                                                                    client:self.pearsonClient.dataClient];
    getGroupOp.delegate = self;
    
    return getGroupOp;
}

- (PearsonCreateGroupOperation*) operationToCreateGroup:(NSString*)groupName withAuthToken:(NSString*) authToken
{
    PearsonCreateGroupOperation* createGroupOp = [[PearsonCreateGroupOperation alloc] initWithGroup:groupName
                                                                                       authProvider:[self authProvider]
                                                                                          authToken:authToken
                                                                                             client:self.pearsonClient.dataClient];
    createGroupOp.delegate = self;
    
    return createGroupOp;
}

- (PearsonAddUserToGroupOperation*) operationToAddUser:(NSString*)userId toGroup:(NSString*)groupName withAuthToken:(NSString*) authToken
{
    PearsonAddUserToGroupOperation* addUserToGroupOp = [[PearsonAddUserToGroupOperation alloc] initWithUserId:(NSString*)userId
                                                                                                    groupName:groupName
                                                                                                 authProvider:[self authProvider]
                                                                                                    authToken:authToken
                                                                                                       client:self.pearsonClient.dataClient];
    addUserToGroupOp.delegate = self;
    
    return addUserToGroupOp;
}

- (PearsonRemoveUserFromGroupOperation*) operationToRemoveUser:(NSString*)userId fromGroup:(NSString*)groupName withAuthToken:(NSString*) authToken
{
    PearsonRemoveUserFromGroupOperation* removeUserFromGroupOp = [[PearsonRemoveUserFromGroupOperation alloc] initWithUserId:(NSString*)userId
                                                                                                                   groupName:groupName
                                                                                                                authProvider:[self authProvider]
                                                                                                                   authToken:authToken
                                                                                                                      client:self.pearsonClient.dataClient];
    removeUserFromGroupOp.delegate = self;
    
    return removeUserFromGroupOp;
}

- (BOOL) applicationIsRegisteredForNotifications
{
    return self.applicationIsRegistered;
}

- (BOOL) deviceIsRegisteredWithAppServices
{
    return self.deviceIsRegistered;
}

- (BOOL) userIsRegisteredWithAppServices
{
    return self.userIsRegistered;
}

- (BOOL) userIsConnectedToDevice
{
    return self.userDeviceConnected;
}

- (BOOL) notificationPreferencesHaveBeenUpdated
{
    return self.deviceEntityUpdated;
}

- (void) pushLog:(NSString*)message
{
    if(self.logging)
    {
        NSLog(@"%@", message);
    }
}

- (void) dispatchNotificationForEvent:(NSString*)event object:(NSObject*)obj
{
    [self pushLog:[NSString stringWithFormat:@"PearsonNotifications dispatchEvent: %@", event]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:event object:obj];
    });
}

- (NSString*)deviceTokenString
{
    return [[[self.deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (PearsonDevice*)deviceEntity
{
    return self.device;
}

- (NSString*) currentUserUUID
{
    if (self.currentUser)
    {
        return self.currentUser.uuid;
    }
    return @"";
}

- (NSString*) currentDeviceUUID
{
    if (self.device)
    {
        return self.device.uuid;
    }
    return @"";
}

/******************** PREFERENCES METHODS ********************/

- (void) addNotificationPreferencesToDevice
{
    if (self.pushPreferences)
    {
        [self.device addProperties:@{@"mobileplatform": [self.pushPreferences getPreferences]}];
    }
}

- (PearsonNotificationPreferences*) notificationPreferences
{
    return self.pushPreferences;
}

- (void) setNotificationPreferences:(PearsonNotificationPreferences*)preferences
{
    self.pushPreferences = preferences;
    [self archiveNotificationPreferences];
}

/******************** ARCHIVING METHODS ********************/

- (void) archiveNotificationPreferences
{
    if (! self.pushPreferences)
    {
        self.pushPreferences = [PearsonNotificationPreferences new];
    }
    [NSKeyedArchiver archiveRootObject:self.pushPreferences toFile:[self notificationPreferencesFile]];
}

- (void) restoreNotificationPreferences
{
    PearsonNotificationPreferences* prefs = [NSKeyedUnarchiver unarchiveObjectWithFile: [self notificationPreferencesFile]];
    
    if (prefs)
    {
        self.pushPreferences = prefs;
    }
    else
    {
        self.pushPreferences = [PearsonNotificationPreferences new];
    }
}

// Return the path to the Notifications Prefrences data in the Documents directory as String
- (NSString *) notificationPreferencesFile
{
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"NotificationPrefrences.data"];
}


/******************** KEY VALUE METHODS ********************/

// KVO to determine when queue is empty
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if (object == self.pushNotificationsQueue && [keyPath isEqualToString:@"operations"])
    {
        if (self.pushNotificationsQueue.operationCount == 0)
        {
            if(![self.currentOp isEqualToString:@""])
            {
                NSString* eventToDispatch = self.currentOp;
                id objectToDispatch = self.currentOpObject;
                self.currentOp = @"";
                self.currentOpObject = nil;
                [self dispatchNotificationForEvent:eventToDispatch object:objectToDispatch];
            }
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

/********************** AuthProvider ***********************/

- (NSString*) authProvider
{
    if(self.authenticationType == 0)
    {
        return @"pi";
    }
    if(self.authenticationType == 1)
    {
        return @"mi";
    }
    
    return @"pi";
}

/******************* REACHABILITY CHANGE *******************/

-(void) networkConnectionDidChange:(NSNotification *) notification
{
    PearsonReachability* reachability = (PearsonReachability *)[notification object];
    NSString* networkReachability = @"";
    
    if ([reachability currentReachabilityStatus])
    {
        networkReachability = kPN_NetworkReachable;
    }
    else
    {
        networkReachability = kPN_NetworkUnreachable;
    }
    if (self.alertNetworkChanges)
    {
        [self dispatchNotificationForEvent:kPN_NetworkConnectionChange object:networkReachability];
    }
}

- (PearsonClient*) getPearsonClient
{
    return self.pearsonClient;
}

@end
