//
//  TincanVerb.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TincanLanguageMap.h"
#import "SeerDictionaryObject.h"

@interface TincanVerb : SeerDictionaryObject

- (void) setId:(NSString*)verbId;
- (void) setDislay:(TincanLanguageMap*)display;

- (NSString*) verbId;
- (TincanLanguageMap*) display;

@end
