//
//  TincanActor.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TincanActorAccount.h"
#import "SeerDictionaryObject.h"

@interface TincanActor : SeerDictionaryObject

extern NSString* const kTC_objectType;
extern NSString* const kTC_mbox;
extern NSString* const kTC_name;
extern NSString* const kTC_account;

- (void) setObjectType:(NSString*) objType;
- (void) setMbox:(NSString*) mbox;
- (void) setName:(NSString*) name;
- (void) setAccount:(TincanActorAccount*)account;

- (void) setAccountWithDictionary:(NSDictionary*)dict;

- (NSString*) objectType;
- (NSString*) mbox;
- (NSString*) name;
- (TincanActorAccount*) account;

@end
