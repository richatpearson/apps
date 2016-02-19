//
//  TincanAttachments.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanAttachments.h"

@interface TincanAttachments()

@property (nonatomic, strong, readwrite) NSMutableArray* dataArray;

@end

@implementation TincanAttachments

@synthesize dataArray = _dataArray;

- (id) init
{
    self = [super init];
    if(self)
    {
        self.dataArray = [NSMutableArray new];
    }
    return self;
}

- (void) addAttachment:(TincanAttachment*)attachment
{
    [self addSeerDictionaryObjectData:attachment];
}

- (void) removeAttachment:(TincanAttachment*)attachment
{
    [self removeSeerDictionaryObjectData:attachment];
}

- (TincanAttachment*) getAttachmentWithSHA2:(NSString*)sha2
{
    TincanAttachment* attachment = [TincanAttachment new];
    if ([self.dataArray count] > 0)
    {
        for( NSUInteger i=0; i<[self.dataArray count]; i++ )
        {
            NSDictionary* dict = [self.dataArray objectAtIndex:i];
            if([[dict objectForKey:@"sha2"] isEqualToString:sha2])
            {
                [attachment setDictionary:dict];
                return attachment;
            }
        }
    }
    return nil;
}

- (void) removeAttachmentWithSha2:(NSString*)sha2
{
    if ([self.dataArray count] > 0)
    {
        for( NSUInteger i=0; i<[self.dataArray count]; i++ )
        {
            NSDictionary* dict = [self.dataArray objectAtIndex:i];
            if([[dict objectForKey:@"sha2"] isEqualToString:sha2])
            {
                [self.dataArray removeObject:dict];
                break;
            }
        }
    }
}

@end
