//
//  TincanContextActivity.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanContextActivityItem.h"

@interface TincanContextActivityItem()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanContextActivityItem

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

- (void) setId:(NSString*)activityId
{
    [self setStringValue:activityId forProperty:@"id"];
}

- (NSString*) activityId
{
    return [self getStringValueForProperty:@"id"];
}


@end
