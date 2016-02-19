//
//  NSString+Numeric.m
//  sms-collections-client
//
//  Created by Joe Miller on 12/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "NSString+Numeric.h"

@implementation NSString(Numeric)

- (BOOL)isNumeric
{
    NSNumberFormatter *f = [NSNumberFormatter new];
    NSNumber *n = [f numberFromString:self];
    return !!n;
}

@end
