//
//  TincanContextActivity.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/24/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanContextActivity.h"

@interface TincanContextActivity()

@property (nonatomic, strong, readwrite) NSMutableArray* dataArray;

@end

@implementation TincanContextActivity

@synthesize dataArray = _dataArray;

- (id) init
{
    self = [super init];
    if(self)
    {
        self.dataArray = [NSMutableArray new];
    }
    return self;
}

- (void) addActivityItem:(TincanContextActivityItem*)activityItem
{
    [[self asArray] addObject:[activityItem asDictionary]];
}

- (TincanContextActivityItem*) addActivityItemWithId:(NSString*)activityId
{
    TincanContextActivityItem* activityItem = [TincanContextActivityItem new];
    [activityItem setId:activityId];
    
    [[self asArray] addObject:[activityItem asDictionary]];
    
    return activityItem;
}

- (TincanContextActivityItem*) getActivityItemWithId:(NSString*)activityId
{
    TincanContextActivityItem* activityItem = [TincanContextActivityItem new];
    
    if ([self.dataArray count] > 0)
    {
        for( NSUInteger i=0; i<[self.dataArray count]; i++ )
        {
            NSDictionary* dict = [self.dataArray objectAtIndex:i];
            if([[dict objectForKey:@"id"] isEqualToString:activityId])
            {
                [activityItem setDictionary:dict];
                return activityItem;
            }
        }
    }
    return nil;
}

- (void) removeActivityItems:(TincanContextActivityItem*)activityItem
{
    [self removeSeerDictionaryObjectData:activityItem];
}

- (void) removeActivityItemWithId:(NSString*)activityId
{
    if ([self.dataArray count] > 0)
    {
        for( NSUInteger i=0; i<[self.dataArray count]; i++ )
        {
            NSDictionary* dict = [self.dataArray objectAtIndex:i];
            if([[dict objectForKey:@"id"] isEqualToString:activityId])
            {
                [self.dataArray removeObject:dict];
                break;
            }
        }
    }
}

@end
