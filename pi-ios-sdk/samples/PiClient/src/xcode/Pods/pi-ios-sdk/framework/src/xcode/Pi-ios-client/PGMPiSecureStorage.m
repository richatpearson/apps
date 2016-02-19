//
//  PGMPiSecureStorage.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/29/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//
//  Reference for converting object to data: http://sam.roon.io/archiving-objective-c-objects-with-nscoding

#import "PGMPiSecureStorage.h"
#import <Security/Security.h>

NSString * const PGMPiSecureStorageLabel        = @"PiSecureStorage";
NSString * const PGMPiSecureCredentialsService  = @"PiSecureCredentialsService";
NSString * const PGMPiSecureTokenService        = @"PiSecureTokenService";

@implementation PGMPiSecureStorage

#pragma mark generic keychain CRUD

- (BOOL) storeKeychainData:(NSData *)data
            withIdentifier:(NSString *)identifier
                   service:(NSString *)service
     keychainAccessibility:(id)keychainAccessibility
               accessGroup:(NSString *)accessGroup
{
    NSMutableDictionary *queryKeychainDict = [self queryDictWithIdentifier:identifier
                                                                   service:service
                                                               accessGroup:accessGroup];
    
    NSMutableDictionary *updateKeychainDict = [NSMutableDictionary dictionary];
    [updateKeychainDict setObject:data forKey:(__bridge id)kSecValueData];
    [updateKeychainDict setObject:keychainAccessibility forKey:(__bridge id)kSecAttrAccessible];
    
    OSStatus osStatus;
    
    NSData* retrievedData = [self retrieveDataWithIdentifier:identifier service:service accessGroup:accessGroup];
    
    if (retrievedData)
    {
        // Update existing credentials
        osStatus = SecItemUpdate((__bridge CFDictionaryRef)queryKeychainDict, (__bridge CFDictionaryRef)updateKeychainDict);
    }
    else
    {
        // Create new entry
        [queryKeychainDict addEntriesFromDictionary:updateKeychainDict];
        osStatus = SecItemAdd((__bridge CFDictionaryRef)queryKeychainDict, NULL);
    }
    //NSLog(@"osStatus: %d", (int)osStatus);
    if (osStatus == errSecSuccess)
    {
        //NSLog(@"SAVED TO KEYCHAIN: %@", [[NSString alloc] initWithData:[self retrieveDataWithIdentifier:identifier service:service accessGroup:accessGroup] encoding:NSUTF8StringEncoding]);
        return YES;
    } else {
        NSLog(@"Error securely storing %@", service);
        return NO;
    }
}

- (NSMutableDictionary *) queryDictWithIdentifier:(NSString *)identifier
                                            service:(NSString *)service
                                      accessGroup:(NSString *)accessGroup
{
    NSMutableDictionary *queryDict = [[NSMutableDictionary alloc] init];
    
    [queryDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    [queryDict setObject:service forKey:(__bridge id)kSecAttrService];
    [queryDict setObject:identifier forKey:(__bridge id)kSecAttrAccount];
    [queryDict setObject:PGMPiSecureStorageLabel forKey:(__bridge id)kSecAttrLabel];
#if TARGET_IPHONE_SIMULATOR
    // Ignore the access group if running on the iPhone simulator
#else
    if (accessGroup != nil)
    {
        [queryDict setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif
    
    return queryDict;
}

- (NSData *) retrieveDataWithIdentifier:(NSString *)identifier
                                  service:(NSString *)service
                            accessGroup:(NSString *)accessGroup
{
    NSMutableDictionary *queryKeychainDict = [self queryDictWithIdentifier:identifier
                                                                   service:service
                                                               accessGroup:accessGroup];

    [queryKeychainDict setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [queryKeychainDict setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef result = nil;
    OSStatus osStatus = SecItemCopyMatching((__bridge CFDictionaryRef)queryKeychainDict, (CFTypeRef *)&result);
    //NSLog(@"retrieveDataWithIdentifier osStatus: %d", (int)osStatus);
    if (osStatus != errSecSuccess)
    {
        NSLog(@"Failure retrieving keychain data for %@", service);
        return nil;
    }
    
    NSData *data = (__bridge_transfer NSData *)result;
    return data;
}

- (BOOL) deleteDataWithIdentifer:(NSString *)identifier
                         service:(NSString *)service
                     accessGroup:(NSString*)accessGroup
{
    NSMutableDictionary *queryKeychainDict = [self queryDictWithIdentifier:identifier
                                                                   service:service
                                                               accessGroup:accessGroup];
    
    OSStatus osStatus = SecItemDelete((__bridge CFDictionaryRef)queryKeychainDict);
    
    if (osStatus != errSecSuccess)
    {
        NSLog(@"Error deleting data for %@", service);
    }
    
    return (osStatus == errSecSuccess);
}

@end
