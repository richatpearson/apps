//
//  PGMClssError.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssError.h"

@implementation PGMClssError

NSString* const PGMClssErrorDomain = @"com.pearson.mobileplatform.ios.pgmclss.ErrorDomain";

+ (NSError*) createClssErrorForErrorCode:(PGMClssClientErrorCode)errorCode
                          andDescription:(NSString*)errorDescription
{
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:NSLocalizedString(errorDescription, nil)
                   forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:PGMClssErrorDomain code:errorCode userInfo:errorDetail];
}

@end
