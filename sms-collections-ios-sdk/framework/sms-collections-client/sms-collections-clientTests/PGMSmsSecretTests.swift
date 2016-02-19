//
//  PGMSecretTests.swift
//  sms-collections-client
//
//  Created by Seals, Morris D on 12/18/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsSecretTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testGetSecretParameterWithLoginToken_success() {
        
        // Test generating a secret parameter
        var loginToken = "230892490112163537511182014"
        var salt = "PE"
        var secret = PGMSmsSecret.getSecretParameterWithLoginToken(loginToken, andSalt: salt)
        var expectedParameter = "PEM1d2ASA.UGI"
        
        println("secretParemeter >" + secret + "<")
        println("checkagainst    >" + "PEM1d2ASA.UGI" + "<")
        
        XCTAssertEqual(expectedParameter, secret)
    }
    
    func testGetSecretParameterWithLoginToken_missingToken_nil() {
        var secret = PGMSmsSecret.getSecretParameterWithLoginToken(nil, andSalt: "PE")
        XCTAssertNil(secret)
        
        secret = PGMSmsSecret.getSecretParameterWithLoginToken("", andSalt: "PE")
        XCTAssertNil(secret)
    }
}
