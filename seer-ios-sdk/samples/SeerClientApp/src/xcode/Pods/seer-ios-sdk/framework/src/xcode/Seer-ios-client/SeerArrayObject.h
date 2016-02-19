//
//  SeerArrayObject.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/24/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerDictionaryObject.h"

@class SeerDictionaryObject;

/*!
 Base Seer model object upon which other objects that require array structures are based.
 
 @see TincanAttachments
 */
@interface SeerArrayObject : NSObject

/*!
 The dataArray of a SeerArrayObject can only contain NSDictionary objects.
 */
@property (nonatomic, strong, readonly) NSMutableArray* dataArray;

/*!
 Called to add a SeerDictionaryObject to the data array
 
 @param anObject Dictionary object to be added to a SeerArrayObject
 */
- (void) addSeerDictionaryObjectData:(SeerDictionaryObject*)anObject;

/*!
 Called to remove a SeerDictionaryObject from the data array
 
 @param anObject the SeerDictionaryObject to remove.
 */
- (void) removeSeerDictionaryObjectData:(SeerDictionaryObject*)anObject;

/*!
 Get the SeerArrayObject as an array
 
 @return <#return value description#>
 */
- (NSMutableArray*) asArray;

/*!
 Set the data array for the SeerArrayObject. If the incoming array contains 
 anything but NSDictionaries, it will be rejected.
 
 @param array An array of NSDictionary objects
 */
- (void) setArray:(NSArray*)array;

@end
