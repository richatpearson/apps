//
//  ActivityStream.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/18/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityStreamActor.h"
#import "ActivityStreamObject.h"
#import "ActivityStreamGenerator.h"
#import "ActivityStreamTarget.h"
#import "SeerDictionaryObject.h"

@interface ActivityStream : SeerDictionaryObject

extern NSString* const kAS_actor;
extern NSString* const kAS_generator;
extern NSString* const kAS_object;
extern NSString* const kAS_target;
extern NSString* const kAS_verb;
extern NSString* const kAS_published;
extern NSString* const kAS_context;

- (id) initWithPayload:(NSDictionary*)payload;

- (void) setVerb:(NSString*)verb;
- (void) setPublished:(NSString*)published;

- (ActivityStreamActor*) setActorWithId:(NSString*)actorId;
- (ActivityStreamGenerator*) setGeneratorWithAppId:(NSString*)appId;
- (ActivityStreamObject*) setObjectWithId:(NSString*)objectId objectType:(NSString*)objectType;
- (ActivityStreamTarget*) setTargetWithId:(NSString*)targetId;

- (void) setActor:(ActivityStreamActor*)actor;
- (void) setGenerator:(ActivityStreamGenerator*)generator;
- (void) setObject:(ActivityStreamObject*)object;
- (void) setTarget:(ActivityStreamTarget*)target;

- (void) setContext:(NSDictionary*)context;

- (ActivityStreamActor*) actor;
- (ActivityStreamGenerator*) generator;
- (ActivityStreamObject*) object;
- (ActivityStreamTarget*) target;
- (NSDictionary*) context;
- (NSString*) verb;
- (NSString*) published;

@end
