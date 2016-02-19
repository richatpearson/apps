//
//  TincanObject.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanObject.h"

@interface TincanObject()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanObject

@synthesize dataDict = _dataDict;

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.dataDict = [NSMutableDictionary new];
    }
    
    return self;
}

- (void) setId:(NSString*)objectId
{
    [self setStringValue:objectId forProperty:@"id"];
}

- (void) setObjectType:(NSString*)objectType
{
    [self setStringValue:objectType forProperty:@"objectType"];
}

- (void) setObjectDefinition:(TincanObjectDefinition*)definition
{
    [self setSeerDictionaryObjectData:definition forProperty:@"definition"];
}

- (NSString*) objectId
{
    return [self getStringValueForProperty:@"id"];
}

- (NSString*) objectType
{
    return [self getStringValueForProperty:@"objectType"];
}

- (TincanObjectDefinition*) objectDefinition
{
    TincanObjectDefinition* toDefinition = [TincanObjectDefinition new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:@"definition"];
    if (dict)
    {
        [toDefinition setDictionary: dict];
    }
    return toDefinition;
}

- (TincanObjectDefinition*) setDefinitionWithType:(NSString*)defType
{
    TincanObjectDefinition* toDefinition = [TincanObjectDefinition new];
    [toDefinition setType:defType];
    
    [self setSeerDictionaryObjectData:toDefinition forProperty:@"definition"];
    
    return toDefinition;
}

@end
