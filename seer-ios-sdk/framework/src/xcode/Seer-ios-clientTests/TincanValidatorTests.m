//
//  TincanValidatorTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/18/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "tincanValidator.h"
#import "SeerUtility.h"
#import "ValidationResult.h"

@interface TincanValidatorTests : XCTestCase

@property (nonatomic,strong) TincanValidator* tincanValidator;
@property (nonatomic,strong) NSString* tcTimestamp;

@end

@implementation TincanValidatorTests

- (void)setUp
{
    [super setUp];
    self.tincanValidator = [TincanValidator new];
}

- (void)tearDown
{
    self.tincanValidator = nil;
    [super tearDown];
}

- (void)testtincanValidatorInit
{
    XCTAssertNotNil(self.tincanValidator, @"tincanValidator has not been initialized with dictionary");
}

- (void) testValidTincan
{
    ValidationResult* validationResult = [self.tincanValidator validTincan:[self validTincanDictionary]];
    XCTAssertTrue(validationResult.valid, @"tincanValidator not validating properly");
}

- (void) testInvalidActor
{
    NSDictionary* actor = @{
                            @"name" : @"Sally Glider",
                            @"objectType" : @"Agent"
                           };
    
    NSMutableDictionary* tincan = [NSMutableDictionary dictionaryWithDictionary:[self validTincanDictionary]];
    
    [tincan setObject:actor forKey:@"actor"];
    NSLog(@"Test Invalid Actor: %@",tincan);
    ValidationResult* validationResult = [self.tincanValidator validTincan:tincan];
    XCTAssertFalse(validationResult.valid, @"TincanValidator not validating actor properly");
}

- (void) testInvalidVerb
{
    NSDictionary* verb = @{
                            @"display" : @{
                                    @"en-US" : @"Interacted"
                                    }
                            };
    
    NSMutableDictionary* tincan = [NSMutableDictionary dictionaryWithDictionary:[self validTincanDictionary]];
    
    [tincan setObject:verb forKey:@"verb"];
    
    ValidationResult* validationResult = [self.tincanValidator validTincan:tincan];
    XCTAssertFalse(validationResult.valid, @"TincanValidator not validating verb properly");
}

- (void) testInvalidObject
{
    NSDictionary* object = @{
                             @"objectType" : @"Activity",
                             @"definition" : @{
                                     @"name" : @{
                                             @"en-US" : @"Grub Club"
                                             },
                                     @"type" : @"http://pearson.com/ccsoc/interactivetype/"
                                     }
                             };
    
    NSMutableDictionary* tincan = [NSMutableDictionary dictionaryWithDictionary:[self validTincanDictionary]];
    
    [tincan setObject:object forKey:@"object"];
    
    ValidationResult* validationResult = [self.tincanValidator validTincan:tincan];
    
    XCTAssertFalse(validationResult.valid, @"TincanValidator not validating object id properly");
    
    object = @{
               @"objectType" : @"Activity",
               @"id" : @"http://pearson.com/ccsoc/interactive/"
               };
    
    [tincan setObject:object forKey:@"object"];
    
    validationResult = [self.tincanValidator validTincan:tincan];
    XCTAssertFalse(validationResult.valid, @"TincanValidator not validating object-definition properly");
    
    object = @{
               @"objectType" : @"Activity",
               @"id" : @"http://pearson.com/ccsoc/interactive/",
               @"definition" : @{
                       @"name" : @{
                               @"en-US" : @"Grub Club"
                               }
                       }
               };
    
    [tincan setObject:object forKey:@"object"];
    
    validationResult = [self.tincanValidator validTincan:tincan];
    XCTAssertFalse(validationResult.valid, @"TincanValidator not validating object-definition-type properly");
}

- (void) testInvalidContext
{
    NSDictionary* context = @{
                              @"revision" : @"1",
                              @"platform" : @"iOS",
                              @"language" : @"en-US"
                              };
    NSMutableDictionary* tincan = [NSMutableDictionary dictionaryWithDictionary:[self validTincanDictionary]];
    
    [tincan setObject:context forKey:@"context"];
    
    ValidationResult* validationResult = [self.tincanValidator validTincan:tincan];
    
    XCTAssertFalse(validationResult.valid, @"TincanValidator not validating context-extensions properly");
    
    context = @{
                @"revision" : @"1",
                @"platform" : @"iOS",
                @"language" : @"en-US",
                @"extensions" : @{
                        @"district" : @"District 9",
                        @"environment" : @"desert"
                        }
               };
    
    [tincan setObject:context forKey:@"context"];
    
    validationResult = [self.tincanValidator validTincan:tincan];
    
    XCTAssertFalse(validationResult.valid, @"TincanValidator not validating context-extensions-appId properly");
}

- (NSDictionary*) validTincanDictionary
{
    self.tcTimestamp = [SeerUtility iso8601StringFromDate:[NSDate date]];
    
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
                                    @"timestamp" : self.tcTimestamp
                                };
    
    return validTincan;
}

@end
