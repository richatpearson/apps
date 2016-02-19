//
//  TincanContext.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TincanContextExtensions.h"
#import "TincanContextActivities.h"
#import "TincanActor.h"
#import "SeerDictionaryObject.h"

@interface TincanContext : SeerDictionaryObject

- (void) setRevision:(NSString*)revision;
- (void) setPlatform:(NSString*)platform;
- (void) setLanguage:(NSString*)language;
- (void) setExtensions:(TincanContextExtensions*)extensions;
- (void) setInstructor:(TincanActor*)instructor;
- (void) setContextActivities:(TincanContextActivities*)contextActivities;

- (NSString*) revision;
- (NSString*) platform;
- (NSString*) language;
- (TincanContextExtensions*) extensions;
- (TincanActor*) instructor;
- (TincanContextActivities*) contextActivities;

- (TincanContextExtensions*) setExtensionsWithAppId:(NSString*)appId;

@end
