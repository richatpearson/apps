//
//  PMGPiAuthDelegate.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 6/2/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PGMPiToken;
@class PGMPiError;
@class PGMPiResponse;
@class PGMPiCredentials;

typedef NS_ENUM(NSInteger, PGMPiRequestType)
{
    PiLoginRequest          = 1,
    PiTokenRefreshRequest   = 2,
    PiValidTokenRequest     = 3,
    PiForgotPasswordRequest = 4,
    PiForgotUsernameRequest = 5
};

/*!
 Pi API Delegate protocol. Classes conform to this protocol to receive responses 
 from their requests to the Pi API.
 */
@protocol PGMPiAPIDelegate <NSObject>

/*!
 Method to retrieve an access token in the required format to communicate with Pi.
 
 @return A string with the Prefix "Bearer " concatenated to the accessToken 
 string returned from Pi.
 */
- (NSString*) currentAccessToken;

/*!
 Method called by PGMPiTokenOperation upon completion.
 
 @param token       The PGMPiToken object containing the data from Pi API
 @param error       Any error generated from attempting to retrive a token
 @param responseId  The id for the response (based on the original request)
 @param requestType The type of request made
 */
- (void) tokenOpCompleteWithToken:(PGMPiToken*)token
                            error:(NSError*)error
                       responseId:(NSNumber*)responseId
                      requestType:(NSNumber*)requestType;

/*!
 Method called by PGMPiTokenOperation when operation is interrupted by consent requirements.
 
 @param escrowTicket Escrow Ticket id
 @param error        The missing consent error
 @param responseId   The id for the response (based on the original request)
 @param requestType  The type of request made
 */
- (void) tokenOpCompleteWithEscrowTicket:(NSString*)escrowTicket
                                   error:(NSError*)error
                              responseId:(NSNumber*)responseId
                             requestType:(NSNumber*)requestType;

/*!
 Method called by PGMPiUserIdOperation upon completion
 
 @param credentials PGMPiCredentials object containing the User Id
 @param error       Any error generated by the User Id retrieval process
 @param responseId  The id for the response (based on the original request)
 @param requestType The type of request made
 */
- (void) userIdOpCompleteWithCredentials:(PGMPiCredentials*)credentials
                                error:(NSError*)error
                         responseId:(NSNumber*)responseId
                        requestType:(NSNumber*)requestType;

/*!
 Method called by PGMPiTokenRefreshOperation
 
 @param token       The PGMPiToken object containing the data from Pi API
 @param error       Any error generated from attempting to refresh a token
 @param responseId  The id for the response (based on the original request)
 @param requestType The type of request made
 */
- (void) tokenRefreshOpCompleteWithToken:(PGMPiToken*)token
                                   error:(NSError*)error
                              responseId:(NSNumber*)responseId
                             requestType:(NSNumber*)requestType;


@end