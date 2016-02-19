//
//  TincanObjectDefinition.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanObjectDefinition.h"

@interface TincanObjectDefinition()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanObjectDefinition

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

- (void) setType:(NSString*)type
{
    [self setStringValue:type forProperty:@"type"];
}

- (void) setNameWithDictionary:(NSDictionary*)nameDict
{
    TincanLanguageMap* nameMap = [TincanLanguageMap new];
    [nameMap setDictionary:nameDict];
    
    [self setName: nameMap];
}

- (void) setDescriptionWithDictionary:(NSDictionary*)descDict
{
    TincanLanguageMap* descMap = [TincanLanguageMap new];
    [descMap setDictionary:descDict];
    
    [self setDefDescription: descMap];
}

- (void) setName:(TincanLanguageMap*)name
{
    [self setSeerDictionaryObjectData:name forProperty:@"name"];
}

- (void) setDefDescription:(TincanLanguageMap*)desc
{
    [self setSeerDictionaryObjectData:desc forProperty:@"description"];
}

- (NSString*) type
{
    return [self getStringValueForProperty:@"type"];
}

- (TincanLanguageMap*) name
{
    TincanLanguageMap* tcoDefName = [TincanLanguageMap new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:@"name"];
    if (dict)
    {
        [tcoDefName setDictionary: dict];
    }
    return tcoDefName;
}

- (TincanLanguageMap*) defDescription
{
    TincanLanguageMap* tcoDefDesc = [TincanLanguageMap new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:@"description"];
    if (dict)
    {
        [tcoDefDesc setDictionary: dict];
    }
    return tcoDefDesc;
}

@end
