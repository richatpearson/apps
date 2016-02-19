//
//  TincanResultScore.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerDictionaryObject.h"

@interface TincanResultScore : SeerDictionaryObject

- (void) setMin:(NSNumber*)min;
- (void) setMax:(NSNumber*)max;
- (void) setRaw:(NSNumber*)raw;
- (void) setScaled:(NSNumber*)scaled;

- (NSNumber*) min;
- (NSNumber*) max;
- (NSNumber*) raw;
- (NSNumber*) scaled;

@end
