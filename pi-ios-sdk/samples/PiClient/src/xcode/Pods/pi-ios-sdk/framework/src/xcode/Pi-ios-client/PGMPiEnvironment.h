//
//  PGMPiEnvironment.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/27/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMPiClient.h"

typedef NS_ENUM(NSInteger,PGMPiEnvironmentType) {
    PGMPiNoEnvironment  = -1,
    PGMPiStaging        = 0,
    PGMPiProduction     = 1,
    PGMPiCustom         = 2
};

extern NSString* const PGMPiDefaultBase_Staging;
extern NSString* const PGMPiDefaultBase_Prod;

extern NSString *const PGMPiEscrowDefaultBase_Staging;
extern NSString *const PGMPiEscrowDefaultBase_Prod;

extern NSString* const PGMPiLoginPath;
extern NSString* const PGMPiLoginPathProd;

extern NSString* const PGMPiUserIdPath;
extern NSString* const PGMPiRefreshPath;
extern NSString* const PGMPiUserCompositePath;
extern NSString* const PGMPiIdentityProfilePath;

extern NSString* const PGMPiEscrowEndpoint;
extern NSString* const PGMPiPostConsentEndpoint;

extern NSString const *PGMPiLoginSuccessUrlKey;
extern NSString const *PGMPiResponseTypeKey;
extern NSString const *PGMPiScopeKey;
extern NSString const *PGMPiClientIdKey;
extern NSString const *PGMPiClientSecretKey;
extern NSString const *PGMPiRedirectUrlKey;

extern NSString const *PGMPiForgotPasswordPath;
extern NSString const *PGMPiForgotUsernamePath;

/*!
 The Pi Environment provides the full URLs to the PI API services based on the
 which environemnt type is set.
 */
@interface PGMPiEnvironment : NSObject

/*!
 The currently set environment to communicate with the Pi API
 */
@property (nonatomic, assign) PGMPiEnvironmentType currentEnvironmentType;


#pragma mark Public methods

/*!
 Provides an instance of PGMPiEnvironment with default staging properties.
 
 It is not allowable to instantiate PGMPiEnvironment using either of these two methods:<br>
 `[PGMPiEnvironemnt alloc]init]` or `[PGMPiEnvironment new]`
 
 @return an instance of the PGMPiEnvironemnt with default staging properties
 */
+ (instancetype) stagingEnvironment;

/*!
 Provides an instance of PGMPiEnvironment with default production properties.
 
 It is not allowable to instantiate PGMPiEnvironment using either of these two methods:<br>
 `[PGMPiEnvironemnt alloc]init]` or `[PGMPiEnvironment new]`
 
 @return an instance of the PGMPiEnvironemnt with default production properties
 */
+ (instancetype) productionEnvironment;


- (NSString*) basePiURL;
- (NSString*) baseEscrowURL;
- (NSString*) loginLocalPath;
- (NSString*) state;
- (NSString*) scope;
- (NSString*) loginSuccessUrl;
- (NSString*) responseType;

/*!
 Setter for basePiURL property validates that the url begins with "https" scheme.<br>
 Setting any of the properties to a new value changes the currentEnvironmentType
 value to PGMPiCustom.
 
 @param basePiURL a url string beginning with "https"
 
 @return Indicates the success of setting the basePiURL
 */
- (BOOL) setBasePiURL:(NSString*)basePiURL;

/*!
 Setter for baseEscrowURL property validates that the url begins with "https" scheme.<br>
 Setting any of the properties to a new value changes the currentEnvironmentType
 value to PGMPiCustom.
 
 @param baseEscrowURL a url string beginning with "https"
 
 @return Indicates the success of setting the baseEscrowURL
 */
- (BOOL) setBaseEscrowURL:(NSString*)baseEscrowURL;

/*!
 Setter for state property. The default value is "state" for both environemnts.
 This is an optional parameter specified by the Pi team but is currently not needed.<br>
 Setting any of the properties to a new value changes the currentEnvironmentType
 value to PGMPiCustom.
 
 @param state A nil value is not accepted.
 
 @return Indicates the success of setting the state
 */
- (BOOL) setState:(NSString*)state;

/*!
 Setter for scope property. The default value is "s2" for both environemnts.
 This is an optional parameter specified by the Pi team but is currently not needed.<br>
 Setting any of the properties to a new value changes the currentEnvironmentType
 value to PGMPiCustom.
 
 @param scope A nil value is not accepted.
 
 @return Indicates the success of setting the scope
 */
- (BOOL) setScope:(NSString*)scope;

/*!
 Setter for loginSuccessUrl. This parameter is required for the redirect process 
 when login occurs. It is not a good idea to change this without coordination 
 with the Pi team.<br>
 Setting any of the properties to a new value changes the currentEnvironmentType
 value to PGMPiCustom.
 
 @param loginSuccessUrl A nil value is not accepted.
 
 @return Indicates the success of setting loginSuccessUrl
 */
- (BOOL) setLoginSuccessUrl:(NSString*)loginSuccessUrl;

/*!
 Setter for responseType. The default value is "code" for both environemnts. It 
 is not a good idea to change this without coordination with the Pi team.<br>
 Setting any of the properties to a new value changes the currentEnvironmentType
 value to PGMPiCustom.
 
 @param responseType A nil value is not accepted.
 
 @return Indicates the success of setting responseType
 */
- (BOOL) setResponseType:(NSString*)responseType;

/*!
 Retrieve the full path to the Pi login service
 
 @return A concatenated string of the base url combined with the login path
 */
- (NSString*) piLoginPath;

/*!
 Retrieves the full path to the Pi Credentials service that returns the User Id
 
 @param username Required by this service to obtain the service's path
 
 @return A concatenated string of the base url combined with the credentials path 
 and the username parameter
 */
- (NSString*) piUserIdPathWithUsername:(NSString*)username;

/*!
 Retrieves the full path to the Pi Token Refresh service
 
 @return A concatenated string of the base url combined with the refresh path
 */
- (NSString*) piRefreshPath;

/*!
 <#Description#>
 
 @return <#return value description#>
 */
- (NSString*) piForgotPasswordUrl;

/*!
 <#Description#>
 
 @return <#return value description#>
 */
- (NSString*) piForgotUsernameUrl;

/*!
 Retrieves the path to the Pi Token Refresh service
 
 @return A concatenated string of the escrow base url combined with the escrow path
 which contains a wildcard for the escrow ticket
 */
- (NSString*) escrowPathFormat;

/*!
 Retrieves the full path to the Pi Token Refresh service
 
 @param ticket The Escrow ticket id
 
 @return A concatenated string of the escrow base url combined with the escrow path
 and the escrow ticket
 */
- (NSString*) escrowPathWithTicket:(NSString*)ticket;


- (NSString*) postConsentPathWithTicket:(NSString*)ticket;

@end
