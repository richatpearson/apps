//
//  TincanActorAccount.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerDictionaryObject.h"

@interface TincanActorAccount : SeerDictionaryObject

- (void) setHomepage:(NSString*)accountHomepage;
- (void) setName:(NSString*)accountName;

- (NSString*) homePage;
- (NSString*) name;

@end
