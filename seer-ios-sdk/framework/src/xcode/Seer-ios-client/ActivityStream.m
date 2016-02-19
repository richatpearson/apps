//
//  ActivityStream.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/18/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "ActivityStream.h"

@interface ActivityStream()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation ActivityStream

@synthesize dataDict = _dataDict;

NSString* const kAS_actor       = @"actor";
NSString* const kAS_generator   = @"generator";
NSString* const kAS_object      = @"object";
NSString* const kAS_target      = @"target";
NSString* const kAS_verb        = @"verb";
NSString* const kAS_published   = @"published";
NSString* const kAS_context     = @"context";

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.dataDict = [NSMutableDictionary new];
    }
    
    return self;
}

- (id) initWithPayload:(NSDictionary*)payload
{
    self = [super init];
    
    if(self)
    {
        NSMutableDictionary* newPayload = [NSMutableDictionary dictionaryWithDictionary:payload];
        self.dataDict = newPayload;
    }
    
    return self;
}

- (void) setVerb:(NSString*)verb
{
    [self setStringValue:verb forProperty:kAS_verb];
}

- (void) setPublished:(NSString*)published
{
    [self setStringValue:published forProperty:kAS_published];
}

- (ActivityStreamActor*) setActorWithId:(NSString*)actorId
{
    ActivityStreamActor* actor = [ActivityStreamActor new];
    [actor setId:actorId];
    
    [self setActor:actor];
    
    return actor;
}

- (ActivityStreamGenerator*) setGeneratorWithAppId:(NSString*)appId
{
    ActivityStreamGenerator* generator = [ActivityStreamGenerator new];
    [generator setAppId:appId];
    
    [self setGenerator:generator];
    
    return generator;
}

- (ActivityStreamObject*) setObjectWithId:(NSString*)objectId objectType:(NSString*)objectType
{
    ActivityStreamObject* object = [ActivityStreamObject new];
    [object setId:objectId];
    [object setObjectType:objectType];
    
    [self setObject:object];
    
    return object;
}

- (ActivityStreamTarget*) setTargetWithId:(NSString*)targetId
{
    ActivityStreamTarget* target = [ActivityStreamTarget new];
    [target setId:targetId];
    
    [self setTarget:target];
    
    return target;
}

- (void) setActor:(ActivityStreamActor*)actor
{
    [self setSeerDictionaryObjectData:actor forProperty:kAS_actor];
}

- (void) setGenerator:(ActivityStreamGenerator*)generator
{
    [self setSeerDictionaryObjectData:generator forProperty:kAS_generator];
}

- (void) setObject:(ActivityStreamObject*)object
{
    [self setSeerDictionaryObjectData:object forProperty:kAS_object];
}

- (void) setTarget:(ActivityStreamTarget*)target
{
    [self setSeerDictionaryObjectData:target forProperty:kAS_target];
}

- (void) setContext:(NSDictionary *)context
{
    [self setDictionaryValue:context forProperty:kAS_context];
}

- (ActivityStreamActor*) actor
{
    NSMutableDictionary* dict = [self.dataDict objectForKey:kAS_actor];
    ActivityStreamActor* asActor = [ActivityStreamActor new];
    if(dict)
    {
        [asActor setDictionary:dict];
    }
    return asActor;
}

- (ActivityStreamGenerator*) generator
{
    NSMutableDictionary* dict = [self.dataDict objectForKey:kAS_generator];
    ActivityStreamGenerator* asGenerator = [ActivityStreamGenerator new];
    if(dict)
    {
        [asGenerator setDictionary:dict];
    }
    return asGenerator;
}

- (ActivityStreamObject*) object
{
    NSMutableDictionary* dict = [self.dataDict objectForKey:kAS_object];
    ActivityStreamObject* asObject = [ActivityStreamObject new];
    if(dict)
    {
        [asObject setDictionary:dict];
    }
    return asObject;
}

- (ActivityStreamTarget*) target
{
    NSMutableDictionary* dict = [self.dataDict objectForKey:kAS_target];
    ActivityStreamTarget* asTarget = [ActivityStreamTarget new];
    if(dict)
    {
        [asTarget setDictionary:dict];
    }
    return asTarget;
}

- (NSDictionary*) context
{
    return [self.dataDict objectForKey:kAS_context];
}

- (NSString*) verb
{
    return [self.dataDict objectForKey:kAS_verb];
}

- (NSString*) published
{
    return [self.dataDict objectForKey:kAS_published];
}

@end
