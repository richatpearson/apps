//
//  SeerUtility.h
//  Seer-ios-client
//
//  Created by Tomack, Barry on 12/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerClient.h"

/*!
 Contains a collection helpful utility class methods.
 */
@interface SeerUtility : NSObject

/*!
 Converts a NSDate value to an iso8601 formatted string
 
 @param date NSDate to be converted
 
 @return the incoming NSdate object converted to the string format ("%Y-%m-%dT%H:%M:%SZ")
 */
+ (NSString*) iso8601StringFromDate:(NSDate*)incomingDate;

/*!
 Converts a NSString in the form of an iso8601 date into a
 
 @param iso8601 iso8601 formatted string
 
 @return NSDate object set to the given number of seconds from the first instant 
 of 1 January 1970, GMT.
 */
+ (NSDate*) iso8601DateFromString:(NSString *)iso8601;

/*!
 Generates a Universally Unique Identifier
 
 @return The string representation of uuid.
 */
+ (NSString*) uniqueId;

// Borrowed from AFNetworking
/*!
 Converts a string into a Base64 Encoded string. This method is necessary for applications 
 supporting iOS versions prior to iOS 7.0
 
 @param string any string
 
 @return a Base64 encoded ASCII string
 */
+ (NSString*) AFBase64EncodedStringFromString:(NSString*)string;

/*!
 A method for converting KB or MB values into bytes
 
 @param byteAmt  The amount to be converted.
 @param byteUnit The units for the amount to be converted.
 
 @return The incoming value coanverted to bytes.
 */
+ (NSUInteger) convertToBytes:(NSUInteger)byteAmt fromUnit:(NSInteger)byteUnit;
                                               
@end
