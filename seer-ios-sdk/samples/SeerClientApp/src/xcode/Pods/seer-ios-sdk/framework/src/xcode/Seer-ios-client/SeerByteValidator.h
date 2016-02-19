//
//  SeerByteValidator.h
//  Seer-ios-client
//
//  Created by Tomack, Barry on 3/21/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidationResult.h"

/*!
 Validate the size of the Activity Stream payloads and Tin Can statements to 
 make sure they fit into the default byte range.
 */
@interface SeerByteValidator : NSObject

extern NSInteger const kSEER_DefaultBundleSize;
extern NSInteger const kSEER_MaxBundleSize;
extern NSInteger const kSEER_MaxBundleSizeLowerBound;

/*!
 The default size of Actvity Stream payload or Tin Can statement bundles to be 
 sent to Seer. A bundle refers to a "collection" of payloads and/or statements.
 and can be comprised of 1 or many.
 
 @return The default size in bytes.
 */
- (NSInteger) defaultBundleSize;

/*!
 The maximum allowed size of a Actvity Stream payload or Tin Can statement.
 
 @return The max size in bytes
 */
- (NSInteger) maxBundleSize;

/*!
 The lower bound for a customized bundle setting. Bundle size has to be atleast 
 this size to be valid.
 
 @return The lower bound for the bundle size.
 */
- (NSInteger) maxBundelSizeLowerBound;

/*!
 The current bundle size limit
 
 @return the current bundle size limit in bytes
 */
- (NSInteger) bundleSizeLimit;

/*!
 Setter for customizing the maximum bundle size of the packets to be sent to Seer.
 This method tests that the incoming bundle size is within the prescribed bounds.
 
 @param bundleSize The customized bundle size
 
 @return Confirmation that the size to be set falls within the upper and lower bounds.
 */
- (ValidationResult*) limitBundleSize:(NSInteger)bundleSize;

/*!
 Validate that the size of the Activity Stream payload/Tin Can statement bundle
 is less than or equal to the current bundle size limit.
 
 @param dataDict A dictionary containing one or many payloads and/or statements.
 
 @return The success or failure of the validation process.
 */
- (ValidationResult*) validDataSize:(NSDictionary*)dataDict;

/*!
 Validate that the size of the Activity Stream payload/Tin Can statement bundle
 is less than or equal to the current bundle size limit.
 
 @param dataString A string containing one or many payloads and/or statements.
 
 @return The success or failure of the validation process.
 */
- (ValidationResult*) validDataStringSize:(NSString*)dataString;


@end
