//
//  PGMSmsCollectionsClientIntegrationTests.swift
//  sms-collections-client
//
//  Created by Richard Rosiak on 12/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsCollectionsClientIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func IgnoretestLoginWithUsernamePasswordOnComplete() {
        var username = "logntest2"
        var password = "passw0rd"
        
        let loginExpectation = expectationWithDescription("SMS login expectation")
        
        var onComplete: SmsRequestComplete =  {(smsResponse) -> () in
            
            if (smsResponse.error != nil) {
                println("Executing login completion block - error!")
                println("Error code is: \(smsResponse.error.code) and msg: \(smsResponse.error.userInfo?.values.first as String)")
            }else {
                println("Executing login completion block - success!! The token is \(smsResponse.smsToken)")
            }
            
            if (smsResponse.smsToken != nil) {
                
                XCTAssertNotNil(smsResponse.smsToken)
                XCTAssertNil(smsResponse.error)
            }
            else {
                XCTAssert(false,"No token!")
            }
            
            loginExpectation.fulfill()
        }
        
        var environment = PGMSmsEnvironment(forType: PGMSmsEnvironmentType.PGMSMSCertStagingEnv, withSiteID: "87227", error: nil)
        var smsCollectionsClient = PGMSmsCollectionsClient(environment: environment)
        
        smsCollectionsClient.loginWithUsername(username, password: password, onComplete: onComplete)
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func IgnoretestObtainModuleIDsForTokenSaltOnComplete() {
        //first login:
        
        var username = "logntest2"
        var password = "passw0rd"
        var currentToken: String!
        
        let loginExpectation = expectationWithDescription("SMS login expectation")
        
        var loginOnComplete: SmsRequestComplete =  {(smsResponse) -> () in
            
            if (smsResponse.error != nil) {
                println("Executing login completion block - error!")
                println("Error code is: \(smsResponse.error.code) and msg: \(smsResponse.error.userInfo?.values.first as String)")
            }else {
                println("Executing login completion block - success!! The token is \(smsResponse.smsToken)")
            }
            
            if (smsResponse.smsToken != nil) {
                currentToken = smsResponse.smsToken
            }
            else {
                println("No token!")
            }
            
            loginExpectation.fulfill()
        }
        
        var environment = PGMSmsEnvironment(forType: PGMSmsEnvironmentType.PGMSMSCertStagingEnv, withSiteID: "87227", error: nil)
        var smsCollectionsClient = PGMSmsCollectionsClient(environment: environment)
        
        smsCollectionsClient.loginWithUsername(username, password: password, onComplete: loginOnComplete)
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
        
        // obtaining user profile with token:
        
        println("\nLogin is done - starting user profile\n")
        
        var salt = "PE"
        println("Current token is \(currentToken)")
        
        if (currentToken == nil) {
            println("No current token! Exitting...")
            return;
        }
        
        let expectation = expectationWithDescription("SMS modules expectation")
        
        var onComplete: SmsRequestComplete =  {(smsResponse) -> () in
            
            if (smsResponse.error != nil) {
                println("Executing completion block - error!")
                println("Error code is: \(smsResponse.error.code) and msg: \(smsResponse.error.userInfo?.values.first as String)")
            }else {
                println("Executing completion block - success!!")
            }
            
            if (smsResponse.userProfile != nil && smsResponse.userProfile.userModules.count > 0) {
                
                XCTAssertEqual("8940761", smsResponse.userProfile.userId, "If token is for user logntest2 then its id should be 8940761")
                XCTAssertEqual("logntest2", smsResponse.userProfile.loginName, "Login name wrong for username logntest2")
                XCTAssertEqual(2, smsResponse.userProfile.userModules.count)
                
                println("\(smsResponse.userProfile.profileDescription())")
            }
            else {
                XCTAssert(false,"No module ids!")
            }
            
            expectation.fulfill()
        }
        
        //var environment = PGMSmsEnvironment(forType: PGMSmsEnvironmentType.PGMSMSCertStagingEnv, withSiteID: "87227", error: nil)
        //var smsCollectionsClient = PGMSmsCollectionsClient(environment: environment)
        
        smsCollectionsClient.obtainModuleIDsForToken(currentToken, salt: salt, onComplete: onComplete)
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
        
        //and again with nil salt value - SDK will provide
        println("\nSame request but with nil salt\n")
        
        let expectation2 = expectationWithDescription("SMS modules with nil salt expectation")
        
        var onCompleteNilSalt: SmsRequestComplete =  {(smsResponse) -> () in
            
            if (smsResponse.error != nil) {
                println("Executing completion block nil Salt - error!")
                println("Error code is: \(smsResponse.error.code) and msg: \(smsResponse.error.userInfo?.values.first as String)")
            }else {
                println("Executing completion block nil Salt- success!!")
            }
            
            if (smsResponse.userProfile != nil && smsResponse.userProfile.userModules.count > 0) {
                
                XCTAssertEqual("8940761", smsResponse.userProfile.userId, "If token is for user logntest2 then its id should be 8940761")
                XCTAssertEqual("logntest2", smsResponse.userProfile.loginName, "Login name wrong for username logntest2")
                XCTAssertEqual(2, smsResponse.userProfile.userModules.count)
                
                println("\(smsResponse.userProfile.profileDescription())")
            }
            else {
                XCTAssert(false,"No module ids!")
            }
            
            expectation2.fulfill()
        }
        
        smsCollectionsClient.obtainModuleIDsForToken(currentToken, salt: nil, onComplete: onCompleteNilSalt)
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func IgnoretestObtainModuleIDsForTokenSaltOnComplete_invalidToken_error() {
        var salt = "PE"
        var token = "29203172617304762911172019"
        
        let expectation = expectationWithDescription("SMS error expectation")
        
        var onComplete: SmsRequestComplete =  {(smsResponse) -> () in
            
            if (smsResponse.error != nil) {
                println("Executing completion block - error!")
                println("Error code is: \(smsResponse.error.code) and msg: \(smsResponse.error.userInfo?.values.first as String)")
            }else {
                println("Executing completion block - success!!")
            }
                
            XCTAssertNil(smsResponse.userProfile.userId)
            XCTAssertEqual(0, smsResponse.userProfile.userModules.count)
            XCTAssertNotNil(smsResponse.error)
            XCTAssertEqual(2, smsResponse.error.code, "Error should be of type PGMSmsDenySubscriptionError")
            
            expectation.fulfill()
        }
        
        var environment = PGMSmsEnvironment(forType: PGMSmsEnvironmentType.PGMSMSCertStagingEnv, withSiteID: "87227", error: nil)
        var smsCollectionsClient = PGMSmsCollectionsClient(environment: environment)
        
        smsCollectionsClient.obtainModuleIDsForToken(token, salt: salt, onComplete: onComplete)
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func IgnoretestObtainModuleIDsForTokenSaltOnComplete_invalidSiteId_error() {
        var salt = "PE"
        var token = "2490680620463982711232014"
        
        let expectation = expectationWithDescription("SMS error expectation")
        
        var onComplete: SmsRequestComplete =  {(smsResponse) -> () in
            
            if (smsResponse.error != nil) {
                println("Executing completion block - error!")
                println("Error code is: \(smsResponse.error.code) and msg: \(smsResponse.error.userInfo?.values.first as String)")
            }else {
                println("Executing completion block - success!!")
            }
            
            XCTAssertNil(smsResponse.userProfile.userId)
            XCTAssertEqual(0, smsResponse.userProfile.userModules.count)
            XCTAssertNotNil(smsResponse.error)
            XCTAssertEqual(2, smsResponse.error.code, "Error should be of type PGMSmsDenySubscriptionError")
            
            expectation.fulfill()
        }
        
        var environment = PGMSmsEnvironment(forType: PGMSmsEnvironmentType.PGMSMSCertStagingEnv, withSiteID: "10", error: nil)
        var smsCollectionsClient = PGMSmsCollectionsClient(environment: environment)
        
        smsCollectionsClient.obtainModuleIDsForToken(token, salt: salt, onComplete: onComplete)
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }

}
