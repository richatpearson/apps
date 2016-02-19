//
//  SeerDictionaryObject.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/20/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerArrayObject.h"

@class SeerArrayObject;

@interface SeerDictionaryObject : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary* dataDict;

- (void) setStringValue:(NSString*)aString forProperty:(id<NSCopying>)prop;
- (void) setSeerDictionaryObjectData:(SeerDictionaryObject*)anObject forProperty:(id<NSCopying>)prop;
- (void) setSeerArrayObjectData:(SeerArrayObject*)anObject forProperty:(id<NSCopying>)prop;
- (void) setDictionaryValue:(NSDictionary*)dict forProperty:(id<NSCopying>)prop;
- (void) setArrayValue:(NSArray*)array forProperty:(id<NSCopying>)prop;
- (void) setNumberValue:(NSNumber*)aNumber forProperty:(id<NSCopying>)prop;
- (void) setBooleanValue:(BOOL)aBool forProperty:(id<NSCopying>)prop;

- (NSString*) getStringValueForProperty:(id<NSCopying>)prop;
- (NSMutableDictionary*) getSeerDictionaryObjectDataForProperty:(id<NSCopying>)prop;
- (NSMutableArray*) getSeerArrayObjectDataForProperty:(id<NSCopying>)prop;
- (NSDictionary*) getDictionaryValueForProperty:(id<NSCopying>)prop;
- (NSArray*) getArrayValueForProperty:(id<NSCopying>)prop;
- (NSNumber*) getNumberValueForProperty:(id<NSCopying>)prop;
- (BOOL) getBooleanValueForProperty:(id<NSCopying>)prop;

- (void) removeProperty:(id<NSCopying>)prop;

- (NSMutableDictionary*)asDictionary;
- (void) setDictionary:(NSDictionary*)dict;

@end
