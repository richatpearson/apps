//
//  TincanTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/12/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Tincan.h"
#import "TincanActor.h"
#import "TincanValidator.h"
#import "SeerUtility.h"

@interface TincanTests : XCTestCase

@property (nonatomic, strong) Tincan* tinCan;
@property (nonatomic, strong) TincanValidator* tincanValidator;
@property (nonatomic, strong) NSString* timeStamp;

@end

@implementation TincanTests

- (void)setUp
{
    [super setUp];
    
    self.tinCan = [self buildValidRevelTincan];
    self.tincanValidator = [TincanValidator new];
}

- (void)tearDown
{
    self.tinCan = nil;
    self.tincanValidator = nil;
    [super tearDown];
}

- (void)testTincanInit
{
    XCTAssertNotNil(self.tinCan, @"Tincan has not been initialized");
}

- (void) testTincanID
{
    XCTAssertNotNil(self.tinCan.tincanId, @"Tincan ID not set properly");
}

- (void) testValidTinCan
{
    XCTAssertTrue([self.tincanValidator validTincan:[self.tinCan asDictionary]], @"Invalid tincan data");
}

- (void) testTincanInitWithStatement
{
    NSDictionary* tcDict = [self buildTincanDictionary];
    
    Tincan* newTincan = [[Tincan alloc] initWithStatement: tcDict];
    
    XCTAssertNotNil(newTincan, @"Tincan has not been initialized with Statement");
    XCTAssertTrue([self.tincanValidator validTincan:[newTincan asDictionary]], @"Invalid tincan data from Statement");
}

- (Tincan*)buildValidTincan
{
    Tincan* tincan = [[Tincan alloc] initWithUniqueId];
    
    TincanActor* tcActor = [tincan setActorWithMbox:@"mailto:jonathan.hodges@pearson.com"];
    [tcActor setName:@"Jonathan Hodges"];
    
    [tincan setActor:tcActor];
    
    [tincan setVerbWithId:@"http://adlnet.gov/expapi/verbs/interacted"];
    
    TincanObject* tcObject = [tincan setObjectWithId:@"http://pearson.com/ccsoc/interactive/c734b08f-01ef-4314-ab90-96bde7d8f693"];
    [tcObject setDefinitionWithType:@"http://pearson.com/ccsoc/interactivetype/"];
    
    [tincan setObject:tcObject];
    
    TincanContextExtensions* tccExt = [TincanContextExtensions new];
    [tccExt setAppId:@"kCommonCore_Outcome_SEER_AppId"];
    
    [tincan setContextWithExtensions:tccExt];
    
    NSLog(@"tincan \n %@", [tincan asDictionary]);
    
    return tincan;
}

- (Tincan*) buildValidRevelTincan
{
    Tincan* tincan = [[Tincan alloc] initWithUniqueId];
    
    // Actor
    TincanActor* tcActor = [TincanActor new];
    [tcActor setObjectType:@"Agent"];
    
    TincanActorAccount *tcActorAcct = [TincanActorAccount new];
    [tcActorAcct setHomepage:@"https://ecollege-prod.apigee.net/registrar/idm"];
    [tcActorAcct setName:@"9e805697-d4b3-4e32-8024-4774bd4e5bcb"];
    
    [tcActor setAccount:tcActorAcct];
    
    [tincan setActor:tcActor];
    
    // Verb
    TincanVerb *tcVerb = [TincanVerb new];
    [tcVerb setId:@"http://activitystrea.ms/schema/1.0/submit"];
    
    [tincan setVerb:tcVerb];
    
    // Object
    TincanObject *tcObject = [TincanObject new];
    [tcObject setObjectType:@"Activity"];
    [tcObject setId:@"http://schema.pearson.com/daalt/assessmentId/123456"];
    [tcObject setDefinitionWithType:@"http://adlnet.gov/expapi/activities/assessment"];
    
    [tincan setObject:tcObject];
    
    // Context
    TincanContext* tcContext = [TincanContext new];
    
    TincanContextExtensions *tcContextExtensions = [TincanContextExtensions new];
    [tcContextExtensions setAppId:@"revel"];
    [tcContextExtensions setStringValue:@"Student"      forProperty:@"http://schema.pearson.com/daalt/actorRole"];
    [tcContextExtensions setStringValue:@"12345"        forProperty:@"http://schema.pearson.com/daalt/containerContentId"];
    [tcContextExtensions setStringValue:@"EPS"          forProperty:@"http://schema.pearson.com/daalt/contentIdType"];
    [tcContextExtensions setStringValue:@"12345"        forProperty:@"http://schema.pearson.com/daalt/assignmentId"];
    [tcContextExtensions setStringValue:@"Revel"        forProperty:@"http://schema.pearson.com/daalt/assignemntType"];
    [tcContextExtensions setStringValue:@"PAF"          forProperty:@"http://schema.pearson.com/daalt/assessmentType"];
    [tcContextExtensions setStringValue:@"12345"        forProperty:@"http://schema.pearson.com/daalt/courseSectionId"];
    [tcContextExtensions setStringValue:@"Registrar"    forProperty:@"http://schema.pearson.com/daalt/courseSectionIdType"];
    
    [tcContext setExtensions:tcContextExtensions];
    
    [tincan setContext:tcContext];
    
    // Timestamp
    [tincan setTimestamp:@"2013-08-24T18:30:32.360Z"];
    
    NSLog(@"Tincan: %@", [tincan asDictionary]);
    
    return tincan;
}

- (NSDictionary*) buildTincanDictionary
{
    NSDictionary *tincanStatement = @{
                             @"id" : @"E4A63E55-0E54-4929-8F36-BE1662E36611",
                             @"actor" : @{
                                     @"objectType" : @"Agent",
                                     @"account" : @{
                                             @"homePage" : @"https://ecollege-prod.apigee.net/registrar/idm",
                                             @"name" : @"9e805697-d4b3-4e32-8024-4774bd4e5bcb"
                                             }
                                     },
                             @"verb" : @{
                                     @"id" : @"http://activitystrea.ms/schema/1.0/submit"
                                     },
                             @"object" : @{
                                     @"objectType" : @"Activity",
                                     @"id" : @"http://schema.pearson.com/daalt/assessmentId/123456",
                                     @"definition" : @{
                                             @"type" : @"http://adlnet.gov/expapi/activities/assessment"
                                             }
                                     },
                             @"context" : @{
                                     @"extensions" : @{
                                             @"appId" : @"revel",
                                             @"http://schema.pearson.com/daalt/actorRole" : @"Student",
                                             @"http://schema.pearson.com/daalt/assessmentType" : @"PAF",
                                             @"http://schema.pearson.com/daalt/assignemntType" : @"Revel",
                                             @"http://schema.pearson.com/daalt/assignmentId" : @"12345",
                                             @"http://schema.pearson.com/daalt/containerContentId" : @"12345",
                                             @"http://schema.pearson.com/daalt/contentIdType" : @"EPS",
                                             @"http://schema.pearson.com/daalt/courseSectionId" : @"12345",
                                             @"http://schema.pearson.com/daalt/courseSectionIdType" : @"Registrar"
                                             }
                                     },
                             @"timestamp" : @"2013-08-24T18:30:32.360Z"
                             };
    
    return tincanStatement;
}

@end
