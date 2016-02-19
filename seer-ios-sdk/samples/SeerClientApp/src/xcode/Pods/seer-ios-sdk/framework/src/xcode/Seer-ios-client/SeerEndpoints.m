//
//  SeerEndpoints.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/17/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "SeerEndpoints.h"

@interface SeerEndpoints ()

@property (nonatomic, strong) NSString* baseURL;
@property (nonatomic, strong) NSMutableDictionary* endpoints;
@property (nonatomic, strong) NSString* apiKey;

@end

@implementation SeerEndpoints

NSString* const kSEER_BaseURL = @"https://seer-beacon.qaprod.ecollege.com";

- (id) init
{
    return [self initWithApiKey:nil];
}

- (id) initWithApiKey:(NSString*)apiKey
{
    if(self = [super init])
    {
        self.baseURL    = kSEER_BaseURL;
        self.endpoints  = [NSMutableDictionary new];
        self.apiKey     = apiKey;
    }
    
    return self;
}

- (void) addEndpoint:(NSString*)endpoint forName:(NSString*)name
{
    NSString* cleanEndpoint = [self trimSlashesFromEnds:endpoint];
    [self.endpoints setObject:cleanEndpoint forKey:name];
}

- (void) changeSeerBaseURL:(NSString*)newBaseURL
{
    self.baseURL = newBaseURL;
}

- (NSString*) getSeerBaseURL
{
    return self.baseURL;
}

- (NSString*) urlStringForEndpoint:(NSString*)name
{
    NSString* urlString = @"";
    NSString* endPoint = [self.endpoints objectForKey:name];
    
    if (endPoint)
    {
        urlString = [NSString stringWithFormat:@"%@/%@", self.baseURL, endPoint];
        
        if(self.apiKey)
        {
            urlString = [NSString stringWithFormat:@"%@?apikey=%@", urlString, self.apiKey];
        }
    }
    return urlString;
}

- (NSString*) trimSlashesFromEnds:(NSString*)endpoint
{
    NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"/"];
    
    NSString* cleanEndpoint = [endpoint stringByTrimmingCharactersInSet:charSet];
    
    return cleanEndpoint;
}

- (NSDictionary*) seerEndpoints
{
    return self.endpoints;
}

@end
