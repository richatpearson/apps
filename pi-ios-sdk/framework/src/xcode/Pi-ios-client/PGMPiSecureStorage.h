//
//  PGMPiSecureStorage.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/29/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMPiCredentials.h"
#import "PGMPiToken.h"

extern NSString * const PGMPiSecureStorageLabel;
extern NSString * const PGMPiSecureCredentialsService;
extern NSString * const PGMPiSecureTokenService;

/*!
 Basic CRUD functionality for secure storage of Identity data into 
 Apple's keychain services.
 
 This class incorporates Apple's Keychain example wrapper.
 */
@interface PGMPiSecureStorage : NSObject

/*!
 Method to store data in Apple's Keychain services. This method checks for the 
 existence of a record to determine if it performs an Update or a Create.
 
 @param data                  The data to be stored
 @param identifier            The key identifier to store the data under
 @param service               The service to store the data under
 @param keychainAccessibility How the data is allowed to be accessed
 @param accessGroup           The access group that is allowed to access the data.
 
 @return Indicates if storage of data was successful.
 */
- (BOOL) storeKeychainData:(NSData *)data
            withIdentifier:(NSString *)identifier
                   service:(NSString *)service
     keychainAccessibility:(id)keychainAccessibility
               accessGroup:(NSString *)accessGroup;

/*!
 Method for retrieving securely stored data from Apple's Keychain services.
 
 @param identifier  The key unique identifier the data is stored under
 @param service     The service that the data is stored under
 @param accessGroup The access group allowed to retrieve the data
 
 @return The retrieved data to be decoded using the NSKeyedUnarchiver
 */
- (NSData *) retrieveDataWithIdentifier:(NSString *)identifier
                                service:(NSString *)service
                            accessGroup:(NSString *)accessGroup;

/*!
 Method to delete securely stored data from Apple's Keychain Services
 
 @param identifier  The key unique identifier the data is stored under
 @param service     the service that the data is stored under
 @param accessGroup The access group allowed to access the data
 
 @return Indicates the success of the deletion of the data.
 */
- (BOOL) deleteDataWithIdentifer:(NSString *)identifier
                         service:(NSString *)service
                     accessGroup:(NSString*)accessGroup;

@end
