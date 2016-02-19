//
//  TincanContextActivity.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/24/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerArrayObject.h"
#import "TincanContextActivityItem.h"

@interface TincanContextActivity : SeerArrayObject

- (void) addActivityItem:(TincanContextActivityItem*)activityItem;
- (TincanContextActivityItem*) addActivityItemWithId:(NSString*)activityId;
- (TincanContextActivityItem*) getActivityItemWithId:(NSString*)activityId;

- (void) removeActivityItems:(TincanContextActivityItem*)activityItem;
- (void) removeActivityItemWithId:(NSString*)activityId;

@end
