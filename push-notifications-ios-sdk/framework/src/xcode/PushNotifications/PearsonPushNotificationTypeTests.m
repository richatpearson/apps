//
//  PearsonPushNotificationTypeTests.m
//  PushNotifications
//
//  Created by Tomack, Barry on 4/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PearsonPushNotificationType.h"

@interface PearsonPushNotificationTypeTests : XCTestCase

@end

@implementation PearsonPushNotificationTypeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testBadgeOnlyType
{
    UIRemoteNotificationType nType = [PearsonPushNotificationType getTypeWithBadge:YES Sound:NO Alert:NO Newsstand:NO];
    
    XCTAssertEqual(nType, 1, @"PearsonPushNotificationType not returning the right type for Badge only");
}

- (void)testSoundOnlyType
{
    UIRemoteNotificationType nType = [PearsonPushNotificationType getTypeWithBadge:NO Sound:YES Alert:NO Newsstand:NO];
    
    XCTAssertEqual(nType, 2, @"PearsonPushNotificationType not returning the right type for Sound only");
}

- (void)testBadgeSoundType
{
    UIRemoteNotificationType nType = [PearsonPushNotificationType getTypeWithBadge:YES Sound:YES Alert:NO Newsstand:NO];
    
    XCTAssertEqual(nType, 3, @"PearsonPushNotificationType not returning the right type for Badge And Sound");
}

- (void)testAlertOnlyType
{
    UIRemoteNotificationType nType = [PearsonPushNotificationType getTypeWithBadge:NO Sound:NO Alert:YES Newsstand:NO];
    
    XCTAssertEqual(nType, 4, @"PearsonPushNotificationType not returning the right type for Alert only");
}

- (void)testBadgeAlertType
{
    UIRemoteNotificationType nType = [PearsonPushNotificationType getTypeWithBadge:YES Sound:NO Alert:YES Newsstand:NO];
    
    XCTAssertEqual(nType, 5, @"PearsonPushNotificationType not returning the right type for Alert and Badge");
}

- (void)testSoundAlertType
{
    UIRemoteNotificationType nType = [PearsonPushNotificationType getTypeWithBadge:NO Sound:YES Alert:YES Newsstand:NO];
    
    XCTAssertEqual(nType, 6, @"PearsonPushNotificationType not returning the right type for Alert and sound");
}

- (void)testBadgeSoundAlertType
{
    UIRemoteNotificationType nType = [PearsonPushNotificationType getTypeWithBadge:YES Sound:YES Alert:YES Newsstand:NO];
    
    XCTAssertEqual(nType, 7, @"PearsonPushNotificationType not returning the right type for Alert and sound");
}

@end
