//
//  PGMSmsErrorTests.swift
//  sms-collections-client
//
//  Created by Joe Miller on 12/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsErrorTests: XCTestCase {

    func testCreateErrorForErrorCode() {
        var errorDescription = "error description"
        var sut: AnyObject? = PGMSmsError.createErrorForErrorCode(PGMSmsClientErrorCode.NetworkCallError, andDescription: errorDescription)
        XCTAssert(sut is NSError)
        XCTAssertEqual(1, (sut as NSError).code)
        XCTAssertEqual(errorDescription, (sut as NSError).userInfo?.values.first as String)
    }

}
