//
//  JsonViewTests.m
//  SeerClientApp
//
//  Created by Richard Rosiak on 1/15/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSONViewController.h"

@interface JsonViewTests : XCTestCase

@property (strong, nonatomic) JSONViewController *jsonVC;

@end

@implementation JsonViewTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.jsonVC = [[JSONViewController alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testJsonDictionaryToString
{
    XCTAssert(true, @"Must be true");
    
    NSDictionary *json = @{
                           @"actor" : @{
                                   @"id" : @"AlbertEinstein"
                                   },
                           @"verb": @"post"};
    
    NSString *convertedFromJson = [self.jsonVC jsonDictionaryToString:json];
    NSLog(@"No white space: %@", convertedFromJson);
    
    NSString *jsonString = @"{\n  \"actor\" : {\n    \"id\" : \"AlbertEinstein\"\n  },\n  \"verb\" : \"post\"\n}";
    NSLog(@"My JSON string is %@", jsonString);
    
    XCTAssert([convertedFromJson isKindOfClass:[NSString class]], @"Converted activity string json should be a string");
    XCTAssertEqualObjects(jsonString, convertedFromJson);
}

@end
