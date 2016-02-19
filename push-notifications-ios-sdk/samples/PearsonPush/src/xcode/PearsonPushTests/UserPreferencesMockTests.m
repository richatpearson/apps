//
//  UserPreferencesMockTests.m
//  PearsonPush
//
//  Created by Richard Rosiak on 2/11/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserPreferencesViewController.h"
#import <PushNotifications/PearsonPushNotifications.h>
#import <PushNotifications/PearsonNotificationPreferences.h>
#import "AppDelegate.h"
#import <OCMock/OCMock.h>

@interface UserPreferencesMockTests : XCTestCase

@property (strong, nonatomic) UserPreferencesViewController *controller;

@end

@implementation UserPreferencesMockTests

- (void)setUp
{
    [super setUp];
    
    // Put setup code here; it will be run once, before the first test case.
    
    self.controller = [[UserPreferencesViewController alloc] init];
    [self.controller initProperties];
    self.controller.preferencesJsonTextView = [[UITextView alloc] init];
    [self.controller resetPreferences:nil];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testAddPreferencesEmptyPreferences
{
    id segmentedControlMock = [OCMockObject mockForClass:[UISegmentedControl class]];
    [self.controller setValue:segmentedControlMock forKey:@"segmentedControl"];
    
    id preferenceTypeFieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceTypeFieldMock forKey:@"preferenceTypeField"];
    
    id preferenceException1FieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException1FieldMock forKey:@"preferenceException1Field"];
    id preferenceException2FieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException2FieldMock forKey:@"preferenceException2Field"];
    id preferenceException3FieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException3FieldMock forKey:@"preferenceException3Field"];
    
    [[[segmentedControlMock stub] andReturnValue:OCMOCK_VALUE(0)] selectedSegmentIndex];
    [[[preferenceTypeFieldMock stub] andReturnValue:OCMOCK_VALUE(@"")] text];
    [[[preferenceException1FieldMock stub] andReturnValue:OCMOCK_VALUE(@"")] text];
    [[[preferenceException2FieldMock stub] andReturnValue:OCMOCK_VALUE(@"")] text];
    [[[preferenceException3FieldMock stub] andReturnValue:OCMOCK_VALUE(@"")] text];
    
    [[preferenceTypeFieldMock expect] setText:@""];
    [[preferenceException1FieldMock expect] setText:@""];
    [[preferenceException2FieldMock expect] setText:@""];
    [[preferenceException3FieldMock expect] setText:@""];
    
    [self.controller addPreferences:nil];
    
    //NSString *expected = @"{\n  \"blacklist\" : {\n\n  },\n  \"whitelist\" : {\n\n  }\n}";
    
    //XCTAssertEqualObjects(expected, self.controller.preferencesJsonTextView.text);
    
    [segmentedControlMock verify];
    [preferenceTypeFieldMock verify];
    [preferenceException1FieldMock verify];
    [preferenceException2FieldMock verify];
    [preferenceException3FieldMock verify];
}

- (void)testAddPreferencesWhitelist
{
    id segmentedControlMock = [OCMockObject mockForClass:[UISegmentedControl class]];
    [self.controller setValue:segmentedControlMock forKey:@"segmentedControl"];
    
    id preferenceTypeFieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceTypeFieldMock forKey:@"preferenceTypeField"];
    
    id preferenceException1FieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException1FieldMock forKey:@"preferenceException1Field"];
    id preferenceException2FieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException2FieldMock forKey:@"preferenceException2Field"];
    id preferenceException3FieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException3FieldMock forKey:@"preferenceException3Field"];
    
    [[[segmentedControlMock stub] andReturnValue:OCMOCK_VALUE(0)] selectedSegmentIndex];
    [[[preferenceTypeFieldMock stub] andReturnValue:OCMOCK_VALUE(@"Test class")] text];
    [[[preferenceException1FieldMock stub] andReturnValue:OCMOCK_VALUE(@"Posts from students")] text];
    [[[preferenceException2FieldMock stub] andReturnValue:OCMOCK_VALUE(@"")] text];
    [[[preferenceException3FieldMock stub] andReturnValue:OCMOCK_VALUE(@"")] text];
    
    [[preferenceTypeFieldMock expect] setText:@""];
    [[preferenceException1FieldMock expect] setText:@""];
    [[preferenceException2FieldMock expect] setText:@""];
    [[preferenceException3FieldMock expect] setText:@""];
    
    //[self.controller addPreferences:nil];
    
    //NSString *expected = @"{\n  \"blacklist\" : {\n\n  },\n  \"whitelist\" : {\n    \"Test class\" : [\n      \"Posts from students\"\n    ]\n  }\n}";
    
    //XCTAssertEqualObjects(expected, self.controller.preferencesJsonTextView.text);
    
    /*[segmentedControlMock verify];
    [preferenceTypeFieldMock verify];
    [preferenceException1FieldMock verify];
    [preferenceException2FieldMock verify];
    [preferenceException3FieldMock verify];*/
}

- (void)testAddPreferencesWhitelistAndBlacklist
{
    id segmentedControlMock = [OCMockObject mockForClass:[UISegmentedControl class]];
    [self.controller setValue:segmentedControlMock forKey:@"segmentedControl"];
    
    id preferenceTypeFieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceTypeFieldMock forKey:@"preferenceTypeField"];
    
    id preferenceException1FieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException1FieldMock forKey:@"preferenceException1Field"];
    id preferenceException2FieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException2FieldMock forKey:@"preferenceException2Field"];
    id preferenceException3FieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException3FieldMock forKey:@"preferenceException3Field"];
    
    [[[segmentedControlMock stub] andReturnValue:OCMOCK_VALUE(0)] selectedSegmentIndex];
    [[[preferenceTypeFieldMock stub] andReturnValue:OCMOCK_VALUE(@"Algebra")] text];
    [[[preferenceException1FieldMock stub] andReturnValue:OCMOCK_VALUE(@"Posts by others")] text];
    [[[preferenceException2FieldMock stub] andReturnValue:OCMOCK_VALUE(@"")] text];
    [[[preferenceException3FieldMock stub] andReturnValue:OCMOCK_VALUE(@"")] text];
    
    [[preferenceTypeFieldMock expect] setText:@""];
    [[preferenceException1FieldMock expect] setText:@""];
    [[preferenceException2FieldMock expect] setText:@""];
    [[preferenceException3FieldMock expect] setText:@""];
    
    //[self.controller addPreferences:nil];
    
    //NSString *expected = @"{\n  \"blacklist\" : {\n\n  },\n  \"whitelist\" : {\n    \"Algebra\" : [\n      \"Posts by others\"\n    ]\n  }\n}";
    
    //XCTAssertEqualObjects(expected, self.controller.preferencesJsonTextView.text);
    
    /*[segmentedControlMock verify];
    [preferenceTypeFieldMock verify];
    [preferenceException1FieldMock verify];
    [preferenceException2FieldMock verify];
    [preferenceException3FieldMock verify]; */
    
    id segmentedControlBlacklistMock = [OCMockObject mockForClass:[UISegmentedControl class]];
    [self.controller setValue:segmentedControlBlacklistMock forKey:@"segmentedControl"];
    
    id preferenceTypeFieldBlacklistMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceTypeFieldBlacklistMock forKey:@"preferenceTypeField"];
    
    id preferenceException1FieldBlacklistMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException1FieldBlacklistMock forKey:@"preferenceException1Field"];
    id preferenceException2FieldBlacklistMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException2FieldBlacklistMock forKey:@"preferenceException2Field"];
    id preferenceException3FieldBlacklistMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException3FieldBlacklistMock forKey:@"preferenceException3Field"];
    
    [[[segmentedControlBlacklistMock stub] andReturnValue:OCMOCK_VALUE(1)] selectedSegmentIndex];
    [[[preferenceTypeFieldBlacklistMock stub] andReturnValue:OCMOCK_VALUE(@"Biology 100")] text];
    [[[preferenceException1FieldBlacklistMock stub] andReturnValue:OCMOCK_VALUE(@"Exception 1")] text];
    [[[preferenceException2FieldBlacklistMock stub] andReturnValue:OCMOCK_VALUE(@"Exception 2")] text];
    [[[preferenceException3FieldBlacklistMock stub] andReturnValue:OCMOCK_VALUE(@"")] text];
    
    [[preferenceTypeFieldBlacklistMock expect] setText:@""];
    [[preferenceException1FieldBlacklistMock expect] setText:@""];
    [[preferenceException2FieldBlacklistMock expect] setText:@""];
    [[preferenceException3FieldBlacklistMock expect] setText:@""];
    
    //[self.controller addPreferences:nil];
    
    //expected = @"{\n  \"blacklist\" : {\n    \"Biology 100\" : [\n      \"Exception 1\",\n      \"Exception 2\"\n    ]\n  },\n  \"whitelist\" : {\n    \"Algebra\" : [\n      \"Posts by others\"\n    ]\n  }\n}";
    
    //XCTAssertEqualObjects(expected, self.controller.preferencesJsonTextView.text);
    
    /*[segmentedControlBlacklistMock verify];
    [preferenceTypeFieldBlacklistMock verify];
    [preferenceException1FieldBlacklistMock verify];
    [preferenceException2FieldBlacklistMock verify];
    [preferenceException3FieldBlacklistMock verify];*/
}

-(void)testSavePreferences
{
    id pearsonPushNotificationsMock = [OCMockObject niceMockForClass:[PearsonPushNotifications class]];
    id appDelegateMock = [OCMockObject niceMockForClass:[AppDelegate class]];
    id whitelistPrefsMock = [OCMockObject niceMockForClass:[NSDictionary class]];
    [self.controller setValue:whitelistPrefsMock forKey:@"whitelist"];
    [[whitelistPrefsMock stub] andReturnValue:OCMOCK_VALUE(@{@"Algebra": @[]})];
    
    id blacklistPrefsMock = [OCMockObject niceMockForClass:[NSDictionary class]];
    [self.controller setValue:whitelistPrefsMock forKey:@"blacklist"];
    [[blacklistPrefsMock stub] andReturnValue:OCMOCK_VALUE(@{@"Dont want": @[]})];
    
    [[[appDelegateMock stub] andReturn:pearsonPushNotificationsMock] pushNotifications];
    [[[appDelegateMock stub] andReturnValue:OCMOCK_VALUE(@"123")] currentAuthToken];
    [[[pearsonPushNotificationsMock expect] andReturn:nil] saveNotificationPreferences:[OCMArg any]
                                                                         withAuthToken:[OCMArg any]];
    
    [self.controller savePreferences:nil];
    
    [whitelistPrefsMock verify];
    [blacklistPrefsMock verify];
    [appDelegateMock verify];
    //[pearsonPushNotificationsMock verify];
}

-(void)testResetPreferences
{
    id segmentedControlMock = [OCMockObject mockForClass:[UISegmentedControl class]];
    [self.controller setValue:segmentedControlMock forKey:@"segmentedControl"];
    
    id preferenceTypeFieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceTypeFieldMock forKey:@"preferenceTypeField"];
    
    id preferenceException1FieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException1FieldMock forKey:@"preferenceException1Field"];
    id preferenceException2FieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException2FieldMock forKey:@"preferenceException2Field"];
    id preferenceException3FieldMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException3FieldMock forKey:@"preferenceException3Field"];
    
    [[[segmentedControlMock stub] andReturnValue:OCMOCK_VALUE(0)] selectedSegmentIndex];
    [[[preferenceTypeFieldMock stub] andReturnValue:OCMOCK_VALUE(@"Algebra")] text];
    [[[preferenceException1FieldMock stub] andReturnValue:OCMOCK_VALUE(@"Posts by others")] text];
    [[[preferenceException2FieldMock stub] andReturnValue:OCMOCK_VALUE(@"")] text];
    [[[preferenceException3FieldMock stub] andReturnValue:OCMOCK_VALUE(@"")] text];
    
    [[preferenceTypeFieldMock expect] setText:@""];
    [[preferenceException1FieldMock expect] setText:@""];
    [[preferenceException2FieldMock expect] setText:@""];
    [[preferenceException3FieldMock expect] setText:@""];
    
    //[self.controller addPreferences:nil];
    
    /*[segmentedControlMock verify];
    [preferenceTypeFieldMock verify];
    [preferenceException1FieldMock verify];
    [preferenceException2FieldMock verify];
    [preferenceException3FieldMock verify];*/
    
    id segmentedControlBlacklistMock = [OCMockObject mockForClass:[UISegmentedControl class]];
    [self.controller setValue:segmentedControlBlacklistMock forKey:@"segmentedControl"];
    
    id preferenceTypeFieldBlacklistMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceTypeFieldBlacklistMock forKey:@"preferenceTypeField"];
    
    id preferenceException1FieldBlacklistMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException1FieldBlacklistMock forKey:@"preferenceException1Field"];
    id preferenceException2FieldBlacklistMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException2FieldBlacklistMock forKey:@"preferenceException2Field"];
    id preferenceException3FieldBlacklistMock = [OCMockObject mockForClass:[UITextField class]];
    [self.controller setValue:preferenceException3FieldBlacklistMock forKey:@"preferenceException3Field"];
    
    [[[segmentedControlBlacklistMock stub] andReturnValue:OCMOCK_VALUE(1)] selectedSegmentIndex];
    [[[preferenceTypeFieldBlacklistMock stub] andReturnValue:OCMOCK_VALUE(@"Biology 100")] text];
    [[[preferenceException1FieldBlacklistMock stub] andReturnValue:OCMOCK_VALUE(@"Exception 1")] text];
    [[[preferenceException2FieldBlacklistMock stub] andReturnValue:OCMOCK_VALUE(@"Exception 2")] text];
    [[[preferenceException3FieldBlacklistMock stub] andReturnValue:OCMOCK_VALUE(@"")] text];
    
    [[preferenceTypeFieldBlacklistMock expect] setText:@""];
    [[preferenceException1FieldBlacklistMock expect] setText:@""];
    [[preferenceException2FieldBlacklistMock expect] setText:@""];
    [[preferenceException3FieldBlacklistMock expect] setText:@""];
    
    //[self.controller addPreferences:nil];
    
    [[preferenceTypeFieldBlacklistMock expect] setText:@""];
    [[preferenceException1FieldBlacklistMock expect] setText:@""];
    [[preferenceException2FieldBlacklistMock expect] setText:@""];
    [[preferenceException3FieldBlacklistMock expect] setText:@""];
    
    [self.controller resetPreferences:nil];
    
    //XCTAssertEqualObjects(@"", self.controller.preferencesJsonTextView.text);
    
    [segmentedControlBlacklistMock verify];
    //[preferenceTypeFieldBlacklistMock verify];
    //[preferenceException1FieldBlacklistMock verify];
    //[preferenceException2FieldBlacklistMock verify];
    //[preferenceException3FieldBlacklistMock verify];
}

@end
