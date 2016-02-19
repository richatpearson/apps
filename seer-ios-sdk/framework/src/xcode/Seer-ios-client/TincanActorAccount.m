//
//  TincanActorAccount.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanActorAccount.h"

@interface TincanActorAccount()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanActorAccount

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

- (void) setHomepage:(NSString*)accountHomepage
{
    [self setStringValue:accountHomepage forProperty:@"homePage"];
}

- (void) setName:(NSString*)accountName
{
    [self setStringValue:accountName forProperty:@"name"];
}

- (NSString*) homePage
{
    return [self getStringValueForProperty:@"homePage"];
}

- (NSString*) name
{
    return [self getStringValueForProperty:@"name"];
}

@end
