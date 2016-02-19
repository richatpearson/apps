//
//  TincanObject.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TincanObjectDefinition.h"
#import "SeerDictionaryObject.h"

@interface TincanObject : SeerDictionaryObject

- (void) setId:(NSString*)objectId;
- (void) setObjectType:(NSString*)objectType;
- (void) setObjectDefinition:(TincanObjectDefinition*)definition;

- (NSString*) objectId;
- (NSString*) objectType;
- (TincanObjectDefinition*) objectDefinition;

- (TincanObjectDefinition*) setDefinitionWithType:(NSString*)defType;

@end
