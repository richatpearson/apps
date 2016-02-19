//
//  SeerDictionaryObject.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/20/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "SeerDictionaryObject.h"

@interface SeerDictionaryObject()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation SeerDictionaryObject

#pragma mark get and set properties section

- (void) setStringValue:(NSString*)aString forProperty:(id<NSCopying>)prop
{
    [[self asDictionary] setObject:aString forKey:prop];
}

- (void) setSeerDictionaryObjectData:(SeerDictionaryObject*)anObject forProperty:(id<NSCopying>)prop
{
    [[self asDictionary] setObject:[anObject asDictionary] forKey:prop];
}

- (void) setSeerArrayObjectData:(SeerArrayObject*)anObject forProperty:(id<NSCopying>)prop
{
    [[self asDictionary] setObject:[anObject asArray] forKey:prop];
}

- (void) setDictionaryValue:(NSDictionary*)dict forProperty:(id<NSCopying>)prop
{
    [[self asDictionary] setObject:dict forKey:prop];
}

- (void) setArrayValue:(NSArray*)array forProperty:(id<NSCopying>)prop
{
    [[self asDictionary] setObject:array forKey:prop];
}

- (void) setNumberValue:(NSNumber*)aNumber forProperty:(id<NSCopying>)prop
{
    [[self asDictionary] setObject:aNumber forKey:prop];
}

- (void) setBooleanValue:(BOOL)aBool forProperty:(id<NSCopying>)prop
{
    if (aBool)
    {
        [self setNumberValue:@1 forProperty:prop];
    }
    else
    {
        [self setNumberValue:@0 forProperty:prop];
    }
}

- (NSString*) getStringValueForProperty:(id<NSCopying>)prop
{
    id asString = [[self asDictionary] objectForKey:prop];
    
    if([asString isKindOfClass:[NSString class]])
    {
        return asString;
    }
    return nil;
}

- (NSMutableDictionary*) getSeerDictionaryObjectDataForProperty:(id<NSCopying>)prop
{
    id smObjData = [[self asDictionary] objectForKey:prop];
    
    if([smObjData isKindOfClass:[NSMutableDictionary class]])
    {
        return smObjData;
    }
    
    return nil;
}

- (NSMutableArray*) getSeerArrayObjectDataForProperty:(id<NSCopying>)prop
{
    id smObjData = [[self asDictionary] objectForKey:prop];
    
    if([smObjData isKindOfClass:[NSMutableArray class]])
    {
        return smObjData;
    }
    
    return nil;
}

- (NSDictionary*) getDictionaryValueForProperty:(id<NSCopying>)prop
{
    id asObj = [[self asDictionary] objectForKey:prop];
    if( [asObj isKindOfClass:[NSDictionary class]])
    {
        return asObj;
    }
    return nil;
}

- (NSArray*) getArrayValueForProperty:(id<NSCopying>)prop
{
    id asObj = [[self asDictionary] objectForKey:prop];
    if( [asObj isKindOfClass:[NSArray class]])
    {
        return asObj;
    }
    return nil;
}

- (NSNumber*) getNumberValueForProperty:(id<NSCopying>)prop
{
    id asObj = [[self asDictionary] objectForKey:prop];
    if( [asObj isKindOfClass:[NSNumber class]])
    {
        return asObj;
    }
    return nil;
}

- (BOOL) getBooleanValueForProperty:(id<NSCopying>)prop
{
    return [[self getNumberValueForProperty:prop] boolValue];
}

- (void) removeProperty:(id<NSCopying>)aKey
{
    [[self asDictionary] removeObjectForKey:aKey];
}

- (NSMutableDictionary*)asDictionary
{
    if( self.dataDict)
    {
        return self.dataDict;
    }
    return [NSMutableDictionary new];
}

- (void) setDictionary:(NSDictionary*)dict
{
    if(!self.dataDict)
    {
        self.dataDict = [NSMutableDictionary new];
    }
    [self.dataDict setDictionary:dict];
}

@end
