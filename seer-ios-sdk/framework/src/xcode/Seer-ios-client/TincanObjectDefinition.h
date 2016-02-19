//
//  TincanObjectDefinition.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TincanLanguageMap.h"
#import "SeerDictionaryObject.h"

@interface TincanObjectDefinition : SeerDictionaryObject

- (void) setType:(NSString*)type;
- (void) setNameWithDictionary:(NSDictionary*)nameDict;
- (void) setDescriptionWithDictionary:(NSDictionary*)descDict;


- (void) setName:(TincanLanguageMap*)name;
- (void) setDefDescription:(TincanLanguageMap*)desc;

- (NSString*) type;
- (TincanLanguageMap*) name;
- (TincanLanguageMap*) defDescription;

@end
