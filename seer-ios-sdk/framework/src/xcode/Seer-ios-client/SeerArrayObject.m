//
//  SeerArrayObject.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/24/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "SeerArrayObject.h"

@interface SeerArrayObject()

@property (nonatomic, strong, readwrite) NSMutableArray* dataArray;

@end

@implementation SeerArrayObject

- (void) addSeerDictionaryObjectData:(SeerDictionaryObject*)anObject
{
    [[self asArray] addObject:[anObject asDictionary]];
}

- (void) removeSeerDictionaryObjectData:(SeerDictionaryObject*)anObject
{
    [[self asArray] removeObject:[anObject asDictionary]];
}

- (NSMutableArray*) asArray
{
    return self.dataArray;
}

- (void) setArray:(NSArray*)array
{
    if (! self.dataArray)
    {
        self.dataArray = [NSMutableArray new];
    }
    
    BOOL okToSet = YES;
    
    for (NSUInteger i=0; i < [array count]; i++)
    {
        if (![[array objectAtIndex:i] isKindOfClass:[NSDictionary class]])
        {
            okToSet = NO;
            break;
        }
    }
    if (okToSet)
    {
        [self.dataArray setArray:array];
    }
    else
    {
        NSLog(@"SeerArrayObject Error: Can only accept an array of dictionary objects");
    }
}

@end
