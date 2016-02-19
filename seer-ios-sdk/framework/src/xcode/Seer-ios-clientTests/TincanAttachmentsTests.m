//
//  TincanAttachmentsTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/23/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanAttachments.h"

@interface TincanAttachmentsTests : XCTestCase

@property (nonatomic, strong) TincanAttachments* tincanAttachments;
@property (nonatomic, strong) NSString* sha2;

@end

@implementation TincanAttachmentsTests

- (void)setUp
{
    [super setUp];
    self.tincanAttachments = [TincanAttachments new];
    self.sha2 = @"495395e777cd98da653df9615d09c0fd6bb2f8d4788394cd53c56a3bfdcd848a";
}

- (void)tearDown
{
    self.tincanAttachments = nil;
    self.sha2 = nil;
    [super tearDown];
}

- (void)testTincanAttachmentsInit
{
    XCTAssertNotNil(self.tincanAttachments, @"TincanAttachments has not been initialized with dictionary");
}

- (void) testAddAttachment
{
    NSUInteger cnt = [[self.tincanAttachments asArray] count];
    
    [self.tincanAttachments addAttachment:[self buildTincanAttachment]];
    
    XCTAssertEqual((cnt + 1), [[self.tincanAttachments asArray] count], @"TincanAttachments not adding attachment to array properly.");
}

- (void) testGetAttachmentWithSha2
{
    NSLog(@"testGetAttachmentWithSha2: %@", [self.tincanAttachments asArray]);
    if([[self.tincanAttachments asArray] count] == 0)
    {
        [self.tincanAttachments addSeerDictionaryObjectData:[self buildTincanAttachment]];
        NSLog(@"Adding Attachment: %@", [self.tincanAttachments asArray]);
    }
    
    TincanAttachment* tcAttachment = [self.tincanAttachments getAttachmentWithSHA2:self.sha2];
    
    XCTAssertNotNil(tcAttachment, @"TincanAttachments not retrieving stored TincanAttachment");
    XCTAssertEqualObjects(self.sha2, [tcAttachment sha2], @"TincanAttachments not retrieving stored TincanAttachment");
}

- (void) testRemoveAttachment
{
    self.tincanAttachments = [TincanAttachments new];
    
    TincanAttachment* tcAttachment = [self buildTincanAttachment];
    [self.tincanAttachments addAttachment:tcAttachment];
    
    NSUInteger cnt = [[self.tincanAttachments asArray] count];
    
    [self.tincanAttachments removeAttachment:tcAttachment];
    
    XCTAssertEqual((cnt -1), [[self.tincanAttachments asArray] count], @"TincanAttachments not removing stored TincanAttachment");
}

- (void) testRemoveAttachmentWithSha2
{
    if([[self.tincanAttachments asArray] count] == 0)
    {
        [self.tincanAttachments addAttachment:[self buildTincanAttachment]];
    }
    
    [self.tincanAttachments removeAttachmentWithSha2:self.sha2];
    
    XCTAssertEqual((NSUInteger)0, [[self.tincanAttachments asArray] count], @"TincanAttachments not removing stored TincanAttachment by sha2");
}

- (TincanAttachment*)buildTincanAttachment
{
    TincanAttachment* tcAttachment = [TincanAttachment new];
    [tcAttachment setUsageType:@"http://example.com/attachment-usage/test"];
    [tcAttachment setContentType:@"text/plain; charset=ascii"];
    [tcAttachment setSha2:self.sha2];
    [tcAttachment setLength:@27];
    
    TincanLanguageMap* tcaDisplay = [TincanLanguageMap new];
    NSDictionary* dispDict = @{ @"en-US": @"A test attachment" };
    
    [tcaDisplay setDictionary:dispDict];
    
    [tcAttachment setDisplay:tcaDisplay];
    
    TincanLanguageMap* tcaDescription = [TincanLanguageMap new];
    NSDictionary* descDict = @{ @"en-US": @"A test attachment (a description)" };
    
    [tcaDescription setDictionary:descDict];
    
    [tcAttachment setAttachmentDescription:tcaDescription];
    
    return tcAttachment;
}

@end
