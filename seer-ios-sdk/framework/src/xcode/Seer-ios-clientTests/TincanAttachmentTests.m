//
//  TincanAttachmentTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/23/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanAttachment.h"

@interface TincanAttachmentTests : XCTestCase

@property (nonatomic, strong) TincanAttachment* tincanAttachment;

@end

@implementation TincanAttachmentTests

- (void)setUp
{
    [super setUp];
    self.tincanAttachment = [TincanAttachment new];
}

- (void)tearDown
{
    self.tincanAttachment = nil;
    [super tearDown];
}

- (void)testTincanAttachmentInit
{
    XCTAssertNotNil(self.tincanAttachment, @"TincanAttachment has not been initialized with dictionary");
}

- (void)testTincanAttachmentUsageType
{
    [self.tincanAttachment setUsageType:@"http://example.com/attachment-usage/test"];
    
    XCTAssertEqualObjects(@"http://example.com/attachment-usage/test", [self.tincanAttachment usageType], @"TincanAttachment has problem with setting and retrieving usageType");
}

- (void)testTincanAttachmentContentType
{
    [self.tincanAttachment setContentType:@"text/plain; charset=ascii"];
    
    XCTAssertEqualObjects(@"text/plain; charset=ascii", [self.tincanAttachment contentType], @"TincanAttachment has problem with setting and retrieving contentType");
}

- (void)testTincanAttachmentSha2
{
    [self.tincanAttachment setSha2:@"495395e777cd98da653df9615d09c0fd6bb2f8d4788394cd53c56a3bfdcd848a"];
    
    XCTAssertEqualObjects(@"495395e777cd98da653df9615d09c0fd6bb2f8d4788394cd53c56a3bfdcd848a", [self.tincanAttachment sha2], @"TincanAttachment has problem with setting and retrieving sha2");
}

- (void)testTincanAttachmentLength
{
    [self.tincanAttachment setLength:@27];
    
    XCTAssertEqualObjects(@27, [self.tincanAttachment length], @"TincanAttachment has problem with setting and retrieving length");
}

- (void)testTincanAttachmentDisplay
{
    TincanLanguageMap* tcaDisplay = [TincanLanguageMap new];
    NSDictionary* dict = @{ @"en-US": @"A test attachment" };
    
    [tcaDisplay setDictionary:dict];
    
    [self.tincanAttachment setDisplay:tcaDisplay];
    
    XCTAssertTrue([[self.tincanAttachment display] isKindOfClass:[TincanLanguageMap class]], @"TincanAttachment has problem establishing a display");
}

- (void)testTincanAttachmentDescription
{
    TincanLanguageMap* tcaDescription = [TincanLanguageMap new];
    NSDictionary* dict = @{ @"en-US": @"A test attachment (a description)" };
    
    [tcaDescription setDictionary:dict];
    
    [self.tincanAttachment setAttachmentDescription:tcaDescription];
    
    XCTAssertTrue([[self.tincanAttachment attachmentDescription] isKindOfClass:[TincanLanguageMap class]], @"TincanAttachment has problem establishing a description");
}


@end
