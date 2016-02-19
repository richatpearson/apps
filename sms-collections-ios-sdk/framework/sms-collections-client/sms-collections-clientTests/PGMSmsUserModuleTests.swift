//
//  PGMSmsUserModuleTests.swift
//  sms-collections-client
//
//  Created by Richard Rosiak on 12/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsUserModuleTests: XCTestCase {
    
    var userModule: AnyObject? = nil

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

    func testUserModuleInit() {
        userModule = PGMSmsUserModule(isTrial: false, isExpiringWithinWarningPeriod: true, isExpired: true)
        
        XCTAssertNotNil(userModule)
        XCTAssertTrue(userModule is PGMSmsUserModule, "Needs to be of type PGMSmsUserModule")
        XCTAssertFalse(userModule!.isTrial!)
        XCTAssertTrue(userModule!.isExpiringWithinWarningPeriod!)
        XCTAssertTrue(userModule!.isExpired!)
        XCTAssertNil((userModule! as PGMSmsUserModule).moduleId)
        XCTAssertNil((userModule! as PGMSmsUserModule).lastSignOnDate)
        XCTAssertNil((userModule! as PGMSmsUserModule).expirationDate)
        XCTAssertNil((userModule! as PGMSmsUserModule).productTypeId)
        XCTAssertNil((userModule! as PGMSmsUserModule).marketName)
        XCTAssertNil((userModule! as PGMSmsUserModule).productRoleName)
        XCTAssertNil((userModule! as PGMSmsUserModule).licenseType)
    }
    
    func testUserModuleInitAndProperties() {
        userModule = self.createModule()
        
        XCTAssertNotNil(userModule)
        XCTAssertTrue(userModule is PGMSmsUserModule, "Needs to be of type PGMSmsUserModule")
        XCTAssertFalse(userModule!.isTrial!)
        XCTAssertFalse(userModule!.isExpiringWithinWarningPeriod!)
        XCTAssertTrue(userModule!.isExpired!)
        XCTAssertEqual("10",(userModule! as PGMSmsUserModule).moduleId)
        XCTAssertEqual("10/15/2014 00:00:00", (userModule! as PGMSmsUserModule).lastSignOnDate)
        XCTAssertEqual("10/02/2015 00:00:00", (userModule! as PGMSmsUserModule).expirationDate)
        XCTAssertEqual("25", (userModule! as PGMSmsUserModule).productTypeId)
        XCTAssertEqual("Market 1", (userModule! as PGMSmsUserModule).marketName)
        XCTAssertEqual("Student", (userModule! as PGMSmsUserModule).productRoleName)
        XCTAssertEqual("S", (userModule! as PGMSmsUserModule).licenseType)
    }
    
    func createModule() -> PGMSmsUserModule {
        var module1 = PGMSmsUserModule(isTrial: false, isExpiringWithinWarningPeriod: false, isExpired: true)
        module1.moduleId = "10"
        module1.lastSignOnDate = "10/15/2014 00:00:00"
        module1.expirationDate = "10/02/2015 00:00:00"
        module1.productTypeId = "25"
        module1.marketName = "Market 1"
        module1.licenseType = "S"
        module1.productRoleName = "Student"
        
        return module1
    }
    
    func testUserModuleDescription() {
        userModule = self.createModule()
        
        var profileDesc = userModule!.moduleDescription()
        println("\(profileDesc)")
        
        XCTAssertTrue(profileDesc.rangeOfString(userModule!.moduleId) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userModule!.lastSignOnDate) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userModule!.expirationDate) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userModule!.productTypeId) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userModule!.marketName) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userModule!.licenseType) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userModule!.productRoleName) != nil)
        
        var isTrialDesc = (userModule!.isTrial!) ? "isTrial: 1" : "isTrial: 0"
        println("1st is trial desc is: \(isTrialDesc)")
        XCTAssertTrue(profileDesc.rangeOfString(isTrialDesc) != nil)
        
        var isExpWithWarningDesc = (userModule!.isExpiringWithinWarningPeriod!) ? "isExp w/warning: 1" : "isExp w/warning: 0"
        println("1st is expir with warning desc is: \(isExpWithWarningDesc)")
        XCTAssertTrue(profileDesc.rangeOfString(isExpWithWarningDesc) != nil)
        
        var isExpiredDesc = (userModule!.isExpired!) ? "isExpired: 1" : "isExpired: 0"
        println("1st is expired desc is: \(isExpiredDesc)")
        XCTAssertTrue(profileDesc.rangeOfString(isExpiredDesc) != nil)
    }
}
