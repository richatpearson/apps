//
//  DateUtil.h
//  classroom-ios
//
//  Created by Joe Miller on 10/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMClssDateUtil : NSObject

extern NSString *const DateFormat;

/*!
 Parses a date from the provided formatted string. The constant DateFormat specifies the expected format.
 This method will return nil when an invalid string is provided.
 */
+ (NSDate*)parseDateFromString:(NSString*)stringDate;

@end
