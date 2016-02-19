//
//  PGMSmsEnvironmentTests.swift
//  sms-collections-client
//
//  Created by Joe Miller on 12/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsEnvironmentTests: XCTestCase {

    func testInitForType() {
        var siteID = "7777777"
        var error: NSError?
        var sut = PGMSmsEnvironment(forType: PGMSmsEnvironmentType.PGMSMSCertStagingEnv, withSiteID: siteID, error: &error)
        XCTAssertEqual(sut.siteID, siteID, "Expected siteID's to be equal")
        XCTAssertEqual(sut.environmentType, PGMSmsEnvironmentType.PGMSMSCertStagingEnv, "Expected environment types to be equal")
        XCTAssertEqual(sut.baseUrl, "https://login.cert.pearsoncmg.com/", "Expected URLs to be equal")
    }
    
    func testInitWithNilSiteId_error() {
        var error: NSError?
        var smsEnv = PGMSmsEnvironment(forType: PGMSmsEnvironmentType.PGMSMSCertStagingEnv, withSiteID: nil, error: &error)
        
        XCTAssertNil(smsEnv)
        XCTAssertNotNil(error)
        XCTAssertEqual(5, error!.code, "PGMSmsMissingSiteIdError")
    }
}
