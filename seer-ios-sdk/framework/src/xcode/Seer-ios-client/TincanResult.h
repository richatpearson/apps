//
//  TincanResult.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TincanResultScore.h"
#import "SeerDictionaryObject.h"

@interface TincanResult : SeerDictionaryObject

- (void) setDuration:(NSString*)duration;
- (void) setCompletion:(BOOL)completion;
- (void) setSuccess:(BOOL)completion;
- (void) setScore:(TincanResultScore*)score;

- (NSString*) duration;
- (BOOL) completion;
- (BOOL) success;
- (TincanResultScore*) score;

@end
