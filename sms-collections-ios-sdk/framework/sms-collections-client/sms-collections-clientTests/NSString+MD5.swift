//
//  NSString+MD5.swift
//  sms-collections-client
//
//  Created by Joe Miller on 12/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class NSString_MD5: XCTestCase {

    func testMD5() {
        var result = "passw0rd".MD5()
        XCTAssert(result == "bed128365216c019988915ed3add75fb", "Expected equality")
        
        result = "Pearson".MD5()
        XCTAssert(result == "c80907b6d4b64a0bd9295e304bf1ac8a", "Expected equality")
    }

}
