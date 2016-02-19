//
//  ActivityStreamObject.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/18/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerDictionaryObject.h"

@interface ActivityStreamObject : SeerDictionaryObject

- (void) setId:(NSString*)objectId;
- (void) setObjectType:(NSString*)objectType;

- (NSString*) objectId;
- (NSString*) objectType;

@end
