//
//  PGMPiResponse.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMPiToken.h"
#import "PGMPiIdentityProfile.h"
#import "PGMPiError.h"
#import "PGMPiAPIDelegate.h"

typedef NS_ENUM(NSInteger, PGMPiRequestStatus)
{
    PiRequestPending = 0,
    PiRequestSuccess = 1,
    PiRequestFailure = 2
};

typedef NS_ENUM(NSInteger, PGMPiOperationType)
{
    PiTokenOp               = 1,
    PiUserIdOp              = 2,
    PiAffiliationOp         = 3,
    PiConsentPolicyOp       = 4,
    PiCredentialsOp         = 5,
    PiEscrowTokenOp         = 6,
    PiFederatedCredentialOp = 7,
    PiAlternateIDOp         = 8,
    PiIdentityEmailOp       = 9,
    PiIdentityProfileOp     = 10,
    PiIdentityProviderOp    = 11,
    PiIdentityOp            = 12,
    PiUserCompositeOp       = 13,
    PiTokenRefreshOp        = 14,
    PiValidToken            = 15,
    PiForgotPassword        = 16,
    PiForgotUsername        = 17
};

/*!
 The response object returned afer every request made to the PGMPiCLient instance.
 */
@interface PGMPiResponse : NSObject

/*!
 The type of request made from the PGMPiClient.
 `PGMPiLoginRequest`<br>
 `PGMPiTokenRefreshRequest`<br>
 `PGMPiValidTokenRequest`<br>
 */
@property (nonatomic, assign) PGMPiRequestType requestType;

/*!
 The current status of the request.
 */
@property (nonatomic, assign) PGMPiRequestStatus requestStatus;

/*!
 The userId currently stored in the PGMPiClient instance
 */
@property (nonatomic, strong) NSString *userId;

/*!
 The current access token stored in the PGMPiClient instance
 */
@property (nonatomic, strong) NSString *accessToken;

/*!
 Any error generated during the fullfillment of the request made.
 */
@property (nonatomic, strong) NSError *error;

/*!
 The time that the response was generated.
 */
@property (nonatomic, strong) NSDate *timestamp;

/*!
 Each instantiated response is assigned a incremented number as an id. 
 This id is specific to the session that the response was instantiated in.
 
 @return The integer is returnd as a number so that it can be used as a key for 
 storage in an NSDictionary
 */
- (NSNumber*) piResponseId;

/*!
 The request type as enumerated in the PGMPiAppDelegate
 
 @return The integer is returned as a number so that it can be used as a key for
 storage in an NSDictionary
 */
- (NSNumber*) piRequestType;

/*!
 Get objects returned from operations which have run as a result of a request.
 Some requests involve more than a single operation. Each object returned from
 each operation is stored in a dictionary keyed on the operation type.
 
 @param opType The operation type enumerated in the PGMPiResponse
 
 @return The object that was retrieved from the operation type specified.
 */
- (id) getObjectForOperationType:(PGMPiOperationType)opType;

/*!
 Set the object returned from an operation as a value in a dicitonary keyed on the 
 operation type as enumerated in the PGMPiResponse. Some request involve more than 
 one operation so there can be more than one object returned for a request.
 
 @param response The object retrieved from the operation
 @param opType   The operation type enumerated in the PGMPiResponse
 */
- (void) setObject:(id)response forOperationType:(PGMPiOperationType)opType;

/*!
 Some requests involve more than one operation so there can be more than one object in the response.
 
 @return Number of objects in resposne
 */
- (NSUInteger)count;


@end
