//
//  PGMClssCourseStructureItemTests.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/28/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssCourseStructureItem.h"

@interface PGMClssCourseStructureItemTests : XCTestCase

@end

@implementation PGMClssCourseStructureItemTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCourseStructureItemInitWithDict
{
    NSString *courseStructId    = @"abc123";
    NSString *title             = @"title1";
    NSString *thumbnail         = @"http://mythumbnail.com";
    NSString *contentLink       = @"http://myresource";
    NSString *desc              = @"item's description";
    
    NSString *jsonString = [NSString stringWithFormat:@"{\"id\": \"%@\", \"title\": \"%@\", \"thumbnailUrl\": \"%@\", \"href\": \"%@\", \"description\": \"%@\"}", courseStructId, title, thumbnail, contentLink, desc];
    
    NSError *error;
    NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                             options: NSJSONReadingMutableContainers
                                                               error: &error];
    
    PGMClssCourseStructureItem *item = [[PGMClssCourseStructureItem alloc] initWithDictionary:dictData];
    
    XCTAssertNotNil(item);
    XCTAssertEqualObjects(courseStructId, item.courseStructureItemId);
    XCTAssertEqualObjects(title, item.title);
    XCTAssertEqualObjects(thumbnail, item.thumbnailUrl);
    XCTAssertEqualObjects(contentLink, item.contentUrl);
    XCTAssertEqualObjects(desc, item.description);
}

@end
