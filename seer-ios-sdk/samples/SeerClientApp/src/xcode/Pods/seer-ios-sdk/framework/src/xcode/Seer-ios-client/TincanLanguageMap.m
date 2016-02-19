//
//  TincanLanguageMap.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanLanguageMap.h"

@interface TincanLanguageMap()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanLanguageMap

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

- (id) initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    
    if(self)
    {
        [self.dataDict setDictionary:dict];
    }
    
    return self;
}

@end
