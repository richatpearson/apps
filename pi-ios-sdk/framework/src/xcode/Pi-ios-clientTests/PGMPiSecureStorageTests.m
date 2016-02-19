//
//  PGMPiSecureStorageTests.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 7/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMPiSecureStorage.h"
#import "PGMPiCredentials.h"

@interface PGMPiSecureStorageTests : XCTestCase

@property (nonatomic, strong) PGMPiSecureStorage *secureStorage;

@end

@implementation PGMPiSecureStorageTests

- (void)setUp
{
    [super setUp];
    self.secureStorage = [PGMPiSecureStorage new];
}

- (void)tearDown
{
    self.secureStorage = nil;
    [super tearDown];
}

- (void)testPiClientInit
{
    XCTAssertNotNil(self.secureStorage, @"Error intializing PiSecureStorage");
}

- (void) testStoreData
{
    NSData *credentialsData = [self getSomeCredentialData];
    
    BOOL success = [self.secureStorage storeKeychainData:credentialsData
                                          withIdentifier:@"123456789"
                                                 service:PGMPiSecureCredentialsService
                                   keychainAccessibility:(__bridge id)kSecAttrAccessibleWhenUnlocked
                                             accessGroup:nil];
    
    XCTAssertTrue(success, @"Error storing data in Keychain");
}

- (void) testRetrieveDataSuccess
{
    NSData *credentialsData = [self getSomeCredentialData];
    
    [self.secureStorage storeKeychainData:credentialsData
                           withIdentifier:@"123456789"
                                  service:PGMPiSecureCredentialsService
                    keychainAccessibility:(__bridge id)kSecAttrAccessibleWhenUnlocked
                              accessGroup:nil];
    
    NSData *retrievedData = [self.secureStorage retrieveDataWithIdentifier:@"123456789"
                                                                   service:PGMPiSecureCredentialsService
                                                               accessGroup:nil];
    
    XCTAssertEqualObjects(credentialsData, retrievedData, @"Error with retrieving data from Keychain.");
}

- (void) testRetrieveDataFailure
{
    NSData *credentialsData = [self getSomeCredentialData];
    
    [self.secureStorage storeKeychainData:credentialsData
                           withIdentifier:@"123456789"
                                  service:PGMPiSecureCredentialsService
                    keychainAccessibility:(__bridge id)kSecAttrAccessibleWhenUnlocked
                              accessGroup:nil];
    
    NSData *retrievedData = [self.secureStorage retrieveDataWithIdentifier:@"123456"
                                                                   service:PGMPiSecureCredentialsService
                                                               accessGroup:nil];
    
    XCTAssertNotEqualObjects(credentialsData, retrievedData, @"Error with retrieving data from Keychain.");
}

- (void) testDeleteDataSuccess
{
    NSData *credentialsData = [self getSomeCredentialData];
    
    [self.secureStorage storeKeychainData:credentialsData
                           withIdentifier:@"123456789"
                                  service:PGMPiSecureCredentialsService
                    keychainAccessibility:(__bridge id)kSecAttrAccessibleWhenUnlocked
                              accessGroup:nil];
    
    BOOL deleted = [self.secureStorage deleteDataWithIdentifer:@"123456789"
                                                       service:PGMPiSecureCredentialsService
                                                   accessGroup:nil];
    
    XCTAssertTrue(deleted, @"Error deleting data from Keychain.");
}

- (void) testDeleteDataFailure
{
    NSData *credentialsData = [self getSomeCredentialData];
    
    [self.secureStorage storeKeychainData:credentialsData
                           withIdentifier:@"123456789"
                                  service:PGMPiSecureCredentialsService
                    keychainAccessibility:(__bridge id)kSecAttrAccessibleWhenUnlocked
                              accessGroup:nil];
    
    BOOL deleted = [self.secureStorage deleteDataWithIdentifer:@"1234567"
                                                       service:PGMPiSecureCredentialsService
                                                   accessGroup:nil];
    
    XCTAssertFalse(deleted, @"Error deleting data from Keychain.");
}


- (NSData*) getSomeCredentialData
{
    PGMPiCredentials *credentials = [PGMPiCredentials credentialsWithUsername:@"UnitTest" password:@"P@ssword"];
    return [NSKeyedArchiver archivedDataWithRootObject:credentials];
}

@end
