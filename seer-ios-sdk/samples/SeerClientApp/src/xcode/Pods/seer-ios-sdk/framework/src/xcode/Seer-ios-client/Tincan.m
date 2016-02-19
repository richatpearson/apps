//
//  Tincan.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "Tincan.h"
#import "SeerUtility.h"

@interface Tincan()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation Tincan

@synthesize dataDict = _dataDict;

NSString* const kTC_id = @"id";
NSString* const kTC_actor = @"actor";
NSString* const kTC_verb = @"verb";
NSString* const kTC_object = @"object";
NSString* const kTC_result = @"result";
NSString* const kTC_context = @"context";
NSString* const kTC_authority = @"authority";
NSString* const kTC_timestamp = @"timestamp";
NSString* const kTC_stored = @"stored";

#pragma mark init section
- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.dataDict = [NSMutableDictionary new];
    }
    
    return self;
}

- (id) initWithUniqueId
{
    self = [self init];
    
    if(self)
    {
        [self setId:[SeerUtility uniqueId]];
    }
    
    return self;
}

- (id) initWithStatement:(NSDictionary*)tincanStatement
{
    self = [self init];
    
    if(self)
    {
        NSMutableDictionary* newStatement = [NSMutableDictionary dictionaryWithDictionary:tincanStatement];
        self.dataDict = newStatement;
    }
    
    return self;
}

#pragma mark basic setters section

- (void) setId:(NSString*)tincanId
{
    [self setStringValue:tincanId forProperty:kTC_id];
}

- (void) setActor:(TincanActor*)actor
{
    [self setSeerDictionaryObjectData:actor forProperty:kTC_actor];
}

- (void) setVerb:(TincanVerb*)verb
{
    [self setSeerDictionaryObjectData:verb forProperty:kTC_verb];
}

- (void) setObject: (TincanObject*)object
{
    [self setSeerDictionaryObjectData:object forProperty:kTC_object];
}

- (void) setResult: (TincanResult*) result
{
    [self setSeerDictionaryObjectData:result forProperty:kTC_result];
}

- (void) setContext: (TincanContext*)context
{
    [self setSeerDictionaryObjectData:context forProperty:kTC_context];
}

- (void) setAuthority:(TincanActor *)authority
{
    [self setSeerDictionaryObjectData:authority forProperty:kTC_authority];
}

- (void) setTimestamp:(NSString*)timestamp
{
    [self setStringValue:timestamp forProperty:kTC_timestamp];
}

- (void) setStored:(NSString*)stored
{
    [self setStringValue:stored forProperty:kTC_stored];
}

#pragma mark helper setters

- (TincanActor*) setActorWithMbox:(NSString*)mbox
{
    TincanActor* actor = [TincanActor new];
    [actor setMbox:mbox];
    
    [self setSeerDictionaryObjectData:actor forProperty:kTC_actor];
    
    return actor;
}

- (TincanVerb*) setVerbWithId:(NSString*)verbId
{
    TincanVerb* verb = [TincanVerb new];
    [verb setId:verbId];
    
    [self setSeerDictionaryObjectData:verb forProperty:kTC_verb];
    
    return verb;
}

- (TincanObject*) setObjectWithId:(NSString*)objectId
{
    TincanObject* object = [TincanObject new];
    [object setId:objectId];
    
    [self setSeerDictionaryObjectData:object forProperty:kTC_object];
    
    return object;
}

- (TincanObject*) setObjectWithId:(NSString*)objectId
                       definition:(TincanObjectDefinition*)objDef
{
    TincanObject* object = [TincanObject new];
    [object setId:objectId];
    [object setObjectDefinition:objDef];
    
    [object setSeerDictionaryObjectData:object forProperty:kTC_object];
    
    return object;
}

- (TincanContext*) setContextWithExtensions:(TincanContextExtensions*)extensions
{
    TincanContext* context = [TincanContext new];
    [context setSeerDictionaryObjectData:extensions forProperty:@"extensions"];
    
    [self setSeerDictionaryObjectData:context forProperty:kTC_context];
    
    return context;
}

#pragma mark basic getters section

- (NSString*) tincanId
{
    return [self getStringValueForProperty:kTC_id];
}

- (TincanActor*) actor
{
    TincanActor* tcActor = [TincanActor new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:kTC_actor];
    if(dict)
    {
        [tcActor setDictionary:dict];
    }
    return tcActor;
}

- (TincanVerb*) verb
{
    TincanVerb* tcVerb = (TincanVerb*)[self getSeerDictionaryObjectDataForProperty:kTC_verb];
    if(!tcVerb)
    {
        tcVerb = [TincanVerb new];
    }
    return tcVerb;
}

- (TincanObject*) object
{
    TincanObject* tcObject = [TincanObject new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:kTC_object];
    if(dict)
    {
        [tcObject setDictionary:dict];
    }
    return tcObject;
}

- (TincanResult*) result
{
    TincanResult* tcResult = [TincanResult new];
     NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:kTC_result];
    if(dict)
    {
        [tcResult setDictionary:dict];
    }
    return tcResult;
}

- (TincanContext*) context
{
    TincanContext* tcContext = [TincanContext new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:kTC_context];
    if(dict)
    {
        [tcContext setDictionary:dict];
    }
    return tcContext;
}

- (TincanActor*) authority
{
    TincanActor* tcAuthority = [TincanActor new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:kTC_authority];
    if(dict)
    {
        [tcAuthority setDictionary:dict];
    }
    return tcAuthority;
}

- (NSString*) timestamp
{
    return [self getStringValueForProperty:kTC_timestamp];
}

- (NSString*) stored
{
    return [self getStringValueForProperty:kTC_stored];
}

@end
