//
//  ActivityStreamActor.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/18/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "ActivityStreamActor.h"

@interface ActivityStreamActor()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation ActivityStreamActor

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

- (void) setId:(NSString*)actorId
{
    [self setStringValue:actorId forProperty:@"id"];
}

- (NSString*) actorId
{
    return [self getStringValueForProperty:@"id"];
}

@end
