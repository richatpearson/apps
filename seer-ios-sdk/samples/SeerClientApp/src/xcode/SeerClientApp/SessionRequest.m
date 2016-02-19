//
//  SessionRequest.m
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/13/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "SessionRequest.h"

@implementation SessionRequest

NSString* const seerRequestTypeArray[] = {
    @"pending",
    @"failure",
    @"error",
    @"success"
};

- (NSString*) objectType
{
    NSString* objType = @"";
    if ([self.requestType isEqualToString:kSEER_TincanReport])
    {
        objType = [self tincanObjectId];
    }
    else if ([self.requestType isEqualToString:kSEER_ActivityStreamReport])
    {
        objType = [self actvityStreamObjectType];
    }
    
    return objType;
}

- (NSString*) tincanObjectId
{
    NSDictionary* objectDict = [self.jsonDict objectForKey:@"object"];
    NSDictionary* objDefinition = [objectDict objectForKey:@"definition"];
    NSDictionary* objDesc = [objDefinition objectForKey:@"description"];

    return [objDesc objectForKey:@"en-US"];
}

- (NSString*) actvityStreamObjectType
{
    NSDictionary* objectDict = [self.jsonDict objectForKey:@"object"];
    
    return [objectDict objectForKey:@"objectType"];
}

- (NSString*) displayVerb
{
    NSString* verb = @"";
    if ([self.requestType isEqualToString:kSEER_TincanReport])
    {
        verb = [self tincanVerb];
    }
    else if ([self.requestType isEqualToString:kSEER_ActivityStreamReport])
    {
        verb = [self activityStreamVerb];
    }
    
    return verb;
}

- (NSString*) tincanVerb
{
    NSDictionary* verbDict = [self.jsonDict objectForKey:@"verb"];
    
    NSDictionary* displayDict = [verbDict objectForKey:@"display"];
    
    return [displayDict objectForKey:@"en-US"];
}

- (NSString*) activityStreamVerb
{
    return [self.jsonDict objectForKey:@"verb"];
}
         
-(NSString*) seerRequestStatusToString:(SeerRequestStatus)statusVal
{
    return seerRequestTypeArray[statusVal];
}

- (SeerRequestStatus) seerRequestStatusStringToEnum:(NSString*)strVal
{
    int retVal = 0;
    for(int i=0; i < sizeof(seerRequestTypeArray)-1; i++)
    {
        if([(NSString*)seerRequestTypeArray[i] isEqualToString:strVal])
        {
            retVal = i;
            break;
        }
    }
    return (SeerRequestStatus)retVal;
}

- (NSString*) getRequestTypeAbbreviation
{
    NSString* abbrev = @"";
    
    if(self.requestType)
    {
        if([self.requestType isEqualToString:kSEER_TincanReport])
        {
            abbrev = @"TC";
        }
        if([self.requestType isEqualToString:kSEER_ActivityStreamReport])
        {
            abbrev = @"AS";
        }
    }
    
    return abbrev;
}

@end
