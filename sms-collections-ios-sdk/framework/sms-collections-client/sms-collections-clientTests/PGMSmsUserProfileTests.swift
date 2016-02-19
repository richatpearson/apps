//
//  PGMSmsUserProfileTests.swift
//  sms-collections-client
//
//  Created by Richard Rosiak on 12/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsUserProfileTests: XCTestCase {

    var userId = "12345"
    var firstName = "John"
    var lastName = "Black"
    var loginName = "john.black"
    var emailAddress = "john.black@gmail.com"
    var institName = "Important institution"
    
    var userProfile: PGMSmsUserProfile!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUserModuleProperties() {
        
        
        userProfile = PGMSmsUserProfile()
        
        XCTAssertNotNil(userProfile)
        XCTAssertNil(userProfile.userId)
        XCTAssertNil(userProfile.firstName)
        XCTAssertNil(userProfile.lastName)
        XCTAssertNil(userProfile.loginName)
        XCTAssertNil(userProfile.emailAddress)
        XCTAssertNil(userProfile.institutionName)
        XCTAssertNil(userProfile.userModules)
        
        self.populateProfileProperties(&userProfile)
        userProfile.userModules = self.defineModuleArray()
        
        XCTAssertEqual(userId, userProfile.userId)
        XCTAssertEqual(firstName, userProfile.firstName)
        XCTAssertEqual(lastName, userProfile.lastName)
        XCTAssertEqual(loginName, userProfile.loginName)
        XCTAssertEqual(emailAddress, userProfile.emailAddress)
        XCTAssertEqual(institName, userProfile.institutionName)
        XCTAssertEqual(2, userProfile.userModules.count)
    }
    
    func populateProfileProperties(inout userProfile: PGMSmsUserProfile!) {
        userProfile.userId = userId
        userProfile.firstName = firstName
        userProfile.lastName = lastName
        userProfile.loginName = loginName
        userProfile.emailAddress = emailAddress
        userProfile.institutionName = institName
    }
    
    func defineModuleArray() -> Array<PGMSmsUserModule> {
        
        var modules = Array<PGMSmsUserModule>()
        
        var module1 = PGMSmsUserModule(isTrial: false, isExpiringWithinWarningPeriod: false, isExpired: true)
        module1.moduleId = "10"
        module1.lastSignOnDate = "10/15/2014 00:00:00"
        module1.expirationDate = "10/02/2015 00:00:00"
        module1.productTypeId = "25"
        module1.marketName = "Market 1"
        module1.licenseType = "S"
        module1.productRoleName = "Student"
        
        modules.append(module1)
        
        var module2 = PGMSmsUserModule(isTrial: true, isExpiringWithinWarningPeriod: true, isExpired: false)
        module2.moduleId = "20"
        module2.lastSignOnDate = "11/03/2014 00:00:00"
        module2.expirationDate = "01/15/2016 00:00:00"
        module2.productTypeId = "40"
        module2.marketName = "Market 2"
        module2.licenseType = "P"
        module2.productRoleName = "Educator"
        
        modules.append(module2)
        
        return modules
    }

    func testUserModuleDescription() {
        userProfile = PGMSmsUserProfile()
        self.populateProfileProperties(&userProfile)
        userProfile.userModules = self.defineModuleArray()
        
        var profileDesc = userProfile.profileDescription()
        
        println("\(profileDesc)")
        XCTAssertNotNil(profileDesc)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userId) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.firstName) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.lastName) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.loginName) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.emailAddress) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.institutionName) != nil)
        
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[0].moduleId) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[0].lastSignOnDate) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[0].expirationDate) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[0].productTypeId) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[0].productRoleName) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[0].licenseType) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[0].marketName) != nil)
        
        var isTrialDesc = (userProfile.userModules[0].isTrial!) ? "isTrial: 1" : "isTrial: 0"
        println("1st is trial desc is: \(isTrialDesc)")
        XCTAssertTrue(profileDesc.rangeOfString(isTrialDesc) != nil)
        
        var isExpWithWarningDesc = (userProfile.userModules[0].isExpiringWithinWarningPeriod!) ? "isExp w/warning: 1" : "isExp w/warning: 0"
        println("1st is expir with warning desc is: \(isExpWithWarningDesc)")
        XCTAssertTrue(profileDesc.rangeOfString(isExpWithWarningDesc) != nil)
        
        var isExpiredDesc = (userProfile.userModules[0].isExpired!) ? "isExpired: 1" : "isExpired: 0"
        println("1st is expired desc is: \(isExpiredDesc)")
        XCTAssertTrue(profileDesc.rangeOfString(isExpiredDesc) != nil)
        
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[1].moduleId) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[1].lastSignOnDate) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[1].expirationDate) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[1].productTypeId) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[1].productRoleName) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[1].licenseType) != nil)
        XCTAssertTrue(profileDesc.rangeOfString(userProfile.userModules[1].marketName) != nil)
        
        isTrialDesc = (userProfile.userModules[1].isTrial!) ? "isTrial: 1" : "isTrial: 0"
        println("2nd is trial desc is: \(isTrialDesc)")
        XCTAssertTrue(profileDesc.rangeOfString(isTrialDesc) != nil)
        
        isExpWithWarningDesc = (userProfile.userModules[1].isExpiringWithinWarningPeriod!) ? "isExp w/warning: 1" : "isExp w/warning: 0"
        println("2nd is expir with warning desc is: \(isExpWithWarningDesc)")
        XCTAssertTrue(profileDesc.rangeOfString(isExpWithWarningDesc) != nil)
        
        isExpiredDesc = (userProfile.userModules[1].isExpired!) ? "isExpired: 1" : "isExpired: 0"
        println("2nd is expired desc is: \(isExpiredDesc)")
        XCTAssertTrue(profileDesc.rangeOfString(isExpiredDesc) != nil)
    }
    
    func testAllModules() {
        
        userProfile = PGMSmsUserProfile()
        self.populateProfileProperties(&userProfile)
        
        XCTAssertEqual(0, userProfile.allModules().count, "Modules not yet set - should be empty array")
        
        userProfile.userModules = self.defineModuleArray()
        
        XCTAssertEqual(2, userProfile.allModules().count, "We set 2 modules in our test data")
        XCTAssertEqual("10", userProfile.allModules()[0].moduleId)
        XCTAssertEqual("20", userProfile.allModules()[1].moduleId)
    }
    
    func testModuleById() {
        
        userProfile = PGMSmsUserProfile()
        self.populateProfileProperties(&userProfile)
        
        XCTAssertNil(userProfile.moduleById("10"), "Modules not yet set")
        
        userProfile.userModules = self.defineModuleArray()
        
        XCTAssertEqual("10", userProfile.moduleById("10").moduleId)
        XCTAssertEqual("Market 1", userProfile.moduleById("10").marketName)
        
        XCTAssertEqual("20", userProfile.moduleById("20").moduleId)
        XCTAssertEqual("Market 2", userProfile.moduleById("20").marketName)
        
        XCTAssertNil(userProfile.moduleById("30"), "Non-existant module id - should return nil")
    }
    
    func testExpiredModules() {
        
        userProfile = PGMSmsUserProfile()
        self.populateProfileProperties(&userProfile)
        
        XCTAssertEqual(0, userProfile.expiredModules().count)
        
        userProfile.userModules = self.defineModuleArray()
        
        XCTAssertEqual("10", userProfile.expiredModules()[0].moduleId)
        
        //modify test data so no expired modules exist
        
        userProfile.userModules.removeAtIndex(0) //removes the item with isExpired as true
        
        XCTAssertEqual(0, userProfile.expiredModules().count, "Should not find any expired modules")
        
        //remove all items from module array
        
        userProfile.userModules.removeAtIndex(0)
        
        XCTAssertEqual(0, userProfile.expiredModules().count, "There should not be any items in module array at all")
    }
    
    func testActiveModules() {
        
        userProfile = PGMSmsUserProfile()
        self.populateProfileProperties(&userProfile)
        
        XCTAssertEqual(0, userProfile.activeModules().count)
        
        userProfile.userModules = self.defineModuleArray()
        
        XCTAssertEqual("20", userProfile.activeModules()[0].moduleId)
        
        //modify test data so no active modules exist
        
        userProfile.userModules.removeAtIndex(1) //removes the item with isExpired as false
        
        XCTAssertEqual(0, userProfile.activeModules().count, "Should not find any active modules")
        
        //remove all items from module array
        
        userProfile.userModules.removeAtIndex(0)
        
        XCTAssertEqual(0, userProfile.activeModules().count, "There should not be any items in module array at all")
    }
    
    func testTrialModules() {
        
        userProfile = PGMSmsUserProfile()
        self.populateProfileProperties(&userProfile)
        
        XCTAssertEqual(0, userProfile.trialModules().count)
        
        userProfile.userModules = self.defineModuleArray()
        
        XCTAssertEqual("20", userProfile.trialModules()[0].moduleId)
        
        //modify test data so no trial modules exist
        
        userProfile.userModules.removeAtIndex(1) //removes the item with isTrial as true
        
        XCTAssertEqual(0, userProfile.trialModules().count, "Should not find any trial modules")
        
        //remove all items from module array
        
        userProfile.userModules.removeAtIndex(0)
        
        XCTAssertEqual(0, userProfile.trialModules().count, "There should not be any items in module array at all")
    }
    
    func testModulesExpiringWithinWarningPeriod() {
        
        userProfile = PGMSmsUserProfile()
        self.populateProfileProperties(&userProfile)
        
        XCTAssertEqual(0, userProfile.modulesExpiringWithinWarningPeriod().count)
        
        userProfile.userModules = self.defineModuleArray()
        
        XCTAssertEqual("20", userProfile.modulesExpiringWithinWarningPeriod()[0].moduleId)
        XCTAssertNotEqual("10", userProfile.modulesExpiringWithinWarningPeriod()[0].moduleId, "Module with id of 10 is not expiring w/warning period.")
        
        //modify test data so no modules with expiring w/warning period exist
        
        userProfile.userModules.removeAtIndex(1) //removes the item with expiring w/warning period as true
        
        XCTAssertEqual(0, userProfile.modulesExpiringWithinWarningPeriod().count, "Should not find any modules expiring w/warning period")
        
        //remove all items from module array
        
        userProfile.userModules.removeAtIndex(0)
        
        XCTAssertEqual(0, userProfile.modulesExpiringWithinWarningPeriod().count, "There should not be any items in module array at all")
    }
}
