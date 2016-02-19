//
//  TincanContextActivities.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TincanContextActivity.h"
#import "SeerDictionaryObject.h"

@interface TincanContextActivities : SeerDictionaryObject

- (void) setParent:(TincanContextActivity*)parent;
- (void) setGrouping:(TincanContextActivity*)grouping;
- (void) setCategory:(TincanContextActivity*)category;
- (void) setOther:(TincanContextActivity*)other;

- (TincanContextActivity*) setParentWithId:(NSString*)parentId;
- (TincanContextActivity*) setGroupingWithId:(NSString*)groupingId;
- (TincanContextActivity*) setCategoryWithId:(NSString*)categoryId;
- (TincanContextActivity*) setOtherWithId:(NSString*)otherId;

- (TincanContextActivity*)parent;
- (TincanContextActivity*)grouping;
- (TincanContextActivity*)category;
- (TincanContextActivity*)other;

@end
