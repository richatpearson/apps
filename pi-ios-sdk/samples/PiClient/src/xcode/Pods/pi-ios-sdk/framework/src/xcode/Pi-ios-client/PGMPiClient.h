//
//  PGMPiClient.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PGMPiResponse.h"
#import "PGMPiClientDelegate.h"
#import "PGMPiCredentials.h"
#import "PGMPiEnvironment.h"
#import "PGMPiError.h"
#import "PGMPiResponse.h"
#import "PGMPiToken.h"
#import "PGMPiIdentityProfile.h"
#import "PGMPiSecureStorage.h"
#import "PGMPiAPIDelegate.h"
#import "PGMPiClientLoginOptions.h"

#ifndef _SECURITY_SECITEM_H_
#warning Security framework not found. SecureStorage will not be available.
#endif

typedef void (^PiRequestComplete)(PGMPiResponse*);

@class PGMPiEnvironment;

extern NSString* const PGMPiLoginRequest;
extern NSString* const PGMPiTokenRefreshRequest;
extern NSString* const PGMPiValidTokenRequest;
extern NSString* const PGMPiForgotPasswordRequest;
extern NSString* const PGMPiForgotUsernameRequest;

/*!
 PGMPiClient is the top-level class in the Pi-ios-client framework used to
 interface with the Pi Resources. The following are request types (events)
 that can be made through the PGMPiClient: <br>
 `PGMPiLoginRequest`<br>
 `PGMPiTokenRefreshRequest`<br>
 `PGMPiValidTokenRequest`<br>
 */
@interface PGMPiClient : NSObject <PGMPiAPIDelegate>

/*!
 This instance of PGMPiEnvironment provides the paths to the Pi Services based on the environment
 that is set (Staging, Production, or Custom). The default is Staging.
 */
@property (nonatomic, readonly) PGMPiEnvironment *piEnvironment;

/*!
 Determines if username and password credentials should be securely stored in Keychain Services.
 */
@property (nonatomic, assign) BOOL secureStoreCredentials;

/*!
 The id for the user associated with the instance of the pi client.
 */
@property (nonatomic, readonly) NSString *piUserId;

/*!
 Pi Credentials as returned by the UserId Operation
 */
@property (nonatomic, strong) PGMPiCredentials *piCredentials;

/*!
 An Identity Profile object stored from a Pi Resource request.
 */
@property (nonatomic, strong) PGMPiIdentityProfile * piIdentityProfile;

/*!
 Additional data from Pi Resources that are required during the login procedure.
 */
@property (nonatomic, strong) PGMPiClientLoginOptions *clientLoginOptions;

/*!
 A callback delegate to handle the responses from the Pi Requests
 */
@property (nonatomic, weak) id <PGMPiClientDelegate> delegate;

/*!
 Create an instance of the PGMPiCLient using the three parameters that distinguish
 one app from another in Pi Services.
 
 @param clientId     supplied by the Pi Team upon setting up an account
 @param clientSecret supplied by the Pi Team upon setting up an account
 @param redirectUrl  supplied by the Pi Team upon setting up an account
 
 @return an instance of the PGMPiClient
 */
- (id) initWithClientId:(NSString*)clientId
           clientSecret:(NSString*)clientSecret
            redirectUrl:(NSString*)redirectUrl;

/*!
 Set an instance of the PGMPiEnvironemnt (stagingEnvironment or productionEnvironment.
 This is a required step in the configuration of the PiClient.
 
 @param environment A nil value is not accepted
 
 @return Indicates if the process was a success
 */
- (BOOL) setEnvironment:(PGMPiEnvironment*)environment;

/*!
 Set a specific user id that is not retrieved from the Pi Resources.
 
 @param userId A unique identifying string
 */
- (void) setUserId:(NSString*)userId;

/*!
 Specify a keychain access group code for the application.
 
 @param accessGroup name of the access group that will hsare the secure data
 */
- (void) setKeychainAccessGroup:(NSString*)accessGroup;

/*!
 Specify the  kind of Keychain Accessibility required using a Keychain Item 
 Accessibility Constants
 
 @param keychainAccessibility Used for determining when a keychain item should 
 be readable. The default value is kSecAttrAccessibleWhenUnlocked: The data in 
 the keychain item can be accessed only while the device is unlocked by the user.
 */
- (void) setKeychainAccessibility:(id)keychainAccessibility;

#pragma mark Requests

/*!
 Use this method to login to Pi if you are expecting a response via a
 PGMPiClientDelegate or from a notification.
 
 @param username Username as entered by user
 @param password Password as entered by user
 @param options  Login options specify additional data that you wish to have 
 retrieved from the Pi Resources during the login process
 
 @return response object with a status of pending or failure if the connection 
 was not possible or something else went wrong internally.
 */
- (PGMPiResponse*) loginWithUsername:(NSString *)username
                            password:(NSString *)password
                             options:(PGMPiClientLoginOptions *)options;

/*!
 Use this method to login to Pi if you are expecting a response via a
 completion handler block.
 
 @param username   Username as entered by user
 @param password   Password as entered by user
 @param options    Login options specify additional data that you wish to have
 retrieved from the Pi Resources during the login process
 @param onComplete Completion handler for what to do with the reults of the 
 login request
 
 @return response object with a status of pending or failure if the connection
 was not possible or something else went wrong internally.
 */
- (PGMPiResponse*) loginWithUsername:(NSString *)username
                            password:(NSString *)password
                             options:(PGMPiClientLoginOptions *)options
                          onComplete:(PiRequestComplete)onComplete;

/*!
 Make a request to validate the access token currently stored in the PGMPiClient.
 This request doesnt have the benefit of a user id to use as an identifier for 
 retrieving the access token from secure storage so it can only validate an 
 access token stored in memory.<br>
 Use this method when expecting the final response to come via the PGMPiClientDelegate
 method or a local notification.
 
 @return response object with a status of pending or failure if the connection
 was not possible or something else went wrong internally.
 */
- (PGMPiResponse*) validAccessToken;

/*!
 Make a request to validate the access token currently stored in the PGMPiClient.
 This request doesnt have the benefit of a user id to use as an identifier for
 retrieving the access token from secure storage so it can only validate an
 access token stored in memory.<br>
 Use this method when expecting the final response to come via the supplied completion
 handler.
 
 @param onComplete A completion handler block to deliver the resulting response.
 
 @return response object with a status of pending or failure if the connection
 was not possible or something else went wrong internally.
 */
- (PGMPiResponse*) validAccessTokenAndOnComplete:(PiRequestComplete)onComplete;

/*!
 Make a request to validate the access token currently stored in the PGMPiClient.
 This request has the benefit of a user id to use as an identifier for
 retrieving the access token from secure storage.<br>
 Use this method when expecting the final response to come via the PGMPiClientDelegate
 method or a local notification.
 
 @param userId A unique identifier used for storing items securely in 
 Keychain Services.
 
 @return response object with a status of pending or failure if the connection
 was not possible or something else went wrong internally.
 */
- (PGMPiResponse*) validAccessTokenWithUserId:(NSString*)userId;

/*!
 Make a request to validate the access token currently stored in the PGMPiClient.
 This request has the benefit of a user id to use as an identifier for
 retrieving the access token from secure storage.<br>
 Use this method when expecting the final response to come via the supplied 
 completion handler.
 
 @param userId     A unique identifier used for storing items securely in 
 Keychain Services.
 @param onComplete A completion handler block to deliver the resulting response.
 
 @return response object with a status of pending or failure if the connection
 was not possible or something else went wrong internally.
 */
- (PGMPiResponse*) validAccessTokenWithUserId:(NSString*)userId onComplete:(PiRequestComplete)onComplete;

/*!
 Make a request to force the refresh of the access token (whether it is expired
 or not).<br>
 Use this method when expecting the final response to come via the supplied completion
 handler.
 
 @return response object with a status of pending or failure if the connection
 was not possible or something else went wrong internally.
 */
- (PGMPiResponse*) refreshAccessToken;

/*!
 Make a request to force the refresh of the access token (whether it is expired
 or not).<br>
 Use this method when expecting the final response to come via the supplied
 completion handler.
 
 @param onComplete A completion handler block to deliver the resulting response.
 
 @return response object with a status of pending or failure if the connection
 was not possible or something else went wrong internally.
 */
- (PGMPiResponse*) refreshAccessTokenAndOnComplete:(PiRequestComplete)onComplete;

- (PGMPiResponse*) submitConsentPolicies:(NSArray*)policies
                     withCurrentUsername:(NSString*)username
                             andPassword:(NSString*)password;

- (PGMPiResponse*) submitConsentPolicies:(NSArray*)policies
                     withCurrentUsername:(NSString*)username
                             andPassword:(NSString*)password
                              onComplete:(PiRequestComplete)onComplete;

/*!
 This method currently deletes the stored tokens and credentials.
 
 @return Indicates if the tokens were successfully deleted.
 */
- (BOOL) logout;

/*!
 Returns the current access token stored in the PiClient with no validation.
 
 @return the access token from Pi with the word "Bearer" prepended.
 */
- (NSString*) currentAccessToken;


/*!
 Submits a username to the Forgot Password service
 
 @param username Username as entered by user
 
 @return PiResponse to indicate if the request for forgotten password was complete or not.
 */
- (PGMPiResponse*) forgotPasswordForUsername:(NSString*)username;

/*!
 Submits a username to the Forgot Password service
 
 @param username   Username as entered by user
 @param onComplete PiRequestComplete block to be called when request is complete
 
 @return PiResponse to indicate if the request for forgotten password was complete or not.
 */
- (PGMPiResponse*) forgotPasswordForUsername:(NSString*)username
                                  onComplete:(PiRequestComplete)onComplete;


/*!
 Submits email address to retrieve forgotten username
 
 @param email Email address as entered by user
 
 @return A response object with current status upon submission of request
 */
- (PGMPiResponse*) forgotUsernameForEmail:(NSString *)email;

/*!
 Submits email address to retrieve forgotten username and then calls onComplete block.
 
 @param email      Email address submitted by user
 @param onComplete Block called when submission is complete
 
 @return A response object with current status upon submission of request
 */
- (PGMPiResponse*) forgotUsernameForEmail:(NSString *)email
                               onComplete:(PiRequestComplete)onComplete;

#pragma mark Secure Storage
/*!
 Store credentials in keychain services with default security accessibility and no access group.
 By default, the data in the keychain item can be accessed only while the device
 is unlocked by the user (while the application is in the foreground).
 
 @param credentials The PGMPiCredentials object containing username and password
 @param identifier  Used for the account name (kSecAttrAccount), the prefered value for PI is the user ID
 
 @return returns YES if storage is successful, NO if things didn't go well
 */
- (BOOL) storeCredentials:(PGMPiCredentials*)credentials
           withIdentifier:(NSString *)identifier;

/*!
 Store credentials in keychain services with customized security accessibility  and no access group..
 By default, the data in the keychain item can be accessed only while the device
 is unlocked by the user (while the application is in the foreground).
 
 @param credentials           The PGMPiCredentials object containing username and password
 @param identifier            Used for the account name (kSecAttrAccount), the prefered value for PI is the user ID
 @param keychainAccessibility A legal values for kSecAttrAccessible used for determining when a keychain item should be readable.
 
 @return returns YES if storage is successful, NO if things didn't go well
 */
- (BOOL) storeCredentials:(PGMPiCredentials*)credentials
           withIdentifier:(NSString *)identifier
    keychainAccessibility:(id)keychainAccessibility;

/*!
 Store credentials in keychain services with default security accessibility and specified access group.
 By default, the data in the keychain item can be accessed only while the device
 is unlocked by the user (while the application is in the foreground).
 
 @param credentials The PGMPiCredentials object containing username and password
 @param identifier  Used for the account name (kSecAttrAccount), the prefered value for PI is the user ID
 @param accessGroup The keychain access group attribute determines if this item can be shared
 
 @return returns YES if storage is successful, NO if things didn't go well
 */
- (BOOL) storeCredentials:(PGMPiCredentials*)credentials
           withIdentifier:(NSString *)identifier
              accessGroup:(NSString *)accessGroup;

/*!
 Store credentials in keychain services with specified security accessibility and access group.
 By default, the data in the keychain item can be accessed only while the device
 is unlocked by the user (while the application is in the foreground).
 
 @param credentials           The PGMPiCredentials object containing username and password
 @param identifier            Used for the account name (kSecAttrAccount), the prefered value for PI is the user ID
 @param keychainAccessibility A legal values for kSecAttrAccessible used for determining when a keychain item should be readable.
 @param accessGroup           The keychain access group attribute determines if this item can be shared
 
 @return returns YES if storage is successful, NO if things didn't go well
 */
- (BOOL) storeCredentials:(PGMPiCredentials*)credentials
           withIdentifier:(NSString *)identifier
    keychainAccessibility:(id)keychainAccessibility
              accessGroup:(NSString *)accessGroup;

/*!
 Retrieve PGMPiCredentials from keychain services.
 
 @param identifier Used for the account name (kSecAttrAccount), the prefered value for PI is the user ID
 
 @return The PGMPiCredentials object containing username and password
 */
- (PGMPiCredentials *) retrieveCredentialsWithIdentifier:(NSString *)identifier;

/*!
 Delete stored credentials from the keychain services
 
 @param identifier Used for the account name (kSecAttrAccount), the prefered value for PI is the user ID
 
 @return returns YES for a successful deletion and NO if deletion was unsuccessful
 */
- (BOOL) deleteCredentialsWithIdentifier:(NSString *)identifier;

/*!
 Store token object in keychain services with default security accessibility and no access group.
 By default, the data in the keychain item can be accessed only while the device
 is unlocked by the user (while the application is in the foreground).
 
 @param token       The PGMPiToken object containing the token data obtained from the Pi API.
 @param identifier  Used for the account name (kSecAttrAccount), the prefered value for PI is the user ID
 
 @return returns YES if storage is successful, NO if things didn't go well
 */
- (BOOL) storeTokenObj:(PGMPiToken*)tokenObj
        withIdentifier:(NSString *)identifier;
/*!
 Store tokens in keychain services with customized security accessibility and no access group.
 By default, the data in the keychain item can be accessed only while the device
 is unlocked by the user (while the application is in the foreground).
 
 @param token                 The PGMPiToken object containing the token data obtained from the Pi API.
 @param identifier            Used for the account name (kSecAttrAccount), the prefered value for PI is the user ID
 @param keychainAccessibility A legal values for kSecAttrAccessible used for determining when a keychain item should be readable.
 
 @return returns YES if storage is successful, NO if things didn't go well
 */
- (BOOL) storeTokenObj:(PGMPiToken*)tokenObj
        withIdentifier:(NSString *)identifier
 keychainAccessibility:(id)keychainAccessibility;

/*!
 Store tokens in keychain services with default security accessibility and specified access group.
 By default, the data in the keychain item can be accessed only while the device
 is unlocked by the user (while the application is in the foreground).
 
 @param tokenObj    The PGMPiToken object containing the token data obtained from the Pi API.
 @param identifier  Used for the account name (kSecAttrAccount), the prefered value for PI is the user ID
 @param accessGroup The keychain access group attribute determines if this item can be shared
 
 @return returns YES if storage is successful, NO if things didn't go well
 */
- (BOOL) storeTokenObj:(PGMPiToken*)tokenObj
        withIdentifier:(NSString *)identifier
           accessGroup:(NSString *)accessGroup;

/*!
 Store tokens in keychain services with specified security accessibility and access group.
 By default, the data in the keychain item can be accessed only while the device
 is unlocked by the user (while the application is in the foreground).
 
 @param tokenObj              The PGMPiToken object containing the token data obtained from the Pi API.
 @param identifier            Used for the account name (kSecAttrAccount), the prefered value for PI is the user ID
 @param keychainAccessibility A legal values for kSecAttrAccessible used for determining when a keychain item should be readable.
 @param accessGroup           The keychain access group attribute determines if this item can be shared
 
 @return returns YES if storage is successful, NO if things didn't go well
 */
- (BOOL) storeTokenObj:(PGMPiToken*)tokenObj
        withIdentifier:(NSString *)identifier
 keychainAccessibility:(id)keychainAccessibility
           accessGroup:(NSString *)accessGroup;

/*!
 Retrieve a PGMPiToken object from Keychain Services
 
 @param identifier Used for the account name (kSecAttrAccount), the prefered value for PI is the user ID
 
 @return The PGMPiToken object containing the token data obtained from the Pi API.
 */
- (PGMPiToken *) retrieveTokenObjWithIdentifier:(NSString *)identifier;

/*!
 Delete the stored PGMPiToken object from Keychain Services
 
 @param identifier Used for the account name (kSecAttrAccount), the prefered value for PI is the user ID
 
 @return returns YES for a successful deletion and NO if deletion was unsuccessful
 */
- (BOOL) deleteTokenObjWithIdentifier:(NSString *)identifier;

@end
