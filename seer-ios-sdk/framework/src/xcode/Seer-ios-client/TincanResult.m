//
//  TincanResult.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanResult.h"

@interface TincanResult()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanResult

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

- (void) setDuration:(NSString*)duration
{
    [self setStringValue:duration forProperty:@"duration"];
}

- (void) setCompletion:(BOOL)completion
{
    [self setBooleanValue:completion forProperty:@"completion"];
}

- (void) setSuccess:(BOOL)success
{
    [self setBooleanValue:success forProperty:@"success"];
}

- (void) setScore:(TincanResultScore*)score
{
    [self setSeerDictionaryObjectData:score forProperty:@"score"];
}

- (NSString*) duration
{
    return [self getStringValueForProperty:@"duration"];
}

- (BOOL) completion
{
    return [self getBooleanValueForProperty:@"completion"];
}

- (BOOL) success
{
    return [self getBooleanValueForProperty:@"success"];
}

- (TincanResultScore*) score
{
    TincanResultScore* trScore = [TincanResultScore new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:@"score"];
    if (dict)
    {
        [trScore setDictionary: dict];
    }
    return trScore;
}

@end
