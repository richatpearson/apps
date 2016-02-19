//
//  TincanAttachments.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerArrayObject.h"
#import "TincanAttachment.h"

@interface TincanAttachments : SeerArrayObject

- (void) addAttachment:(TincanAttachment*)attachment;
- (TincanAttachment*) getAttachmentWithSHA2:(NSString*)sha2;

- (void) removeAttachment:(TincanAttachment*)attachment;
- (void) removeAttachmentWithSha2:(NSString*)sha2;

@end
