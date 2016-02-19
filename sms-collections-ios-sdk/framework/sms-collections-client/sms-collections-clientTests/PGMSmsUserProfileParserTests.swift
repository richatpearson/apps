//
//  PGMSmsUserProfileParserTests.swift
//  sms-collections-client
//
//  Created by Richard Rosiak on 12/22/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsUserProfileParserTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitWithData_nilData_error() {
        var parser = PGMSmsUserProfileParser()
        parser.parseWithData(nil)
        
        XCTAssertNil(parser.userProfile)
        XCTAssertNotNil(parser.smsErrorMessage)
        XCTAssertEqual(PGMSmsNilData, parser.smsErrorMessage, "Error shoud be \(PGMSmsNilData)")
    }
    
    func testInitWithData_noXML_error() {
        var noXml = "Bad data returned"
        var data: NSData = noXml.dataUsingEncoding(NSUTF8StringEncoding)!
        
        var parser = PGMSmsUserProfileParser()
        parser.parseWithData(data)

        
        XCTAssertEqual(PGMSmsInvalidData, parser.smsErrorMessage)
        XCTAssertNil(parser.userProfile.userId)
        XCTAssertEqual(0, parser.userProfile.userModules.count)
    }
    
    func testInitWithData_incorrectXML_success() {
        var incorrectXml = "<MyNode><MyChildNode>Child Node Value</MyChildNode></MyNode>"
        var data: NSData = incorrectXml.dataUsingEncoding(NSUTF8StringEncoding)!
        
        var parser = PGMSmsUserProfileParser()
        parser.parseWithData(data)
        
        XCTAssertNil(parser.smsErrorMessage)
        XCTAssertNil(parser.userProfile.userId)
        XCTAssertNotNil(parser.userProfile.userModules)
        XCTAssertEqual(0, parser.userProfile.userModules.count)
    }
    
    func testInitWithData_correctXML_success() {
        var correctXml = "<SMSAuthResponse xmlns=\"http://www.pearsoncmg.com/smsauth/version2\" version=\"2.0\">" +
            "<AcceptSubscription><User id=\"100\">" +
            "<FirstName>bob</FirstName><LastName>white</LastName><LoginName>bob.white</LoginName></User>" +
            "<InstitutionName>ACAD OF ART COLL</InstitutionName>" +
            "<Module isTrial=\"false\" isExpiringWithinWarningPeriod=\"true\" isExpired=\"true\">" +
            "<ModuleAbbrev>10</ModuleAbbrev>" +
            "</Module>" +
            "<Module isTrial=\"false\" isExpiringWithinWarningPeriod=\"true\" isExpired=\"false\">" +
            "<ModuleAbbrev>20</ModuleAbbrev>" +
            "</Module>" +
            "</AcceptSubscription>" +
            "</SMSAuthResponse>"
        
        var data: NSData = correctXml.dataUsingEncoding(NSUTF8StringEncoding)!
        
        var parser = PGMSmsUserProfileParser()
        parser.parseWithData(data)
        
        XCTAssertNil(parser.smsErrorMessage)
        XCTAssertNotNil(parser.userProfile.userId)
        XCTAssertEqual("100", parser.userProfile.userId)
        XCTAssertEqual("bob", parser.userProfile.firstName)
        XCTAssertEqual("white", parser.userProfile.lastName)
        XCTAssertEqual("bob.white", parser.userProfile.loginName)
        XCTAssertEqual("ACAD OF ART COLL", parser.userProfile.institutionName)
        XCTAssertEqual(2, parser.userProfile.userModules.count)
        
        XCTAssertEqual("10", parser.userProfile.userModules[0].moduleId)
        XCTAssertEqual(false, parser.userProfile.userModules[0].isTrial)
        XCTAssertEqual(true, parser.userProfile.userModules[0].isExpiringWithinWarningPeriod)
        XCTAssertEqual(true, parser.userProfile.userModules[0].isExpired)
        
        XCTAssertEqual("20", parser.userProfile.userModules[1].moduleId)
        XCTAssertEqual(false, parser.userProfile.userModules[1].isTrial)
        XCTAssertEqual(true, parser.userProfile.userModules[1].isExpiringWithinWarningPeriod)
        XCTAssertEqual(false, parser.userProfile.userModules[1].isExpired)
    }
}
