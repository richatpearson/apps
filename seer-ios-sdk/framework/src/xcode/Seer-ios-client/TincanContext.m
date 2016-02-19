//
//  TincanContext.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanContext.h"

@interface TincanContext()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanContext

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

- (void) setRevision:(NSString*)revision
{
    [self setStringValue:revision forProperty:@"revision"];
}

- (void) setPlatform:(NSString*)platform
{
    [self setStringValue:platform forProperty:@"platform"];
}

- (void) setLanguage:(NSString*)language
{
    [self setStringValue:language forProperty:@"language"];
}

- (void) setExtensions:(TincanContextExtensions*)extensions
{
    [self setSeerDictionaryObjectData:extensions forProperty:@"extensions"];
}

- (void) setInstructor:(TincanActor*)instructor
{
    [self setSeerDictionaryObjectData:instructor forProperty:@"instructor"];
}

- (void) setContextActivities:(TincanContextActivities*)contextActivities
{
    [self setSeerDictionaryObjectData:contextActivities forProperty:@"contextActivities"];
}

- (NSString*) revision
{
    return [self getStringValueForProperty:@"revision"];
}

- (NSString*) platform
{
    return [self getStringValueForProperty:@"platform"];
}

- (NSString*) language
{
    return [self getStringValueForProperty:@"language"];
}

- (TincanContextExtensions*) extensions
{
    TincanContextExtensions* tccExtensions = [TincanContextExtensions new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:@"extensions"];
    if(dict)
    {
        [tccExtensions setDictionary:dict];
    }
    return tccExtensions;
}

- (TincanActor*) instructor
{
    TincanActor* tccInstructor = [TincanActor new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:@"instructor"];
    if(dict)
    {
        [tccInstructor setDictionary:dict];
    }
    return tccInstructor;
}

- (TincanContextActivities*) contextActivities
{
    TincanContextActivities* tcContextActivities = [TincanContextActivities new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:@"contextActivities"];
    if(dict)
    {
        [tcContextActivities setDictionary:dict];
    }
    return tcContextActivities;
}

- (TincanContextExtensions*) setExtensionsWithAppId:(NSString*)appId
{
    TincanContextExtensions* tccExtensions = [TincanContextExtensions new];
    [tccExtensions setAppId:appId];
    
    [self setExtensions:tccExtensions];
    
    return tccExtensions;
}

@end
