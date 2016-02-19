//
//  PGMClssAssignmentSerializerTests.m
//  classroom-ios
//
//  Created by Joe Miller on 10/10/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssAssignmentSerializer.h"
#import "PGMClssAssignment.h"
#import "PGMClssAssignmentActivity.h"
#import "PGMClssDateUtil.h"
#import "PGMClssCourseListItem.h"

@interface PGMClssAssignmentSerializerTests : XCTestCase

@end

@implementation PGMClssAssignmentSerializerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDeserializeAssignments_nilDataReturnsNil
{
    PGMClssAssignmentSerializer *sut = [PGMClssAssignmentSerializer new];
    NSArray *result = [sut deserializeAssignments:nil withCourseListItem:nil];
    XCTAssertNil(result, @"Expected nil return for nil data.");
}

- (void)testDeserializeAssignments_invalidJSONReturnsNil
{
    PGMClssAssignmentSerializer *sut = [PGMClssAssignmentSerializer new];
    NSArray *result = [sut deserializeAssignments:[@"{" dataUsingEncoding:NSUTF8StringEncoding] withCourseListItem:nil];
    XCTAssertNil(result, @"Expected nil return for invalid JSON.");
}

- (void)testDeserializeAssignments
{
    NSString *aID1 = @"assignmentID1";
    NSString *aTitle1 = @"aTitle1";
    NSString *aTemplateID1 = @"aTemplateID1";
    NSString *aDescription1 = @"aDescription1";
    NSString *aLastModified1 = @"2014-01-01T23:59:59.000Z";
    
    NSString *aID2 = @"assignmentID2";
    NSString *aTitle2 = @"aTitle2";
    NSString *aTemplateID2 = @"aTemplateID2";
    NSString *aDescription2 = @"aDescription2";
    NSString *aLastModified2 = @"2014-02-02T23:59:59.000Z";
    
    NSString *aaID1 = @"aaID1";
    NSString *aaTitle1 = @"aaTitle1";
    NSString *aaDueDate1 = @"2014-01-01T23:59:59.000Z";
    NSString *aaThumbnailURL1 = @"aaThumbnailURL1";
    NSString *aaDescription1 = @"aaDescription1";
    NSString *aaLastModifiedDate1 = @"2014-01-01T23:59:59.000Z";
    
    NSString *aaID2 = @"aaID2";
    NSString *aaTitle2 = @"aaTitle2";
    NSString *aaDueDate2 = @"2014-02-02T23:59:59.000Z";
    NSString *aaThumbnailURL2 = @"aaThumbnailURL2";
    NSString *aaDescription2 = @"aaDescription2";
    NSString *aaLastModifiedDate2 = @"2014-02-02T23:59:59.000Z";
    
    PGMClssCourseListItem *courseListItem = [PGMClssCourseListItem new];
    courseListItem.sectionId = @"sectionId";
    courseListItem.sectionTitle = @"sectionTitle";
    
    NSString *json = [NSString stringWithFormat:@"{ \"_embedded\": { \"assignments\": [ { \"id\": \"%@\", \"title\": \"%@\", \"templateId\": \"%@\", \"description\": \"%@\", \"context\": [ { \"type\": \"ignored\", \"id\": \"ignored\" } ], \"lastModified\": \"%@\", \"_embedded\": { \"activities\": [ { \"id\": \"%@\", \"title\": \"%@\", \"content\": { \"type\": \"ignored\", \"id\": \"ignored\", \"href\": \"ignored\" }, \"dueDate\": \"%@\", \"thumbnailUrl\": \"%@\", \"description\": \"%@\", \"lastModifiedDate\": \"%@\", \"_links\": { \"self\": { \"href\": \"ignored\" } } } ] }, \"_links\": { \"self\": { \"href\": \"ignored\" }, \"activities\": { \"href\": \"ignored\" } } }, { \"id\": \"%@\", \"title\": \"%@\", \"templateId\": \"%@\", \"description\": \"%@\", \"context\": [ { \"type\": \"ignored\", \"id\": \"ignored\" } ], \"lastModified\": \"%@\", \"_embedded\": { \"activities\": [ { \"id\": \"%@\", \"title\": \"%@\", \"content\": { \"type\": \"ignored\", \"id\": \"ignored\", \"href\": \"ignored\" }, \"dueDate\": \"%@\", \"thumbnailUrl\": \"%@\", \"description\": \"%@\", \"lastModifiedDate\": \"%@\", \"_links\": { \"self\": { \"href\": \"ignored\" } } } ] }, \"_links\": { \"self\": { \"href\": \"ignored\" }, \"activities\": { \"href\": \"ignored\" } } } ] } }",
                      aID1,
                      aTitle1,
                      aTemplateID1,
                      aDescription1,
                      aLastModified1,
                      aaID1,
                      aaTitle1,
                      aaDueDate1,
                      aaThumbnailURL1,
                      aaDescription1,
                      aaLastModifiedDate1,
                      aID2,
                      aTitle2,
                      aTemplateID2,
                      aDescription2,
                      aLastModified2,
                      aaID2,
                      aaTitle2,
                      aaDueDate2,
                      aaThumbnailURL2,
                      aaDescription2,
                      aaLastModifiedDate2
    ];
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    PGMClssAssignmentSerializer *sut = [PGMClssAssignmentSerializer new];
    NSArray *result = [sut deserializeAssignments:data withCourseListItem:courseListItem];
    
    XCTAssertNotNil(result, "Expected not nil.");
    XCTAssert(result.count == 2, "Expected 2 assignments.");

    PGMClssAssignment *assignment = (PGMClssAssignment *)[result objectAtIndex:0];
    XCTAssertEqualObjects(assignment.assignmentId, aID1, "Expected assignment 1 ID's to be equal.");
    XCTAssertEqualObjects(assignment.title, aTitle1, "Expected assignment 1 titles to be equal.");
    XCTAssertEqualObjects(assignment.assignmentDescription, aDescription1, "Expected assignment 1 descriptions to be equal.");
    XCTAssertEqualObjects(assignment.lastModified, [PGMClssDateUtil parseDateFromString:aLastModified1], "Expected assignment 1 last modified dates to be equal.");
    XCTAssertEqualObjects(assignment.sectionId, courseListItem.sectionId, "Expected assignment 1 section ID to be equal to courseListItem.");
    XCTAssertEqualObjects(assignment.sectionTitle, courseListItem.sectionTitle, "Expected assignment 1 section title to be equal to courseListItem.");
    XCTAssertNotNil(assignment.assignmentActivities, "Expected assignment 1 activities to be not nil.");
    XCTAssert(assignment.assignmentActivities.count == 1, "Expected assignment 1 to have 1 activity.");
    
    PGMClssAssignmentActivity *activity = [assignment.assignmentActivities objectAtIndex:0];
    XCTAssertEqualObjects(activity.activityId, aaID1, "Expected activity 1 ID's to be equal.");
    XCTAssertEqualObjects(activity.title, aaTitle1, "Expected activity 1 titles to be equal.");
    XCTAssertEqualObjects(activity.dueDate, [PGMClssDateUtil parseDateFromString:aaDueDate1], "Expected activity 1 due dates to be equal.");
    XCTAssertEqualObjects(activity.thumbnailURL, aaThumbnailURL1, "Expected activity 1 URL's to be equal.");
    XCTAssertEqualObjects(activity.activityDescription, aaDescription1, "Expected activity 1 descriptions to be equal.");
    XCTAssertEqualObjects(activity.lastModified, [PGMClssDateUtil parseDateFromString:aaLastModifiedDate1], "Expected activity 1 last modified dates to be equal.");
    XCTAssertEqualObjects(activity.sectionId, assignment.sectionId, "Expected activity 1 section ID to be equal to assignment section ID.");
    XCTAssertEqualObjects(activity.sectionTitle, assignment.sectionTitle, "Expected activity 1 section title to be equal to assignment section title.");
    XCTAssertEqualObjects(activity.assignmentId, assignment.assignmentId, "Expected activity 1 assignment ID to be equal to assignment ID.");
    XCTAssertEqualObjects(activity.assignmentTitle, assignment.title, "Expected activity 1 assignment title to be equal to assignment title.");
    
    assignment = (PGMClssAssignment *)[result objectAtIndex:1];
    XCTAssertEqualObjects(assignment.assignmentId, aID2, "Expected assignment 2 ID's to be equal.");
    XCTAssertEqualObjects(assignment.title, aTitle2, "Expected assignment 2 titles to be equal.");
    XCTAssertEqualObjects(assignment.assignmentDescription, aDescription2, "Expected assignment 2 descriptions to be equal.");
    XCTAssertEqualObjects(assignment.lastModified, [PGMClssDateUtil parseDateFromString:aLastModified2], "Expected assignment 2 last modified dates to be equal.");
    XCTAssertEqualObjects(assignment.sectionId, courseListItem.sectionId, "Expected assignment 2 section ID to be equal to courseListItem.");
    XCTAssertEqualObjects(assignment.sectionTitle, courseListItem.sectionTitle, "Expected assignment 2 section title to be equal to courseListItem.");
    XCTAssertNotNil(assignment.assignmentActivities, "Expected assignment 2 activities to be not nil.");
    XCTAssert(assignment.assignmentActivities.count == 1, "Expected assignment 2 to have 1 activity.");
    
    activity = [assignment.assignmentActivities objectAtIndex:0];
    XCTAssertEqualObjects(activity.activityId, aaID2, "Expected activity 2 ID's to be equal.");
    XCTAssertEqualObjects(activity.title, aaTitle2, "Expected activity 2 titles to be equal.");
    XCTAssertEqualObjects(activity.dueDate, [PGMClssDateUtil parseDateFromString:aaDueDate2], "Expected activity 2 due dates to be equal.");
    XCTAssertEqualObjects(activity.thumbnailURL, aaThumbnailURL2, "Expected activity 2 URL's to be equal.");
    XCTAssertEqualObjects(activity.activityDescription, aaDescription2, "Expected activity 2 descriptions to be equal.");
    XCTAssertEqualObjects(activity.lastModified, [PGMClssDateUtil parseDateFromString:aaLastModifiedDate2], "Expected activity 2 last modified dates to be equal.");
    XCTAssertEqualObjects(activity.sectionId, assignment.sectionId, "Expected activity 2 section ID to be equal to assignment section ID.");
    XCTAssertEqualObjects(activity.sectionTitle, assignment.sectionTitle, "Expected activity 2 section title to be equal to assignment section title.");
    XCTAssertEqualObjects(activity.assignmentId, assignment.assignmentId, "Expected activity 2 assignment ID to be equal to assignment ID.");
    XCTAssertEqualObjects(activity.assignmentTitle, assignment.title, "Expected activity 2 assignment title to be equal to assignment title.");
}

- (void)testDeserializeAssignmentActivities_nilDataReturnsNil
{
    PGMClssAssignmentSerializer *sut = [PGMClssAssignmentSerializer new];
    NSArray *result = [sut deserializeAssignmentActivities:nil withAssignment:nil];
    XCTAssertNil(result, @"Expected nil return for nil data.");
}

- (void)testDeserializeAssignmentActivities_invalidJSONReturnsNil
{
    PGMClssAssignmentSerializer *sut = [PGMClssAssignmentSerializer new];
    NSArray *result = [sut deserializeAssignmentActivities:[@"{" dataUsingEncoding:NSUTF8StringEncoding] withAssignment:nil];
    XCTAssertNil(result, @"Expected nil return for invalid JSON.");
}

- (void)testDeserializeAssignmentActivities
{
    NSString *aaID1 = @"aaID1";
    NSString *aaTitle1 = @"aaTitle1";
    NSString *aaDueDate1 = @"2014-01-01T23:59:59.000Z";
    NSString *aaThumbnailURL1 = @"aaThumbnailURL1";
    NSString *aaDescription1 = @"aaDescription1";
    NSString *aaLastModifiedDate1 = @"2014-01-01T23:59:59.000Z";
    
    NSString *aaID2 = @"aaID2";
    NSString *aaTitle2 = @"aaTitle2";
    NSString *aaDueDate2 = @"2014-02-02T23:59:59.000Z";
    NSString *aaThumbnailURL2 = @"aaThumbnailURL2";
    NSString *aaDescription2 = @"aaDescription2";
    NSString *aaLastModifiedDate2 = @"2014-02-02T23:59:59.000Z";
    
    PGMClssAssignment *assignment = [PGMClssAssignment new];
    assignment.assignmentId = @"assignmentID";
    assignment.title = @"assignmentTitle";
    assignment.sectionId = @"sectionID";
    assignment.sectionTitle = @"sectionTitle";
    
    NSString *json = [NSString stringWithFormat:@"{ \"_embedded\": { \"activities\": [ { \"id\": \"%@\", \"title\": \"%@\", \"content\": { \"type\": \"ignored\", \"id\": \"ignored\", \"href\": \"ignored\" }, \"dueDate\": \"%@\", \"thumbnailUrl\": \"%@\", \"description\": \"%@\", \"lastModifiedDate\": \"%@\", \"_links\": { \"self\": { \"href\": \"ignored\" } } }, { \"id\": \"%@\", \"title\": \"%@\", \"content\": { \"type\": \"ignored\", \"id\": \"ignored\", \"href\": \"ignored\" }, \"dueDate\": \"%@\", \"thumbnailUrl\": \"%@\", \"description\": \"%@\", \"lastModifiedDate\": \"%@\", \"_links\": { \"self\": { \"href\": \"ignored\" } } } ] } }",
                      aaID1,
                      aaTitle1,
                      aaDueDate1,
                      aaThumbnailURL1,
                      aaDescription1,
                      aaLastModifiedDate1,
                      aaID2,
                      aaTitle2,
                      aaDueDate2,
                      aaThumbnailURL2,
                      aaDescription2,
                      aaLastModifiedDate2
        ];
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    PGMClssAssignmentSerializer *sut = [PGMClssAssignmentSerializer new];
    NSArray *result = [sut deserializeAssignmentActivities:data withAssignment:assignment];
    
    XCTAssertNotNil(result, "Expected not nil.");
    XCTAssert(result.count == 2, "Expected 2 assignment activities.");
    
    PGMClssAssignmentActivity *activity = [result objectAtIndex:0];
    XCTAssertEqualObjects(activity.activityId, aaID1, "Expected activity 1 ID's to be equal.");
    XCTAssertEqualObjects(activity.title, aaTitle1, "Expected activity 1 titles to be equal.");
    XCTAssertEqualObjects(activity.dueDate, [PGMClssDateUtil parseDateFromString:aaDueDate1], "Expected activity 1 due dates to be equal.");
    XCTAssertEqualObjects(activity.thumbnailURL, aaThumbnailURL1, "Expected activity 1 URL's to be equal.");
    XCTAssertEqualObjects(activity.activityDescription, aaDescription1, "Expected activity 1 descriptions to be equal.");
    XCTAssertEqualObjects(activity.lastModified, [PGMClssDateUtil parseDateFromString:aaLastModifiedDate1], "Expected activity 1 last modified dates to be equal.");
    XCTAssertEqualObjects(activity.sectionId, assignment.sectionId, "Expected activity 1 section ID to be equal to assignment section ID.");
    XCTAssertEqualObjects(activity.sectionTitle, assignment.sectionTitle, "Expected activity 1 section title to be equal to assignment section title.");
    XCTAssertEqualObjects(activity.assignmentId, assignment.assignmentId, "Expected activity 1 assignment ID to be equal to assignment ID.");
    XCTAssertEqualObjects(activity.assignmentTitle, assignment.title, "Expected activity 1 assignment title to be equal to assignment title.");
    
    activity = [result objectAtIndex:1];
    XCTAssertEqualObjects(activity.activityId, aaID2, "Expected activity 2 ID's to be equal.");
    XCTAssertEqualObjects(activity.title, aaTitle2, "Expected activity 2 titles to be equal.");
    XCTAssertEqualObjects(activity.dueDate, [PGMClssDateUtil parseDateFromString:aaDueDate2], "Expected activity 2 due dates to be equal.");
    XCTAssertEqualObjects(activity.thumbnailURL, aaThumbnailURL2, "Expected activity 2 URL's to be equal.");
    XCTAssertEqualObjects(activity.activityDescription, aaDescription2, "Expected activity 2 descriptions to be equal.");
    XCTAssertEqualObjects(activity.lastModified, [PGMClssDateUtil parseDateFromString:aaLastModifiedDate2], "Expected activity 2 last modified dates to be equal.");
    XCTAssertEqualObjects(activity.sectionId, assignment.sectionId, "Expected activity 2 section ID to be equal to assignment section ID.");
    XCTAssertEqualObjects(activity.sectionTitle, assignment.sectionTitle, "Expected activity 2 section title to be equal to assignment section title.");
    XCTAssertEqualObjects(activity.assignmentId, assignment.assignmentId, "Expected activity 2 assignment ID to be equal to assignment ID.");
    XCTAssertEqualObjects(activity.assignmentTitle, assignment.title, "Expected activity 2 assignment title to be equal to assignment title.");
}

@end
