//
//  PearsonNotificationsValidator.m
//  PushNotifications
//
//  Created by Tomack, Barry on 3/19/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PearsonNotificationsValidator.h"

@implementation PearsonNotificationsValidator

- (BOOL) validGroupName:(NSString*)groupName
{
    // Check for nil
    if(groupName)
    {
        if (! [self validateGroupNameLength:groupName])
        {
            return NO;
        }
        if( ! [self validateGroupNameCharacters:groupName])
        {
            return NO;
        }
    }
    else
    {
       return NO;
    }
    
    return YES;
}

- (BOOL)validateGroupNameLength:(NSString*)groupName
{
    NSUInteger nameLength = [groupName length];
    if (nameLength < 1 || nameLength > 128)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateGroupNameCharacters:(NSString*)groupName
{
    NSError  *error  = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z0-9-]"
                                                                           options:0
                                                                             error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:groupName
                                                        options:0
                                                          range:NSMakeRange(0, [groupName length])];
    
    if (numberOfMatches > 0)
    {
        return NO;
    }
    
    return YES;
}

@end
