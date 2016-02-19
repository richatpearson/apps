//
//  PearsonPushNotificationsTests.m
//  PushNotifications
//
//  Created by Tomack, Barry on 3/18/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PearsonAppServicesiOSSDK/PearsonMonitoringOptions.h>
#import "PearsonPushNotifications.h"

@interface PearsonPushNotificationsTests : XCTestCase

@property (nonatomic, strong) NSString* orgID;
@property (nonatomic, strong) NSString* appID;
@property (nonatomic, strong) NSString* notificationBaseURL;
@property (nonatomic, strong) NSString* pushApiKey;

@property (nonatomic, weak) NSString* clientId;
@property (nonatomic, weak) NSString* authorizationValue;

@property (nonatomic, strong) PearsonMonitoringOptions* monitoringOptions;

@property (strong, nonatomic) PearsonPushNotifications* pushNotifications;

@end

@implementation PearsonPushNotificationsTests

- (void)setUp
{
    [super setUp];
    self.orgID = @"pearsonlt";
    self.appID = @"sandbox";
    self.pushApiKey = @"GgXYn6HjbT2CzKXm5jh9aIGC7htBNWk1";
    self.notificationBaseURL = @"https://ecollege-test.apigee.net/mobile/appservices/";
    self.clientId = @"SQ9SBg1af8Lboj9AbWDAM4gFy7fnZNB4";
    self.authorizationValue = @"U1E5U0JnMWFmOExib2o5QWJXREFNNGdGeTdmblpOQjQ6SlBJTkVJS1ZlbkFoVHJodg==";
    
    self.monitoringOptions = [[PearsonMonitoringOptions alloc] init];
    self.monitoringOptions.monitoringEnabled = NO;
    
    self.pushNotifications = [[PearsonPushNotifications alloc] initWithOrganization:self.orgID
                                                                        application:self.appID
                                                                             apiKey:self.pushApiKey
                                                                  monitoringOptions:self.monitoringOptions
                                                                            baseURL:self.notificationBaseURL];
}

- (void)tearDown
{
    self.orgID = nil;
    self.appID = nil;
    self.pushApiKey = nil;
    self.notificationBaseURL = nil;
    self.clientId = nil;
    self.authorizationValue = nil;
    
    self.pushNotifications = nil;
    [super tearDown];
}

- (void)testInit
{
    XCTAssertNotNil(self.pushNotifications, @"PushNotifications has not been initialized properly");
}

@end
