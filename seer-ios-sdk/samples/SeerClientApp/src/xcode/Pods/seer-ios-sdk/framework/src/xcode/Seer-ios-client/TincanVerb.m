//
//  TincanVerb.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanVerb.h"

@interface TincanVerb()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanVerb

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

- (void) setId:(NSString*)verbId
{
    [self setStringValue:verbId forProperty:@"id"];
}

- (void) setDislay:(TincanLanguageMap*)display
{
    [self setSeerDictionaryObjectData:display forProperty:@"display"];
}

- (NSString*) verbId
{
    return [self getStringValueForProperty:@"id"];
}

- (TincanLanguageMap*) display
{
    TincanLanguageMap* tcVerbDisplay = [TincanLanguageMap new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:@"display"];
    if (dict)
    {
        [tcVerbDisplay setDictionary: dict];
    }
    return tcVerbDisplay;
}

@end
