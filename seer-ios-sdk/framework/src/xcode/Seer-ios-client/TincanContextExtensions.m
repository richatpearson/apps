//
//  TincanContextExtensions.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanContextExtensions.h"

@interface TincanContextExtensions()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanContextExtensions

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

- (void) setAppId:(NSString*)appId
{
    [self setStringValue:appId forProperty:@"appId"];
}

- (NSString*) appId
{
    return [self getStringValueForProperty:@"appId"];
}

@end
