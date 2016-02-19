//
//  AppDelegateTests.m
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/21/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"

@interface AppDelegateTests : XCTestCase

@end

@implementation AppDelegateTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testClearSession
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    appDelegate.sessionHistory = [self getMockSessionHistory];
    
    XCTAssertEqualObjects(@(5), @([appDelegate.sessionHistory count]), @"Can't set a mock mutable array for app deleate session history");
    
    [appDelegate clearSession];
    
    XCTAssertEqualObjects(@(0), @([appDelegate.sessionHistory count]), @"AppDelegate can't clear session history");
}

- (NSMutableArray*) getMockSessionHistory
{
    NSMutableArray* mockSessionHistory = [NSMutableArray new];
    
    while ([mockSessionHistory count] < 5)
    {
        SessionRequest* sessionRequest = [SessionRequest new];
        sessionRequest.jsonDict = [NSDictionary new];
        sessionRequest.requestType = @"requestType";
        sessionRequest.status = kRequestStatusPending;
        sessionRequest.requestId = @([mockSessionHistory count] + 1);
        
        [mockSessionHistory addObject:sessionRequest];
    }
    
    return mockSessionHistory;
}

@end
