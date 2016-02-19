//
//  PGMSmsError.m
//  sms-collections-client
//
//  Created by Joe Miller on 12/1/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMSmsError.h"

NSString * const PGMSmsErrorDomain = @"com.pearsoned.gridmobile.sms-collections-client.ErrorDomain";

@implementation PGMSmsError

+ (NSError *)createErrorForErrorCode:(PGMSmsClientErrorCode)errorCode
                      andDescription:(NSString *)errorDescription
{
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:NSLocalizedString(errorDescription, nil)
                   forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:PGMSmsErrorDomain code:errorCode userInfo:errorDetail];
}

@end
