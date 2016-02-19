//
//  NSString+Numeric.swift
//  sms-collections-client
//
//  Created by Joe Miller on 12/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class NSString_Numeric: XCTestCase {

    func testIsNumeric() {
        XCTAssertTrue("0123456789".isNumeric(), "Expected isNumeric true")
    }
    
    func testIsNumeric_zero() {
        XCTAssertTrue("0".isNumeric(), "Expected isNumeric true")
    }
    
    func testIsNumeric_negative() {
        XCTAssertTrue("-1".isNumeric(), "Expected isNumeric true")
    }
    
    func testIsNumeric_length_ULLONG_MAX() {
        XCTAssertTrue("18446744073709551615".isNumeric(), "Expected isNumeric true")
    }

    func testIsNumeric_not_numeric_first_char() {
        XCTAssertFalse("x0123456789".isNumeric(), "Expected isNumeric false")
    }
    
    func testIsNumeric_not_numeric_last_char() {
        XCTAssertFalse("0123456789x".isNumeric(), "Expected isNumeric false")
    }
    
    func testIsNumeric_not_numeric_internal_char() {
        XCTAssertFalse("01234x56789".isNumeric(), "Expected isNumeric false")
    }
    
}
