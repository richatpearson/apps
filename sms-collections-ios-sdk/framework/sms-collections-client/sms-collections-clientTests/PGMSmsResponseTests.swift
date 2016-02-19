//
//  PGMSmsResponseTests.swift
//  sms-collections-client
//
//  Created by Richard Rosiak on 12/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsResponseTests: XCTestCase {
    
    var response: AnyObject? = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPGMSmsResponseProperties() {
        response = PGMSmsResponse()
        
        XCTAssertNotNil(response)
        XCTAssert(response is PGMSmsResponse)
        XCTAssertNil(response!.error)
        XCTAssertNil((response! as PGMSmsResponse).smsToken)
        XCTAssertNil((response! as PGMSmsResponse).userProfile)
        
        (response! as PGMSmsResponse).error = PGMSmsError.createErrorForErrorCode(.AuthenticationError, andDescription: "Test error")
        (response! as PGMSmsResponse).smsToken = "1234567890"
        (response! as PGMSmsResponse).userProfile = PGMSmsUserProfile();
        (response! as PGMSmsResponse).userProfile.userId = "10"
        (response! as PGMSmsResponse).userProfile.firstName = "Mark"
        (response! as PGMSmsResponse).userProfile.loginName = "username"
        
        XCTAssertNotNil((response! as PGMSmsResponse).error)
        XCTAssertEqual(0, (response! as PGMSmsResponse).error.code)
        XCTAssertEqual("Test error", (response! as PGMSmsResponse).error.userInfo?.values.first as String)
        XCTAssertEqual("1234567890", (response! as PGMSmsResponse).smsToken)
        XCTAssertNotNil((response! as PGMSmsResponse).userProfile)
        XCTAssertEqual("10", (response! as PGMSmsResponse).userProfile.userId)
        XCTAssertEqual("Mark", (response! as PGMSmsResponse).userProfile.firstName)
        XCTAssertEqual("username", (response! as PGMSmsResponse).userProfile.loginName)
    }

}
