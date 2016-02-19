//
//  SeerClientErrors.h
//  Seer-ios-client
//
//  Created by Tomack, Barry on 3/3/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kSEER_ErrorDomain;

typedef enum
{
    SeerClientError,
    SeerTokenFetch,
    SeerAuthorizationTokenError,
    SeerActivityStreamError,
    SeerInstrumentationError,
    SeerTinCanError,
    SeerQueueError,
    SeerReporterError,
    SeerClientSettingsError,
    SeerQueueFullDBError,
    SeerQueueFullDiskError
} SeerClientErrorCode;

/*!
 <p>Possible error types generated by the Seer-ios-client framework.</p>
 
 <p>Error Domain: com.pearson.mobileplatform.ios.push.pushnotifications.ErrorDomain</p>
 These are the possible enumerated error types:<br>
 `SeerClientError`<br>
 `SeerTokenFetch`<br>
 `SeerAuthorizationTokenError`<br>
 `SeerActivityStreamError`<br>
 `SeerInstrumentationError`<br>
 `SeerTinCanError`<br>
 `SeerQueueError`<br>
 `SeerReporterError`<br>
 `SeerClientSettingsError
 */

@interface SeerClientErrors : NSObject

@end
