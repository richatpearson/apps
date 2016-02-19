//
//  PearsonNotificationPreferencesTests.m
//  PushNotifications
//
//  Created by Tomack, Barry on 4/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PearsonNotificationPreferences.h"

@interface PearsonNotificationPreferencesTests : XCTestCase

@property (nonatomic, strong) PearsonNotificationPreferences* preferences;

@end

@implementation PearsonNotificationPreferencesTests

- (void)setUp
{
    [super setUp];
    self.preferences = [PearsonNotificationPreferences new];
}

- (void)tearDown
{
    self.preferences = nil;
    [super tearDown];
}

- (void)testInit
{
    XCTAssertTrue(self.preferences, @"PearsonNotificationPreferences not initializing");
}

- (void)testWhiteList
{
    self.preferences.whitelist = @{
                                    @"notificationTypeA": @[],
                                    @"notificationTypeB": @[@"notificationException1", @"notificationException2"]
                                };
    XCTAssertEqual([self.preferences.whitelist count], 2, @"Whitelist in preferences object not setting properly as dictionary");
}

- (void)testBLackList
{
    self.preferences.blacklist = @{
                                     @"notificationTypeC": @[@"notificationException3"],
                                     @"notificationTypeD": @[@"notificationException4", @"notificationException5"],
                                     @"notificationTypeE": @[]
                                };
    XCTAssertEqual([self.preferences.blacklist count], 3, @"Blacklist in preferences object not setting properly as dictionary");
}

- (void) testGetPreferences
{
    self.preferences.whitelist = @{
                                   @"notificationTypeA": @[],
                                   @"notificationTypeB": @[@"notificationException1", @"notificationException2"]
                                   };
    self.preferences.blacklist = @{
                                   @"notificationTypeC": @[@"notificationException3"],
                                   @"notificationTypeD": @[@"notificationException4", @"notificationException5"],
                                   @"notificationTypeE": @[]
                                   };
    
    NSDictionary* mPlatform = [self.preferences getPreferences];
    
    XCTAssertTrue(mPlatform, @"getPreferences not returning a dictionary of preferences");
    
    NSDictionary* prefs = [mPlatform objectForKey:@"preferences"];
    
    XCTAssertTrue(mPlatform, @"getPreferences not returning a dictionary in the proper format");
    XCTAssertEqual(2, [prefs count], @"getPreferences not returning a dictionary in the proper format");
}

- (void) testAddKeyAndExceptionToWhitelist
{
    NSInteger preCount = [self.preferences.whitelist count];
    
    // New Value has to be added to Dictionary
    NSArray* addToList = @[@"newvalue1", @"exception1"];
    [self.preferences addToWhitelist:addToList];
    
    NSInteger postCount = [self.preferences.whitelist count];
    
    XCTAssertEqual(preCount+1, postCount, @"addToWhiteList not adding to whitelist");
    
    NSArray* testArray1 = [self.preferences.whitelist objectForKey:@"newvalue1"];
    NSString* exception1 = [testArray1 objectAtIndex:0];
    
    XCTAssertEqualObjects(exception1, @"exception1", @"addToWhiteList not adding key with exception array to whitelist properly");
}

- (void) testAddKeyWithNoExceptionToBlacklist
{
    NSInteger preCount = [self.preferences.blacklist count];
    
    // New Value has to be added to Dictionary
    NSArray* addToList = @[@"newvalue2"];
    [self.preferences addToBlacklist:addToList];
    
    NSInteger postCount = [self.preferences.blacklist count];
    
    XCTAssertEqual(preCount+1, postCount, @"addToBlackList not adding to blacklist");
    NSArray* testArray2 = [self.preferences.blacklist objectForKey:@"newvalue2"];
    XCTAssertEqual(0, [testArray2 count], @"addToBlackList not adding key without exceptions to blacklist properly");
}

- (void) testAddKeyAndMultipleExceptionsToWhitelist
{
    NSInteger preCount = [self.preferences.whitelist count];
    
    // New Value has to be added to Dictionary
    NSArray* addToList = @[@"newvalue3", @"exception1", @"exception2", @"exception3"];
    [self.preferences addToWhitelist:addToList];
    
    NSInteger postCount = [self.preferences.whitelist count];
    
    XCTAssertEqual(preCount+1, postCount, @"addToWhiteList not adding to whitelist");
    
    NSArray* testArray3 = [self.preferences.whitelist objectForKey:@"newvalue3"];
    
    XCTAssertEqual(3, [testArray3 count], @"addToWhiteList not adding key with multiple exceptions to whitelist properly");
}

@end
