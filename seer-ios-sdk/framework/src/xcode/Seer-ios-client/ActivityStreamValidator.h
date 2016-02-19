//
//  ActivityStreamValidator.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/16/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidationResult.h"

/*!
 The ActivityStreamValidator validates for Seer required fields<br>
 
 SEER required fields for ActivityStream:<br>
 
 ```
      {
          actor: {
              id: String // required
          },
          verb: String, //required
          generator: {
              appId: String //required
          }
          object: {
              id: String, //required
              objectType: String //required
          }
          context:{      // optional, Seer specific
              String: String,
              String: String
          }
      }
 ```
 
 */
@interface ActivityStreamValidator : NSObject

/*!
 Indicates if the actor property of the Activity Stream is valid (has required properties).
 */
@property (nonatomic, strong) ValidationResult* validActor;
/*!
 Indicates if the verb property of the Activity Stream is valid (has required properties).
 */
@property (nonatomic, strong) ValidationResult* validVerb;
/*!
 Indicates if the generator property of the Activity Stream is valid (has required properties).
 */
@property (nonatomic, strong) ValidationResult* validGenerator;
/*!
 Indicates if the object property of the Activity Stream is valid (has required properties).
 */
@property (nonatomic, strong) ValidationResult* validObject;
/*!
 Indicates if the context property of the Activity Stream is valid (has required properties).
 */
@property (nonatomic, strong) ValidationResult* validContext;

/*!
 Validate an Activity Stream payload based on Seer required fields.
 
 @param asDict The Activity Stream data
 
 @return Results of the validation test.
 */
- (ValidationResult*) validActivityStream:(NSDictionary*) asDict;

@end
