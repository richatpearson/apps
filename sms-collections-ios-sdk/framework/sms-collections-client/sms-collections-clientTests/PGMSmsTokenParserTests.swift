//
//  PGMSmsTokenParserTests.swift
//  sms-collections-client
//
//  Created by Joe Miller on 12/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsTokenParserTests: XCTestCase {

    func testParseTokenFromUrl_singleParameter_success() {
        var token = "0123456789";
        var url = "https://login.pearsoncmg.com?key=" + token;
        var result = PGMSmsTokenParser.parseTokenFromUrl(NSURL(string: url))
        XCTAssertEqual(result, token, "Expected result to be " + token)
    }
    
    func testParseTokenFromUrl_multipleQueryStringParameters_success() {
        var keyValue = "1234567890"
        var url = "https://login.pearsoncmg.com?blah=value&key=" + keyValue
        var result = PGMSmsTokenParser.parseTokenFromUrl(NSURL(string: url))
        
        println("Result is \(result)")
        
        XCTAssertEqual(keyValue, result)
    }
    
    func testParseTokenFromUrl_missingKeyInQueryString_emptyString() {
        var url = "https://login.pearsoncmg.com?blah=value"
        var result = PGMSmsTokenParser.parseTokenFromUrl(NSURL(string: url))
        
        XCTAssertEqual("", result, "Returns empty string if it can't find key")
    }
    
    func testParseTokenFromUrl_missingQueryString_emptyString() {
        var url = "http://www.google.com"
        var result = PGMSmsTokenParser.parseTokenFromUrl(NSURL(string: url))
        
        XCTAssertEqual("", result, "Returns empty string if it can't find key")
    }
}
