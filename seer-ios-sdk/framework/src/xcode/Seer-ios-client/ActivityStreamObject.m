//
//  ActivityStreamObject.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/18/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "ActivityStreamObject.h"

@interface ActivityStreamObject()

@property (nonatomic, strong) NSMutableDictionary* dataDict;

@end

@implementation ActivityStreamObject

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

- (void) setId:(NSString*)objectId
{
    [self setStringValue:objectId forProperty:@"id"];
}

- (void) setObjectType:(NSString*)objectType
{
    [self setStringValue:objectType forProperty:@"objectType"];
}

- (NSString*) objectId
{
    return [self getStringValueForProperty:@"id"];
}

- (NSString*) objectType
{
    return [self getStringValueForProperty:@"objectType"];
}

@end
