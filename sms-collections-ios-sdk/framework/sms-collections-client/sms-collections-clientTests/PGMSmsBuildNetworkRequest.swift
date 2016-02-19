//
//  PGMSmsBuildNetworkRequest.swift
//  sms-collections-client
//
//  Created by Seals, Morris D on 12/18/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsBuildNetworkRequest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    
    func testBuildNetworkURL() {
        // Test building the network URL
        
        var containsExpectedRequest = false
        // staging:  bsstudent01  /  bluesky1234
        var salt       = "PE"
        var loginToken = "62931979013493361011182014"
        var secretParemeter = PGMSmsSecret.getSecretParameterWithLoginToken(loginToken, andSalt: salt)
        
        var myenvironment     = PGMSmsEnvironment()
        var pgmsmsconnector = PGMSmsConnector(environment: myenvironment)
        var request         = pgmsmsconnector.buildNetworkRequestForModuleIDsWithToken(loginToken, andSalt: salt)
        var requestAsString:String = toString(request)

        // the request should look like whatever is after URL in this comment
        // <NSMutableURLRequest: 0x7ff92db856a0> { URL: https://login.cert.pearsoncmg.com/sso/SSOProfileServlet2?key=62931979013493361011182014&sec=PEq0zkeMHHKm.&siteid=87227 }
        
        var checkAgainstThisString                                                     = "sso/SSOProfileServlet2?key=62931979013493361011182014&sec=PEq0zkeMHHKm.&siteid="

        println("xxxxxxx")
        println("requestAsString         " + requestAsString)
        println("checkAgainstThisString  " + checkAgainstThisString)

        
        if (requestAsString.rangeOfString(checkAgainstThisString) != nil) {
            containsExpectedRequest = true
            println("they are equal")
        } else {
            println("they are not equal")
        }

        XCTAssert(containsExpectedRequest, "Pass")
    }
}
