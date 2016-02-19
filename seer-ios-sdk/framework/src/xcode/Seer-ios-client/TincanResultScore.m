//
//  TincanResultScore.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanResultScore.h"

@interface TincanResultScore()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanResultScore

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

- (void) setMin:(NSNumber*)min
{
    [self setNumberValue:min forProperty:@"min"];
}

- (void) setMax:(NSNumber*)max
{
    [self setNumberValue:max forProperty:@"max"];
}

- (void) setRaw:(NSNumber*)raw
{
    [self setNumberValue:raw forProperty:@"raw"];
}

- (void) setScaled:(NSNumber*)scaled
{
    [self setNumberValue:scaled forProperty:@"scaled"];
}

- (NSNumber*) min
{
    return [self getNumberValueForProperty:@"min"];
}

- (NSNumber*) max
{
    return [self getNumberValueForProperty:@"max"];
}

- (NSNumber*) raw
{
    return [self getNumberValueForProperty:@"raw"];
}

- (NSNumber*) scaled
{
    return [self getNumberValueForProperty:@"scaled"];
}

@end
