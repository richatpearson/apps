//
//  ActivityStreamValidatorTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SeerUtility.h"
#import "ActivityStreamValidator.h"
#import "ValidationResult.h"

@interface ActivityStreamValidatorTests : XCTestCase

@property (nonatomic,strong) ActivityStreamValidator* activityStreamValidator;
@property (nonatomic,strong) NSString* asPublished;

@end

@implementation ActivityStreamValidatorTests

- (void)setUp
{
    [super setUp];
    self.activityStreamValidator = [ActivityStreamValidator new];
}

- (void)tearDown
{
    self.activityStreamValidator = nil;
    [super tearDown];
}

- (void)testActivityStreamValidatorInit
{
    XCTAssertNotNil(self.activityStreamValidator, @"ActivityStreamValidator has not been initialized");
}

- (void) testValidActivityStream
{
    ValidationResult* validationResult = [self.activityStreamValidator validActivityStream:[self validActivityStreamDictionary]];
    XCTAssertTrue(validationResult.valid, @"ActivityStreamValidator not validating properly");
}

- (void) testInvalidActor
{
    NSDictionary* actor = @{
                            @"objectType" : @"person",
                            @"displayName": @"Martin Smith",
                            @"url": @"http://example.org/martin"
                            };
    
    NSMutableDictionary* activityStream = [NSMutableDictionary dictionaryWithDictionary:[self validActivityStreamDictionary]];
    
    [activityStream setObject:actor forKey:@"actor"];

    ValidationResult* validationResult = [self.activityStreamValidator validActivityStream:activityStream];
    XCTAssertFalse(validationResult.valid, @"ActivityStreamValidator not validating actor-id properly");
    
    actor = @{
             @"id" : @"",
             @"objectType" : @"person",
             @"displayName": @"Martin Smith",
             @"url": @"http://example.org/martin"
             };
    
    [activityStream setObject:actor forKey:@"actor"];
    
    validationResult = [self.activityStreamValidator validActivityStream:activityStream];
    XCTAssertFalse(validationResult.valid, @"ActivityStreamValidator not validating actor-id empty string properly");
}

- (void) testInvalidVerb
{
    NSMutableDictionary* activityStream = [NSMutableDictionary dictionaryWithDictionary:[self validActivityStreamDictionary]];
    
    [activityStream removeObjectForKey:@"verb"];
    
    ValidationResult* validationResult = [self.activityStreamValidator validActivityStream:activityStream];
    
    XCTAssertFalse(validationResult.valid, @"ActivityStreamValidator not validating verb properly");
    
    NSDictionary* verb1 = @{
                           @"verb" : @""
                           };
    [activityStream setObject:verb1 forKey:@"verb"];
    
    validationResult = [self.activityStreamValidator validActivityStream:activityStream];
    XCTAssertFalse(validationResult.valid, @"ActivityStreamValidator not validating verb properly");
    
    NSDictionary* verb2 = @{
                          @"verb" : @"post"
                          };
    [activityStream setObject:verb2 forKey:@"verb"];
    
    validationResult = [self.activityStreamValidator validActivityStream:activityStream];
    XCTAssertFalse(validationResult.valid, @"ActivityStreamValidator not validating verb properly");
}

- (void) testInvalidGenerator
{
    NSDictionary* generator = @{
                                @"serviceProviderCountry" : @"US",
                                @"languagePreference" : @"English",
                                @"appName" : @"PearsonCore",
                                @"networkType" : @"Wifi"
                                };
    
    NSMutableDictionary* activityStream = [NSMutableDictionary dictionaryWithDictionary:[self validActivityStreamDictionary]];
    
    [activityStream setObject:generator forKey:@"generator"];
    ValidationResult* validationResult = [self.activityStreamValidator validActivityStream:activityStream];
    XCTAssertFalse(validationResult.valid, @"ActivityStreamValidator not validating generator properly");
}

- (void) testInvalidObject
{
    NSDictionary* object = @{
                             @"id" : @"tag:example.org,2011:my_fluffy_cat",
                             @"url": @"http://example.org/album/my_fluffy_cat.jpg"
                            };
    
    NSMutableDictionary* activityStream = [NSMutableDictionary dictionaryWithDictionary:[self validActivityStreamDictionary]];
    
    [activityStream setObject:object forKey:@"object"];
    
    ValidationResult* validationResult = [self.activityStreamValidator validActivityStream:activityStream];
    XCTAssertFalse(validationResult.valid, @"ActivityStreamValidator not validating object properly");
    
    object = @{
             @"objectType" : @"photo",
             @"url": @"http://example.org/album/my_fluffy_cat.jpg"
             };
    
    [activityStream setObject:object forKey:@"object"];
    validationResult = [self.activityStreamValidator validActivityStream:activityStream];
    XCTAssertFalse(validationResult.valid, @"ActivityStreamValidator not validating object properly");
}

- (void) testInvalidContext
{
    NSMutableDictionary* activityStream = [NSMutableDictionary dictionaryWithDictionary:[self validActivityStreamDictionary]];
    
    [activityStream removeObjectForKey:@"context"];
    
    ValidationResult* validationResult = [self.activityStreamValidator validActivityStream:activityStream];
    XCTAssertTrue(validationResult.valid, @"ActivityStreamValidator not validating context properly");
    
    NSString* context = @"context";
    
    [activityStream setObject:context forKey:@"context"];
    validationResult = [self.activityStreamValidator validActivityStream:activityStream];
    XCTAssertFalse(validationResult.valid, @"ActivityStreamValidator not validating context properly");
}

- (NSDictionary*) validActivityStreamDictionary
{
    self.asPublished = [SeerUtility iso8601StringFromDate:[NSDate date]];
    
    NSDictionary* validActivityStream = @{
                                         @"actor" : @{
                                                 @"id" : @"tag:example.org,2011:martin",
                                                 @"objectType" : @"person",
                                                 @"displayName": @"Martin Smith",
                                                 @"url": @"http://example.org/martin"
                                                 },
                                         @"verb": @"post",
                                         @"object": @{
                                                 @"id" : @"tag:example.org,2011:my_fluffy_cat",
                                                 @"objectType" : @"photo",
                                                 @"url": @"http://example.org/album/my_fluffy_cat.jpg"
                                                 },
                                         @"target" : @{
                                                 @"id": @"tag:example.org,2011:abc123",
                                                 @"objectType": @"photo-album",
                                                 @"displayName": @"Martin's Photo Album",
                                                 @"url": @"http://example.org/album/"
                                                 },
                                         @"generator" : @{
                                                 @"appId" : @"SEER-ios-sdk",
                                                 @"deviceAbstraction" : @{
                                                         @"serviceProviderCountry" : @"US",
                                                         @"languagePreference" : @"English",
                                                         @"appName" : @"PearsonCore",
                                                         @"networkType" : @"Wifi",
                                                         @"enabledAccessibilityServices" : @[
                                                                                   @"ClosedCaptioningEnabled"
                                                                                   ],
                                                         @"deviceOSName" : @"iPhone OS",
                                                         @"appVendorID" : @"A5A3B91C-D94A-4C5D-AF7F-FEC3E6A6A64A",
                                                         @"appVersion" : @"1.0",
                                                         @"deviceVendor" : @"Apple",
                                                         @"appBuild" : @"1.0",
                                                         @"deviceOSVersion" : @"7.0.3",
                                                         @"localeSetting" : @"US",
                                                         @"uuid" : @"A7B84670-3581-45BF-BA15-52D48A3AC787",
                                                         @"serviceProvider" : @"none",
                                                         @"deviceModel" : @"iPhone Simulator",
                                                         @"deviceResolution" : @"640x960"
                                                         }
                                                 },
                                         @"context" : @{
                                                 @"key1" : @"String1",
                                                 @"key2" : @"String2"
                                                 },
                                         @"published" : self.asPublished
                                         };
    NSLog(@"%@", validActivityStream);
    return validActivityStream;
}

@end
