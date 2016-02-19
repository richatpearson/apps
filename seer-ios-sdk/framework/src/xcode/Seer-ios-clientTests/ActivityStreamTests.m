//
//  ActivityStreamTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/18/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ActivityStream.h"
#import "ActivityStreamActor.h"
#import "ActivityStreamGenerator.h"
#import "ActivityStreamObject.h"
#import "ActivityStreamTarget.h"
#import "ActivityStreamValidator.h"
#import "SeerUtility.h"

@interface ActivityStreamTests : XCTestCase

@property (nonatomic, strong) ActivityStream* activityStream;
@property (nonatomic, strong) ActivityStreamValidator* activityStreamValidator;
@property (nonatomic, strong) NSString* testVerb;
@property (nonatomic, strong) NSString* testPublished;

@end

@implementation ActivityStreamTests

- (void)setUp
{
    [super setUp];
    self.activityStream = [ActivityStream new];
    self.activityStreamValidator = [ActivityStreamValidator new];
    self.testVerb = @"loggedIn";
    self.testPublished = [SeerUtility iso8601StringFromDate:[NSDate date]];
}

- (void)tearDown
{
    self.activityStream = nil;
    self.activityStreamValidator = nil;
    [super tearDown];
}

- (void)testActivityStreamInit
{
    XCTAssertNotNil(self.activityStream, @"ActivityStream has not been initialized properly");
}

- (void)testValidActivityStream
{
    self.activityStream = [self buildValidActivityStream];
    
    XCTAssertTrue([self.activityStreamValidator validActivityStream:[self.activityStream asDictionary]], @"ActivityStream not validated");
}

- (void)testActivityStreamCount
{
    self.activityStream = [self buildValidActivityStream];
    NSUInteger countShouldBe = 6;
    XCTAssertEqual([[self.activityStream asDictionary] count], countShouldBe, @"ActivityStream not building properly");
}

- (void) testSetVerb
{
    self.activityStream = [self buildValidActivityStream];
    XCTAssertEqualObjects(self.testVerb, self.activityStream.verb , @"ActivityStream not setting verb properly");
}

- (void) testSetPublished
{
    self.activityStream = [self buildValidActivityStream];
    XCTAssertEqualObjects(self.testPublished, self.activityStream.published, @"ActivityStream not setting published properly");
}

- (void) testSetActor
{
    ActivityStream* aStream = [ActivityStream new];
    
    ActivityStreamActor* actor = [ActivityStreamActor new];
    NSString* actorId = @"steven.colbert@pearson.com";
    [actor setId:actorId];
    
    [aStream setActor:actor];
    
    XCTAssertEqualObjects([actor asDictionary], [[aStream actor] asDictionary], @"ActivityStream not setting actor properly");
}

- (void) testSetGenerator
{
    ActivityStream* aStream = [ActivityStream new];
    
    ActivityStreamGenerator* generator = [ActivityStreamGenerator new];
    NSString* appId = @"Seer iOS SDK";
    [generator setAppId:appId];
    
    [aStream setGenerator:generator];
    
    XCTAssertEqualObjects([generator asDictionary], [[aStream generator] asDictionary], @"ActivityStream not setting generator properly");
}

- (void) testSetObject
{
    ActivityStream* aStream = [ActivityStream new];
    
    ActivityStreamObject* object = [ActivityStreamObject new];
    NSString* objectId = @"123456789";
    [object setId:objectId];
    NSString* objectType = @"objType";
    [object setId:objectType];
    
    [aStream setObject:object];
    
    XCTAssertEqualObjects([object asDictionary], [[aStream object] asDictionary], @"ActivityStream not setting object properly");
}

- (void) testSetTarget
{
    ActivityStream* aStream = [ActivityStream new];
    
    ActivityStreamTarget* target = [ActivityStreamTarget new];
    NSString* targetId = @"987654321";
    [target setId:targetId];
    
    [aStream setTarget:target];
    
    XCTAssertEqualObjects([target asDictionary], [[aStream target] asDictionary], @"ActivityStream not setting target properly");
}

- (void) testSetContext
{
    ActivityStream* aStream = [ActivityStream new];
    
    NSDictionary* context = @{@"key1": @"val1", @"key2":@"val2"};
    
    [aStream setContext:context];
    
    XCTAssertEqualObjects(context, [aStream context], @"ActivityStream not setting context properly");
}

- (void) testActorWithId
{
    NSString* actorId = @"john.stewart@pearson.com";
    ActivityStream* aStream = [ActivityStream new];
    [aStream setActorWithId:actorId];
    
    NSDictionary* actor = [[aStream actor] asDictionary];
    XCTAssertEqualObjects(actorId, [actor objectForKey:@"id"], @"ActivityStream not setting Actor with ID properly");
}

- (void) testGeneratorWithAppId
{
    NSString* appId = @"Seer-ios-sdk";
    ActivityStream* aStream = [ActivityStream new];
    [aStream setGeneratorWithAppId:appId];
    
    NSDictionary* generator = [[aStream generator] asDictionary];
    XCTAssertEqualObjects(appId, [generator objectForKey:@"appId"], @"ActivityStream not setting Genrator with appId properly");
}

- (void) testObjectWithIdAndType
{
    NSString* objectId = @"123456789";
    NSString* objectType = @"Button";
    ActivityStream* aStream = [ActivityStream new];
    [aStream setObjectWithId:objectId objectType:objectType];
    
    NSDictionary* object = [[aStream object] asDictionary];
    XCTAssertEqualObjects(objectId, [object objectForKey:@"id"], @"ActivityStream not setting Obejct with ID and Type properly");
    XCTAssertEqualObjects(objectType, [object objectForKey:@"objectType"], @"ActivityStream not setting Obejct with ID and Type properly");
}

- (void) testTargetWithId
{
    NSString* targetId = @"9876543210";
    ActivityStream* aStream = [ActivityStream new];
    [aStream setTargetWithId:targetId];
    
    NSDictionary* target = [[aStream target] asDictionary];
    XCTAssertEqualObjects(targetId, [target objectForKey:@"id"], @"ActivityStream not setting Target with ID properly");
}

- (ActivityStream*)buildValidActivityStream
{
    ActivityStream* activityStream = [ActivityStream new];
    
    [activityStream setVerb:self.testVerb];
    [activityStream setPublished: self.testPublished];
    
    ActivityStreamActor* actor = [activityStream setActorWithId:@"actor id"];
    NSDictionary* location = @{@"ipAddress": @"Host"};
    [actor setDictionaryValue:location forProperty:@"location"];
    [activityStream setActor:actor];
    
    ActivityStreamGenerator* generator = [activityStream setGeneratorWithAppId:@"appId"];
    [generator setStringValue:@"User-Agent" forProperty:@"userAgent"];
    [activityStream setGenerator:generator];
    
    ActivityStreamTarget* target = [activityStream setTargetWithId:@"Target ID"];
    [target setStringValue:@"Target Type" forProperty:@"targetType"];
    [activityStream setTarget:target];
    
    [activityStream setObjectWithId:@"Object id" objectType:@"Object type"];
    
    NSLog(@"%@", [activityStream asDictionary]);
    
    return activityStream;
}

@end
