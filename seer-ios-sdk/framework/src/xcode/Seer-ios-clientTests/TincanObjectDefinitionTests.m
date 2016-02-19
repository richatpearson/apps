//
//  TincanObjectDefinitionTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/31/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanObjectDefinition.h"

@interface TincanObjectDefinitionTests : XCTestCase

@property (nonatomic, strong) TincanObjectDefinition* tincanObjDef;
@property (nonatomic, strong) NSString* type;

@end

@implementation TincanObjectDefinitionTests

- (void)setUp
{
    [super setUp];
    self.tincanObjDef = [TincanObjectDefinition new];
    self.type = @"http://www.kaplanuniversity.edu/calculus-101/test/435";
    
}

- (void)tearDown
{
    self.tincanObjDef = nil;
    self.type = nil;
    [super tearDown];
}

- (void)testTincanObjectDefinitionInit
{
    XCTAssertNotNil(self.tincanObjDef, @"TincanObjectDefinition has not been initialized properly");
}

- (void) testSetType
{
    [self.tincanObjDef setType:self.type];
    XCTAssertEqualObjects(self.type, [self.tincanObjDef type], @"TincanObjectDefinition not setting it's type properly.");
}

- (void) testSetName
{
    NSString* nameVal = @"Calculus 101 Test";
    
    TincanLanguageMap* nameMap = [TincanLanguageMap new];
    [nameMap setStringValue:nameVal forProperty:@"en-US"];
    
    [self.tincanObjDef setName:nameMap];
    NSLog(@"testSetName name: %@", [self.tincanObjDef name]);
    
    NSLog(@"testSetName name en-US: %@", [[self.tincanObjDef name] getStringValueForProperty:@"en-US"]);
    XCTAssertEqualObjects(nameVal, [[self.tincanObjDef name] getStringValueForProperty:@"en-US"], @"TincanObjectDefinition not setting it's name properly.");
}

- (void) testSetDescription
{
    NSString* descVal = @"Calculus 101";
    
    TincanLanguageMap* descMap = [TincanLanguageMap new];
    [descMap setStringValue:descVal forProperty:@"en-US"];
    
    [self.tincanObjDef setDefDescription:descMap];
    
    XCTAssertEqualObjects(descVal, [[self.tincanObjDef defDescription] getStringValueForProperty:@"en-US"], @"TincanObjectDefinition not setting it's defDescription properly.");
}

@end
