//
//  ActivityStreamViewTests.m
//  SeerClientApp
//
//  Created by Richard Rosiak on 1/15/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ActivityStreamViewController.h"

@interface ActivityStreamViewTests : XCTestCase

@property (strong, nonatomic) ActivityStreamViewController *activityStreamVC;

@end

@implementation ActivityStreamViewTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.activityStreamVC = [[ActivityStreamViewController alloc]init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testCreateActityStreamJSON
{
    NSString *verb = @"post";
    NSString *actorName = @"Bill";
    NSString *object = @"Butterfly";
    NSString *target = @"MyTarget1";
    
    NSString *tagPrefix = @"tag:pearson.com,2014:";
    
    NSDictionary *result = [self.activityStreamVC createActivityStreamJsonWithActorName:actorName
                                                                                   verb:verb
                                                                                 object:object
                                                                                 target:target];
    
    XCTAssertNotNil(result, @"Json should not be nil");
    
    XCTAssertEqual(verb, [result objectForKey:@"verb"]);
    
    XCTAssertEqualObjects(actorName,[[result objectForKey:@"actor"] objectForKey:@"id"]);
    
    NSString *objectInJson = [NSString stringWithFormat: @"%@%@",tagPrefix,object];
    XCTAssertEqualObjects(objectInJson,[[result objectForKey:@"object"] objectForKey:@"id"]);
    XCTAssertEqualObjects(object,[[result objectForKey:@"object"] objectForKey:@"objectType"]);
    
    NSString *targetInJson = [NSString stringWithFormat: @"%@%@",tagPrefix,target];
    XCTAssertEqualObjects(targetInJson,[[result objectForKey:@"target"] objectForKey:@"id"]);
}

@end
