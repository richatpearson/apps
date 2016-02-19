//
//  PGMSmsConnectorTests.swift
//  sms-collections-client
//
//  Created by Joe Miller on 12/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsConnectorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSmsConnectorInit() {
        var smsConnector: AnyObject? = nil
        
        smsConnector = PGMSmsConnector()
        
        XCTAssertNotNil(smsConnector)
        XCTAssert(smsConnector is PGMSmsConnector)
    }
    
    func testSmsConnectorInitWithEnv() {
        var smsConnector: AnyObject? = nil
        
        smsConnector = PGMSmsConnector(environment: PGMSmsEnvironment())
        
        XCTAssertNotNil(smsConnector)
        XCTAssert(smsConnector is PGMSmsConnector)
    }
    
    func testSmsConnectorNetworkResponseHandlerSetter() {
        var smsConnector = PGMSmsConnector(environment: PGMSmsEnvironment())
        
        var networkResponseHandler: AnyObject? = nil
        
        networkResponseHandler = smsConnector.networkResponseHandler
        
        XCTAssertNotNil(networkResponseHandler)
        XCTAssert(networkResponseHandler is PGMSmsAuthenticationResponseHandler)
    }
    
    func testSmsConnectorCoreNetworkRequesterSetter() {
        var smsConnector = PGMSmsConnector(environment: PGMSmsEnvironment())
        
        var coreNetworkRequester: AnyObject? = nil
        
        coreNetworkRequester = smsConnector.networkRequester
        
        XCTAssertNotNil(coreNetworkRequester)
        XCTAssert(coreNetworkRequester is PGMCoreNetworkRequester)
    }
    
    // MARK: - login tests
    
    class MockPGMCoreNetworkRequester: PGMCoreNetworkRequester {
        override func performNetworkCallWithRequest(request: NSURLRequest!, andCompletionHandler onComplete: NetworkRequestComplete!) {
            onComplete(nil, nil, nil)
        }
    }
    
    func testRunAuthenticationRequestWithUsernameAndPasswordOnComplete_networkError_error() {
        
        class MockPGMSmsAuthenticationResponseHandler: PGMSmsAuthenticationResponseHandler {
            private override func handleAuthenticationResponse(urlResponse: NSURLResponse!, withError error: NSError!) -> PGMSmsResponse! {
                var response = PGMSmsResponse()
                response.error = PGMSmsError.createErrorForErrorCode(.NetworkCallError, andDescription: "Network mock error")
                return response
            }
        }
        
        var smsConnector = PGMSmsConnector(environment: PGMSmsEnvironment())
        smsConnector.networkRequester = MockPGMCoreNetworkRequester()
        smsConnector.networkResponseHandler = MockPGMSmsAuthenticationResponseHandler()
        
        var responseFromBlock: PGMSmsResponse!
        var loginCompletionHandler: SmsRequestComplete =  {(smsResponse) -> () in
            responseFromBlock = smsResponse
            if (smsResponse.error != nil) {
                println("Executing completion block - error!")
                println("Error code is: \(smsResponse.error.code) and msg: \(smsResponse.error.userInfo?.values.first as String)")
            }else {
                println("Executing completion block - success!!")
            }
        }
        
        smsConnector.runAuthenticationRequestWithUsername("username", andPassword: "password", onComplete: loginCompletionHandler)
        
        XCTAssertNil(responseFromBlock.smsToken)
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertEqual(1, responseFromBlock.error.code, "Error code must be of type PGMSmsNetworkCallError")
        XCTAssertEqual("Network mock error", responseFromBlock.error.userInfo?.values.first as String)
    }
    
    func testRunAuthenticationRequestWithUsernameAndPasswordOnComplete_success() {
        
        class MockPGMSmsAuthenticationResponseHandler: PGMSmsAuthenticationResponseHandler {
            private override func handleAuthenticationResponse(urlResponse: NSURLResponse!, withError error: NSError!) -> PGMSmsResponse! {
                var response = PGMSmsResponse()
                response.smsToken = "1234567890"
                return response
            }
        }
        
        var smsConnector = PGMSmsConnector(environment: PGMSmsEnvironment())
        smsConnector.networkRequester = MockPGMCoreNetworkRequester()
        smsConnector.networkResponseHandler = MockPGMSmsAuthenticationResponseHandler()
        
        var responseFromBlock: PGMSmsResponse!
        var loginCompletionHandler: SmsRequestComplete =  {(smsResponse) -> () in
            responseFromBlock = smsResponse
            if (smsResponse.error != nil) {
                println("Executing completion block - error!")
                println("Error code is: \(smsResponse.error.code) and msg: \(smsResponse.error.userInfo?.values.first as String)")
            }else {
                println("Executing completion block - success!!")
            }
        }
        
        smsConnector.runAuthenticationRequestWithUsername("username", andPassword: "password", onComplete: loginCompletionHandler)
        
        XCTAssertNotNil(responseFromBlock.smsToken)
        XCTAssertNil(responseFromBlock.error)
        XCTAssertEqual("1234567890", responseFromBlock.smsToken, "Sms token was set to 1234567890 in MockPGMSmsAuthenticationResponseHandler")
    }
    
    // MARK: - user profile tests
    
    func testRunObtainModuleIDsRequestWithTokenAndSaltOnComplete_networkError_error() {
        
        class MockModulesPGMCoreNetworkRequester: PGMCoreNetworkRequester {
            override func performNetworkCallWithRequest(request: NSURLRequest!, andCompletionHandler onComplete: NetworkRequestComplete!) {
                onComplete(nil, nil, PGMSmsError.createErrorForErrorCode(.NetworkCallError, andDescription: "Mock network error"))
            }
        }
        
        var smsConnector = PGMSmsConnector(environment: PGMSmsEnvironment())
        smsConnector.networkRequester = MockModulesPGMCoreNetworkRequester()
        
        var responseFromBlock: PGMSmsResponse!
        var moduleCompletionHandler: SmsRequestComplete =  {(smsResponse) -> () in
            responseFromBlock = smsResponse
            if (smsResponse.error != nil) {
                println("Executing completion block - error!")
                println("Error code is: \(smsResponse.error.code) and msg: \(smsResponse.error.userInfo?.values.first as String)")
            }else {
                println("Executing completion block - success!!")
            }
        }
        
        smsConnector.runObtainModuleIDsRequestWithToken("12345678", andSalt: nil, onComplete: moduleCompletionHandler)
        
        XCTAssertNil(responseFromBlock.userProfile)
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertEqual(1, responseFromBlock.error.code, "Error code must be of type PGMSmsNetworkCallError")
        XCTAssertEqual("Mock network error", responseFromBlock.error.userInfo?.values.first as String)
    }
    
    class MockModulesPGMCoreNetworkRequester: PGMCoreNetworkRequester {
        override func performNetworkCallWithRequest(request: NSURLRequest!, andCompletionHandler onComplete: NetworkRequestComplete!) {
            var someXml = "<MyNode><MyChildNode>Child Node Value</MyChildNode></MyNode>"
            var data: NSData = someXml.dataUsingEncoding(NSUTF8StringEncoding)!
            onComplete(data, nil, nil)
        }
    }
    
    func testRunObtainModuleIDsRequestWithTokenAndSaltOnComplete_parserError_error() {
        
        class MockPGMSmsUserProfileParser: PGMSmsUserProfileParser {
            
            private override func parseWithData(data: NSData!) {
                self.smsErrorMessage = "Mock sms error msg"
                self.userProfile = PGMSmsUserProfile()
            }
        }
        
        var smsConnector = PGMSmsConnector(environment: PGMSmsEnvironment())
        smsConnector.networkRequester = MockModulesPGMCoreNetworkRequester()
        smsConnector.userProfileParser = MockPGMSmsUserProfileParser()
        
        var responseFromBlock: PGMSmsResponse!
        var moduleCompletionHandler: SmsRequestComplete =  {(smsResponse) -> () in
            responseFromBlock = smsResponse
            if (smsResponse.error != nil) {
                println("Executing completion block - error!")
                println("Error code is: \(smsResponse.error.code) and msg: \(smsResponse.error.userInfo?.values.first as String)")
            }else {
                println("Executing completion block - success!!")
            }
        }
        
        smsConnector.runObtainModuleIDsRequestWithToken("12345678", andSalt: nil, onComplete: moduleCompletionHandler)
        
        XCTAssertNotNil(responseFromBlock.userProfile)
        XCTAssertNil(responseFromBlock.userProfile.userId)
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertEqual(2, responseFromBlock.error.code, "Error code must be of type PGMSmsDenySubscriptionError")
        XCTAssertEqual("Mock sms error msg", responseFromBlock.error.userInfo?.values.first as String)
    }
    
    func testRunObtainModuleIDsRequestWithTokenAndSaltOnComplete_success() {
        class MockPGMSmsUserProfileParser: PGMSmsUserProfileParser {
            
            private override func parseWithData(data: NSData!) {
                self.userProfile = PGMSmsUserProfile()
                self.userProfile.userId = "100"
                self.userProfile.firstName = "John"
                var module1 = PGMSmsUserModule(isTrial: false, isExpiringWithinWarningPeriod: false, isExpired: false)
                module1.moduleId = "1000"
                var module2 = PGMSmsUserModule(isTrial: true, isExpiringWithinWarningPeriod: false, isExpired: true)
                module2.moduleId = "2000"
                var module3 = PGMSmsUserModule(isTrial: false, isExpiringWithinWarningPeriod: true, isExpired: true)
                module3.moduleId = "3000"
                
                var modules = Array<PGMSmsUserModule>()
                modules.append(module1)
                modules.append(module2)
                modules.append(module3)
                self.userProfile.userModules = modules
            }
        }
        
        var smsConnector = PGMSmsConnector(environment: PGMSmsEnvironment())
        smsConnector.networkRequester = MockModulesPGMCoreNetworkRequester()
        smsConnector.userProfileParser = MockPGMSmsUserProfileParser()
        
        var responseFromBlock: PGMSmsResponse!
        var moduleCompletionHandler: SmsRequestComplete =  {(smsResponse) -> () in
            responseFromBlock = smsResponse
            if (smsResponse.error != nil) {
                println("Executing completion block - error!")
                println("Error code is: \(smsResponse.error.code) and msg: \(smsResponse.error.userInfo?.values.first as String)")
            }else {
                println("Executing completion block - success!!")
            }
        }
        
        smsConnector.runObtainModuleIDsRequestWithToken("12345678", andSalt: nil, onComplete: moduleCompletionHandler)
        
        XCTAssertNil(responseFromBlock.error)
        XCTAssertNotNil(responseFromBlock.userProfile)
        XCTAssertEqual("100", responseFromBlock.userProfile.userId)
        XCTAssertEqual("John", responseFromBlock.userProfile.firstName)
        XCTAssertEqual(3, responseFromBlock.userProfile.userModules.count)
        
        XCTAssertEqual("1000", responseFromBlock.userProfile.userModules[0].moduleId)
        XCTAssertEqual(false, responseFromBlock.userProfile.userModules[0].isTrial!)
        XCTAssertEqual(false, responseFromBlock.userProfile.userModules[0].isExpiringWithinWarningPeriod!)
        XCTAssertEqual(false, responseFromBlock.userProfile.userModules[0].isExpired!)
        
        XCTAssertEqual("2000", responseFromBlock.userProfile.userModules[1].moduleId)
        XCTAssertEqual(true, responseFromBlock.userProfile.userModules[1].isTrial!)
        XCTAssertEqual(false, responseFromBlock.userProfile.userModules[1].isExpiringWithinWarningPeriod!)
        XCTAssertEqual(true, responseFromBlock.userProfile.userModules[1].isExpired!)
        
        XCTAssertEqual("3000", responseFromBlock.userProfile.userModules[2].moduleId)
        XCTAssertEqual(false, responseFromBlock.userProfile.userModules[2].isTrial!)
        XCTAssertEqual(true, responseFromBlock.userProfile.userModules[2].isExpiringWithinWarningPeriod!)
        XCTAssertEqual(true, responseFromBlock.userProfile.userModules[2].isExpired!)
    }
}
