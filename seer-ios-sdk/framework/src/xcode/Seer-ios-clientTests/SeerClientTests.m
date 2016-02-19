//
//  SeerClientTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 1/3/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SeerClient.h"
#import "SeerUtility.h"
#import "ValidationResult.h"

@interface SeerClientTests : XCTestCase

@property (nonatomic, strong) SeerClient* seerClient;
@property (nonatomic, strong) NSString* clientId;
@property (nonatomic, strong) NSString* clientSecret;
@property (nonatomic, strong) NSString* apiKey;

@end

@implementation SeerClientTests

- (void)setUp
{
    [super setUp];
    
    self.clientId = @"mp_seer_client";
    self.clientSecret = @"iSNla38gEUFg";
    self.apiKey = @"wlHH1fWUxaAwqAX42o9dwV9qyRHij5Ik";
    
    self.seerClient = [[SeerClient alloc] initWithClientId:self.clientId
                                              clientSecret:self.clientSecret
                                                    apiKey:self.apiKey];
}

- (void)tearDown
{
    self.clientId = nil;
    self.clientSecret = nil;
    self.apiKey = nil;
    
    self.seerClient = nil;
    
    [super tearDown];
}

- (void)testSeerClientInit
{
    XCTAssertNotNil(self.seerClient, @"SeerClient has not been initialized properly");
}

- (void)testEndpoints
{
    NSDictionary* endpoints1 = [self.seerClient getEndpoints];
    NSUInteger count1 = [endpoints1 count];
    
    [self.seerClient addEndpoint:@"/testEndpoint" forName:@"TestEndpoint"];
    
    NSDictionary* endpoints2 = [self.seerClient getEndpoints];
    NSUInteger count2 = [endpoints2 count];
    
    XCTAssertEqual(count1 + 1, count2, @"SeerClient not adding/retrieving endpoints properly");
}

- (void) testValidActivityStream
{
    ActivityStream* activityStream = [ActivityStream new];
    [activityStream setDictionary:[self validActivityStreamDictionary]];
    
    ValidationResult* validationResult = [self.seerClient validActivityStream:activityStream];
    
    XCTAssertTrue(validationResult.valid, @"SeerClient not validating ActivityStreamproperly");
}

- (void) testInvalidActivityStream
{
    ActivityStream* activityStream = [ActivityStream new];
    
    NSMutableDictionary* mutableDict = [NSMutableDictionary dictionaryWithDictionary:[self validActivityStreamDictionary]];
    [mutableDict removeObjectForKey:@"verb"];
    
    [activityStream setDictionary:mutableDict];
    
    ValidationResult* validationResult = [self.seerClient validActivityStream:activityStream];
    
    XCTAssertFalse(validationResult.valid, @"SeerClient not validating ActivityStream properly");
}

- (void) testValidTincan
{
    Tincan* tincan = [Tincan new];
    [tincan setDictionary:[self validTincanDictionary]];
    
    ValidationResult* validationResult = [self.seerClient validTincan:tincan];
    
    XCTAssertTrue(validationResult.valid, @"SeerClient not validating Tincan properly");
}

- (void) testInvalidTincan
{
    Tincan* tincan = [Tincan new];
    
    NSMutableDictionary* mutableDict = [NSMutableDictionary dictionaryWithDictionary:[self validTincanDictionary]];
    [mutableDict removeObjectForKey:@"verb"];
    
    [tincan setDictionary:mutableDict];
    
    ValidationResult* validationResult = [self.seerClient validTincan:tincan];
    
    XCTAssertFalse(validationResult.valid, @"SeerClient not validating Tincan properly");
}

- (NSDictionary*) validActivityStreamDictionary
{
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
                                          @"published" : [SeerUtility iso8601StringFromDate:[NSDate date]]
                                          };
    
    return validActivityStream;
}

- (NSDictionary*) validTincanDictionary
{
    NSDictionary* validTincan = @{
                                  @"id" : [SeerUtility uniqueId],
                                  @"actor" : @{
                                          @"name" : @"Sally Glider",
                                          @"mbox" : @"mailto:sally@example.com",
                                          @"account" : @{
                                                  @"homePage" : @"http://www.pearson.com",
                                                  @"name" : @"Busby Berkley"
                                                  }
                                          },
                                  @"verb": @{
                                          @"id":@"http://adlnet.gov/expapi/verbs/interacted",
                                          @"display" : @{
                                                  @"en-US" : @"Interacted"
                                                  }
                                          },
                                  @"object" : @{
                                          @"objectType" : @"Activity",
                                          @"id" : @"http://pearson.com/ccsoc/interactive/",
                                          @"definition" : @{
                                                  @"name" : @{
                                                          @"en-US" : @"Grub Club"
                                                          },
                                                  @"type" : @"http://pearson.com/ccsoc/interactivetype/"
                                                  }
                                          },
                                  @"result" : @{
                                          @"duration" : @"PT10S",
                                          @"completion" : @1,
                                          @"success" : @1,
                                          @"score" : @{
                                                  @"scaled" : @0.95
                                                  }
                                          },
                                  @"context" : @{
                                          @"revision" : @"1",
                                          @"platform" : @"iOS",
                                          @"language" : @"en-US",
                                          @"extensions" : @{
                                                  @"appId" : @"SEER-ios-sdk",
                                                  @"district" : @"District 9",
                                                  @"environment" : @"desert"
                                                  }
                                          },
                                  @"timestamp" : [SeerUtility iso8601StringFromDate:[NSDate date]]
                                  };
    
    return validTincan;
}

@end
