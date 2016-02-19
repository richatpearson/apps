//
//  ValidationResult.h
//  Seer-ios-client
//
//  Created by Tomack, Barry on 1/16/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Contains the results of a validation test from the ActivityStreamValidator, 
 TincanValidator, or SeerByteValidator.
 */
@interface ValidationResult : NSObject

/*!
 Indicates if a validation was successful (YES) or not (NO).
 */
@property (nonatomic, assign) BOOL valid;

/*!
 Very much like the title in a Alert box, this field represents the title of the 
 error returned if the validation proves unsuccessful.
 
      "Activity Stream data invalid"
      "Tincan data invalid"
      "Invalid Data Size"
 */
@property (nonatomic, strong) NSString* title;

/*!
 The detail of why a validation failed.
 */
@property (nonatomic, strong) NSString* detail;

@end
