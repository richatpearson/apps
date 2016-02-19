//
//  TincanValidator.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/16/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidationResult.h"

/*!
 The TincanValidator validates for Seer required fields<br>
 
 SEER required fields for Tin Can :
 
 
 ```
     {
         actor:{
             mbox : String
         },
         verb:{
             id : String
         },
         object:{
             id : String,
             definition:{
                 type : String
             }
         },
         context : {
             extensions : {
                 appId : String
             }
         }
     }
 ```
 
 Actor requires an inverse functional identifier. This could be either one of the following:<br>
 mbox (NSString)<br>
 mbox_sha1sum (NSString)<br>
 openid (NSString)<br>
 account (TincanActorAccount)<br>
 */
@interface TincanValidator : NSObject

/*!
 Indicates if the actor property of the Tin Can is valid (has required properties).
 */
@property (nonatomic, strong) ValidationResult* validActor;
/*!
 Indicates if the verb property of the Tin Can is valid (has required properties).
 */
@property (nonatomic, strong) ValidationResult* validVerb;
/*!
 Indicates if the object property of the Tin Can is valid (has required properties).
 */
@property (nonatomic, strong) ValidationResult* validObject;
/*!
 Indicates if the context property of the Tin Can is valid (has required properties).
 */
@property (nonatomic, strong) ValidationResult* validContext;

/*!
 Validate a Tin Can statement based on Seer required fields.
 
 @param asDict The tin Can data
 
 @return Results of the validation test.
 */
- (ValidationResult*) validTincan:(NSDictionary*) tcDict;

@end
