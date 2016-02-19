//
//  ActivityStreamTarget.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/18/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "ActivityStreamTarget.h"

@interface ActivityStreamTarget()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation ActivityStreamTarget

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

- (void) setId:(NSString*)targetId
{
    [self setStringValue:targetId forProperty:@"id"];
}

- (NSString*) targetId
{
    return [self getStringValueForProperty:@"id"];
}

@end
