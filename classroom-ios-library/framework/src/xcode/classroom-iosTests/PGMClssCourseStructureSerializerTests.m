//
//  PGMClssCourseStructureSerializerTests.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/28/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssCourseStructureSerializer.h"
#import "PGMClssCourseStructureItem.h"

@interface PGMClssCourseStructureSerializerTests : XCTestCase

@property (nonatomic, strong) PGMClssCourseStructureSerializer *deserializer;

@end

@implementation PGMClssCourseStructureSerializerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.deserializer = [PGMClssCourseStructureSerializer new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDeserializeCourseStructureItems_NilInput_NilReturned
{
    NSArray *courseListItems = [self.deserializer deserializeCourseStructureItems:nil];
    
    XCTAssertNil(courseListItems);
}

- (void)testDeserializeCourseStructureItems_NonDictData_NilReturned
{
    NSString *wrongJson = @"{\"Non-JSON data\"}";
    
    NSData *data = [wrongJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *courseStructItems = [self.deserializer deserializeCourseStructureItems:data];
    
    XCTAssertNil(courseStructItems);
}

- (void)testDeserializeCourseStructureItems_Success
{
    NSString *courseStructId1    = @"abc123";
    NSString *title1             = @"title1";
    NSString *thumbnail1         = @"http://mythumbnail1.com";
    NSString *contentLink1       = @"http://myresource1";
    
    NSString *courseStructId2    = @"def456";
    NSString *title2             = @"title2";
    NSString *thumbnail2         = @"http://mythumbnail2.com";
    NSString *contentLink2       = @"http://myresource2";
    
    NSString *jsonString = [NSString stringWithFormat:@"{\"_embedded\": {\"items\": [{\"links\": [{\"href\": \"http://pearsonbuild-staging.apigee.net/coursestructure/courses/5245999eb8ab8b46dfc8e9dd/items/%@\",\"rel\": \"mydomain.com/courses/items/self\"}],\"id\": \"%@\",\"title\": \"%@\",\"href\": \"%@\",\"thumbnailUrl\": \"%@\",\"lastModifiedDate\": \"Tue, 01 Jul 2014 14:32:15 GMT\",\"isLocked\": false},{\"links\": [{\"href\": \"http://pearsonbuild-staging.apigee.net/coursestructure/courses/5245999eb8ab8b46dfc8e9dd/items/%@\",\"rel\": \"mydomain.com/courses/items/self\"}],\"id\": \"%@\",\"title\": \"%@\",\"href\": \"%@\",\"lastModifiedDate\": \"Tue, 15 Jul 2014 20:37:08 GMT\",\"thumbnailUrl\": \"%@\",\"isLocked\": false}]}}", courseStructId1, courseStructId1, title1, contentLink1, thumbnail1, courseStructId2, courseStructId2, title2, contentLink2, thumbnail2];
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    PGMClssCourseStructureSerializer *deserializer = [PGMClssCourseStructureSerializer new];
    NSArray *courseStructItems = [deserializer deserializeCourseStructureItems:data];
    
    XCTAssertNotNil(courseStructItems);
    XCTAssertEqual(2, [courseStructItems count]);
    XCTAssertEqualObjects(courseStructId1, ((PGMClssCourseStructureItem*)[courseStructItems objectAtIndex:0]).courseStructureItemId);
    XCTAssertEqualObjects(title1, ((PGMClssCourseStructureItem*)[courseStructItems objectAtIndex:0]).title);
    XCTAssertEqualObjects(contentLink1, ((PGMClssCourseStructureItem*)[courseStructItems objectAtIndex:0]).contentUrl);
    XCTAssertEqualObjects(thumbnail1, ((PGMClssCourseStructureItem*)[courseStructItems objectAtIndex:0]).thumbnailUrl);
    
    XCTAssertEqualObjects(courseStructId2, ((PGMClssCourseStructureItem*)[courseStructItems objectAtIndex:1]).courseStructureItemId);
    XCTAssertEqualObjects(title2, ((PGMClssCourseStructureItem*)[courseStructItems objectAtIndex:1]).title);
    XCTAssertEqualObjects(contentLink2, ((PGMClssCourseStructureItem*)[courseStructItems objectAtIndex:1]).contentUrl);
    XCTAssertEqualObjects(thumbnail2, ((PGMClssCourseStructureItem*)[courseStructItems objectAtIndex:1]).thumbnailUrl);
}

- (void)testDeserializeCourseStructureForSingleItem_NilInput_NilReturned
{
    NSArray *courseListForSingleItem = [self.deserializer deserializeCourseStructureForSingleItem:nil];
    
    XCTAssertNil(courseListForSingleItem);
}

- (void)testDeserializeCourseStructureForSingleItem_NonDictData_NilReturned
{
    NSString *wrongJson = @"{\"Non-JSON data\"}";
    
    NSData *data = [wrongJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *courseStructForSingleItem = [self.deserializer deserializeCourseStructureForSingleItem:data];
    
    XCTAssertNil(courseStructForSingleItem);
}

- (void)testDeserializeCourseStructureForSingleItem_Success
{
    NSString *courseStructId    = @"abc123";
    NSString *title             = @"title1";
    NSString *thumbnail         = @"http://mythumbnail1.com";
    NSString *contentLink       = @"http://myresource1";
    NSString *itemsDesc         = @"this item's description";
    
    NSString *jsonString = [NSString stringWithFormat:@"{\"links\": [{\"href\": \"http://pearsonbuild-staging.apigee.net/coursestructure/courses/5245999eb8ab8b46dfc8e9dd/items/%@\",\"rel\": \"mydomain.com/courses/items/self\"}],\"id\": \"%@\",\"title\": \"%@\",\"href\": \"%@\",\"thumbnailUrl\": \"%@\",\"lastModifiedDate\": \"Tue, 01 Jul 2014 14:32:15 GMT\",\"description\":\"%@\" ,\"isLocked\": false}", courseStructId, courseStructId, title, contentLink, thumbnail, itemsDesc];
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    PGMClssCourseStructureSerializer *deserializer = [PGMClssCourseStructureSerializer new];
    NSArray *courseStructSingleItem = [deserializer deserializeCourseStructureForSingleItem:data];
    
    XCTAssertNotNil(courseStructSingleItem);
    XCTAssertEqual(1, [courseStructSingleItem count]);
    XCTAssertEqualObjects(courseStructId, ((PGMClssCourseStructureItem*)[courseStructSingleItem objectAtIndex:0]).courseStructureItemId);
    XCTAssertEqualObjects(title, ((PGMClssCourseStructureItem*)[courseStructSingleItem objectAtIndex:0]).title);
    XCTAssertEqualObjects(contentLink, ((PGMClssCourseStructureItem*)[courseStructSingleItem objectAtIndex:0]).contentUrl);
    XCTAssertEqualObjects(thumbnail, ((PGMClssCourseStructureItem*)[courseStructSingleItem objectAtIndex:0]).thumbnailUrl);
    XCTAssertEqualObjects(itemsDesc, ((PGMClssCourseStructureItem*)[courseStructSingleItem objectAtIndex:0]).description);

}

@end
