//
//  PearsonNotificationErrors.h
//  PushNotifications
//
//  Created by Tomack, Barry on 3/19/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kPN_ErrorDomain;

enum
{
    kPN_SDKError = 1,
    kPN_GetGroupError,
    kPN_CreateGroupError,
    kPN_AddUserToGroupError,
    kPN_RemoveUserFromGroupError,
    kPN_APNRegistration,
    kPN_AppServicesRegistrationError,
    kPN_DeviceUnregistrationError,
    kPN_DeviceRegistrationError
};
typedef NSInteger kPN_ClientErrorCode ;

/*!
 <p>Possible error types generated by the PearsonPushNotfications framework.</p>
 
 <p>Error Domain: com.pearson.mobileplatform.ios.push.pushnotifications.ErrorDomain</p>
 These are the possible enumerated error types:<br>
 `kPN_SDKError = 1`<br>
 `kPN_GetGroupError`<br>
 `kPN_CreateGroupError`<br>
 `kPN_AddUserToGroupError`<br>
 `kPN_RemoveUserFromGroupError`<br>
 `kPN_APNRegistration`<br>
 `kPN_AppServicesRegistrationError`<br>
 `kPN_DeviceUnregistrationError`<br>
 `kPN_DeviceRegistrationError`
 */
@interface PearsonNotificationErrors : NSObject

@end
