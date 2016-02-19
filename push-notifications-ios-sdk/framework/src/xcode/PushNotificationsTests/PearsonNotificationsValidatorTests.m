//
//  PearsonNotificationsValidatorTests.m
//  PushNotifications
//
//  Created by Tomack, Barry on 4/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PearsonNotificationsValidator.h"

@interface PearsonNotificationsValidatorTests : XCTestCase

@property (nonatomic, strong) PearsonNotificationsValidator* validator;

@end

@implementation PearsonNotificationsValidatorTests

- (void)setUp
{
    [super setUp];
    self.validator = [PearsonNotificationsValidator new];
}

- (void)tearDown
{
    self.validator = nil;
    [super tearDown];
}

- (void)testValidGroupName
{
    NSString* groupName = @"Pearson-Group-123";
    
    XCTAssertTrue([self.validator validGroupName:groupName], @"PearsonNotificationsValidator not validating a valid group name");
}

- (void)testInvalidCharacterName
{
    NSString* groupName1 = @"Pearson_Group";
    NSString* groupName2 = @"Pearson/Group";
    NSString* groupName3 = @"Pearson@Group";
    
    XCTAssertFalse([self.validator validGroupName:groupName1], @"PearsonNotificationsValidator not invalidating aan invalid group name");
    XCTAssertFalse([self.validator validGroupName:groupName2], @"PearsonNotificationsValidator not invalidating aan invalid group name");
    XCTAssertFalse([self.validator validGroupName:groupName3], @"PearsonNotificationsValidator not invalidating aan invalid group name");
}

- (void)testInvalidLengthName
{
    NSString* groupName1 = @"";
    NSString* groupName2 = @"1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789";
    
    XCTAssertFalse([self.validator validGroupName:groupName1], @"PearsonNotificationsValidator not invalidating aan invalid group name");
    XCTAssertFalse([self.validator validGroupName:groupName2], @"PearsonNotificationsValidator not invalidating aan invalid group name");
}

@end
