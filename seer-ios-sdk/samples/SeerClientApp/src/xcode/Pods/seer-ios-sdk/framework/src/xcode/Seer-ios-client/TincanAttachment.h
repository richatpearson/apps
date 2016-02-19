//
//  TincanAttachment.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TincanLanguageMap.h"
#import "SeerDictionaryObject.h"

@interface TincanAttachment : SeerDictionaryObject

- (void) setUsageType:(NSString*)usageType;
- (void) setDisplay:(TincanLanguageMap*)display;
- (void) setAttachmentDescription:(TincanLanguageMap*)desc;
- (void) setContentType:(NSString*)contentType;
- (void) setLength:(NSNumber*)length;
- (void) setSha2:(NSString*)sha2;

- (NSString*) usageType;
- (TincanLanguageMap*) display;
- (TincanLanguageMap*) attachmentDescription;
- (NSString*) contentType;
- (NSNumber*) length;
- (NSString*) sha2;

@end
