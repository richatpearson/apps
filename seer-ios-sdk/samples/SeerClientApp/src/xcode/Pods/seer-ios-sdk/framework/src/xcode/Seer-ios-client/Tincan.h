//
//  Tincan.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TincanActor.h"
#import "TincanVerb.h"
#import "TincanObject.h"
#import "TincanResult.h"
#import "TincanContext.h"
#import "SeerDictionaryObject.h"

@interface Tincan : SeerDictionaryObject

extern NSString* const kTC_id;
extern NSString* const kTC_actor;
extern NSString* const kTC_verb;
extern NSString* const kTC_object;
extern NSString* const kTC_result;
extern NSString* const kTC_context;
extern NSString* const kTC_authority;
extern NSString* const kTC_timestamp;
extern NSString* const kTC_stored;

- (id) initWithUniqueId;

- (id) initWithStatement:(NSDictionary*)tincanStatement;

- (void) setId:(NSString*)tincanId;

- (void) setActor:(TincanActor*)actor;
- (void) setVerb:(TincanVerb*)verb;
- (void) setObject:(TincanObject*)object;
- (void) setResult:(TincanResult*) result;
- (void) setContext:(TincanContext*)context;
- (void) setAuthority:(TincanActor*) authority;

- (void) setTimestamp:(NSString*)timestamp;
- (void) setStored:(NSString*)stored;

- (TincanActor*) setActorWithMbox:(NSString*)mbox;
- (TincanVerb*) setVerbWithId:(NSString*)verbId;
- (TincanObject*) setObjectWithId:(NSString*)objectId;
- (TincanObject*) setObjectWithId:(NSString*)objectId
                       definition:(TincanObjectDefinition*)objDef;
- (TincanContext*) setContextWithExtensions:(TincanContextExtensions*)extensions;

- (id) tincanId;

- (TincanActor*) actor;
- (TincanVerb*) verb;
- (TincanObject*) object;
- (TincanResult*) result;
- (TincanContext*) context;
- (TincanActor*) authority;

- (id) timestamp;
- (id) stored;

@end
