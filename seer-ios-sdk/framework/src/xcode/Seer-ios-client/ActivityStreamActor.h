//
//  ActivityStreamActor.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/18/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerDictionaryObject.h"

@interface ActivityStreamActor : SeerDictionaryObject

- (void) setId:(NSString*)actorId;

- (NSString*) actorId;

@end
