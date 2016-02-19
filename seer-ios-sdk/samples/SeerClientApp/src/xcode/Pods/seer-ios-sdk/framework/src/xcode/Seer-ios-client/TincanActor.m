//
//  TincanActor.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanActor.h"

@interface TincanActor()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanActor

@synthesize dataDict = _dataDict;

NSString* const kTC_objectType = @"objectType";
NSString* const kTC_mbox = @"mbox";
NSString* const kTC_name = @"name";
NSString* const kTC_account = @"account";

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.dataDict = [NSMutableDictionary new];
    }
    
    return self;
}

- (void) setObjectType:(NSString*) objType
{
    [self setStringValue:objType forProperty:kTC_objectType];
}

- (void) setMbox:(NSString*) mbox
{
    [self setStringValue:mbox forProperty:kTC_mbox];
}

- (void) setName:(NSString*) name
{
    [self setStringValue:name forProperty:kTC_name];
}

- (void) setAccount:(TincanActorAccount*)account
{
    [self setSeerDictionaryObjectData:account forProperty:kTC_account];
}

- (void) setAccountWithDictionary:(NSDictionary*)dict
{
    TincanActorAccount* acct = [TincanActorAccount new];
    [acct setDictionary:dict];
    
    [self setAccount:acct];
}

- (NSString*) objectType
{
    return [self getStringValueForProperty:kTC_objectType];
}

- (NSString*) mbox
{
    return [self getStringValueForProperty:kTC_mbox];
}

- (NSString*) name
{
    return [self getStringValueForProperty:kTC_name];
}

- (TincanActorAccount*) account
{
    TincanActorAccount* tcAccount = [TincanActorAccount new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:kTC_account];
    if (dict)
    {
        [tcAccount setDictionary: dict];
    }
    return tcAccount;
}

@end
