//
//  PGMCoreLocalizationData.m
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 12/9/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "PGMCoreLocalizationData.h"

NSString* const PGMCoreLanguagePreference = @"languagePreference";
NSString* const PGMCoreLocaleSetting = @"localeSetting";

@interface PGMCoreLocalizationData()

@property (strong, nonatomic, readwrite)   NSString  *   languagePreference;
@property (strong, nonatomic, readwrite)   NSString  *   localeSetting;

@end

@implementation PGMCoreLocalizationData

-(id)init
{
    self = [super init];
    if ( self )
    {
        [self gatherData];
    }
    return self;
}

- (void) gatherData
{
    self.languagePreference = [self getPreferredLanguage];
    self.localeSetting = [self countryCodeLocalization];
}

- (NSDictionary*) dataAsDictionary
{
    NSDictionary* dataDict = @{PGMCoreLanguagePreference : self.languagePreference,
                               PGMCoreLocaleSetting : self.localeSetting
                               };
    return dataDict;
}

- (NSString*)countryCodeLocalization
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *cCode = [locale objectForKey: NSLocaleCountryCode];
    
    return cCode;
}

- (NSString*)countryAsStringForLocaleIdentifier:(NSString*)identifier
{
    if(!identifier)
    {
        identifier = @"en_US";
    }
    
    NSLocale *countryLocale = [[NSLocale alloc] initWithLocaleIdentifier:identifier];
    NSString *country = [countryLocale displayNameForKey: NSLocaleCountryCode value: [self countryCodeLocalization]];
    
    return country;
}

- (NSString*)getPreferredLanguage
{
    NSString *langID = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    return [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:langID];
}

@end
