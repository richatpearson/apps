//
//  SeerServerRequest.m
//  Seer-ios-client
//
//  Created by Tomack, Barry on 1/29/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "SeerServerRequest.h"

@implementation SeerServerRequest

- (id) init
{
    if (self = [super init])
    {
        self.requestCreated = [[NSDate date] timeIntervalSince1970];
        self.requestStatus = kServerRequestStatusPending;
    }
    
    return self;
}

- (id) payloadAsJSONString:(NSDictionary*) dict
{
    return [self jsonStringFromDict:dict withOption:kNilOptions];
}

- (id) payloadAsPrettyJSONString:(NSDictionary*) dict
{
    return [self jsonStringFromDict:dict withOption:NSJSONWritingPrettyPrinted];
}

- (id) jsonStringFromDict:(NSDictionary*)dict withOption:(NSJSONWritingOptions)opt
{
    NSString* jsonStr = @"";
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:opt
                                                         error:&error];
    if(!jsonData)
    {
        return error;
    }
    
    jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Escape any single quotes
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSLog(@"payloadAsJSONString: %@", jsonStr);
    return jsonStr;
}


@end
