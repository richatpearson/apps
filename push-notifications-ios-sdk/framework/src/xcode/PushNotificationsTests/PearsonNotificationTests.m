//
//  PearsonNotificationTests.m
//  PushNotifications
//
//  Created by Tomack, Barry on 4/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PearsonNotification.h"

@interface PearsonNotificationTests : XCTestCase


@end

@implementation PearsonNotificationTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithBasicAPSNotifcation
{
    NSDictionary* basic = @{
                                @"aps" : @{
                                            @"alert" : @"New assignments have been posted to OpenClass",
                                            @"badge" : @"5",
                                            @"sound" : @"default"
                                }
                            };
    
    PearsonNotification* notification = [[PearsonNotification alloc] initWithDictionary:basic forUserID:@"123456"];
    
    XCTAssertTrue(notification, @"PearsonNotification not intializing properly with basic aps notification");
}

- (void)testInitWithCustomAPSNotifcation
{
    NSDictionary* custom = @{
                                @"aps" : @{
                                        @"alert" : @"New assignments have been posted to OpenClass",
                                        @"badge" : @"5",
                                        @"sound" : @"bong.aiff"
                                        },
                                @"courseName" : @"Art History 101",
                                @"instructor" : @"Marilyn Stokstadl"
                            };
    
    PearsonNotification* notification = [[PearsonNotification alloc] initWithDictionary:custom forUserID:@"123456"];
    
    XCTAssertTrue(notification, @"PearsonNotification not intializing properly with custom aps notification");
}

@end
