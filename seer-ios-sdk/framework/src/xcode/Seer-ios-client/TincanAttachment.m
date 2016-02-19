//
//  TincanAttachment.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanAttachment.h"

@interface TincanAttachment()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanAttachment

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

- (void) setUsageType:(NSString*)usageType
{
    [self  setStringValue:usageType forProperty:@"usageType"];
}

- (void) setDisplay:(TincanLanguageMap*)display
{
    [self  setSeerDictionaryObjectData:display forProperty:@"display"];
}

- (void) setAttachmentDescription:(TincanLanguageMap*)desc
{
    [self  setSeerDictionaryObjectData:desc forProperty:@"description"];
}

- (void) setContentType:(NSString*)contentType
{
    [self  setStringValue:contentType forProperty:@"contentType"];
}

- (void) setLength:(NSNumber*)length
{
    [self  setNumberValue:length forProperty:@"length"];
}

- (void) setSha2:(NSString*)sha2
{
    [self  setStringValue:sha2 forProperty:@"sha2"];
}

- (NSString*) usageType
{
    return [self getStringValueForProperty:@"usageType"];
}

- (TincanLanguageMap*) display
{
    TincanLanguageMap* tcaDisplay = [TincanLanguageMap new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:@"display"];
    if (dict)
    {
        [tcaDisplay setDictionary:dict];
    }
    return tcaDisplay;
}

- (TincanLanguageMap*) attachmentDescription
{
    TincanLanguageMap* tcaDescription = [TincanLanguageMap new];
    NSMutableDictionary* dict = [self getSeerDictionaryObjectDataForProperty:@"description"];
    if (dict)
    {
        [tcaDescription setDictionary:dict];
    }
    return tcaDescription;
}

- (NSString*) contentType
{
    return [self getStringValueForProperty:@"contentType"];
}

- (NSNumber*) length
{
    return [self getNumberValueForProperty:@"length"];
}

- (NSString*) sha2
{
    return [self getStringValueForProperty:@"sha2"];
}

@end
