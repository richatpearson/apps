//
//  PGMSmsCollectionsClientTests.swift
//  sms-collections-client
//
//  Created by Joe Miller on 12/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsCollectionsClientTests: XCTestCase {
    
    func testCollectionsClientInit() {
        var collectionsClient: AnyObject? = nil
        
        collectionsClient = PGMSmsCollectionsClient()
        
        XCTAssertNotNil(collectionsClient)
        XCTAssert(collectionsClient is PGMSmsCollectionsClient)
    }
    
    func testCollectionsClientInitWithEnv() {
        var collectionsClient: AnyObject? = nil
        
        collectionsClient = PGMSmsCollectionsClient(environment: PGMSmsEnvironment())
        
        XCTAssertNotNil(collectionsClient)
        XCTAssert(collectionsClient is PGMSmsCollectionsClient)
    }
    
    func testCollectionClientConnectorSetter() {
        var collectionsClient = PGMSmsCollectionsClient(environment: PGMSmsEnvironment())
        
        var connector: AnyObject? = nil
        connector = collectionsClient.connector;
        
        XCTAssertNotNil(connector)
        XCTAssert(connector is PGMSmsConnector)
    }
    
    // MARK: - login tests
    
    func testLoginWithUsername() {
        class FakeSmsConnector : PGMSmsConnector {
            var username: String?
            var password: String?
            
            private override func runAuthenticationRequestWithUsername(username: String!, andPassword password: String!, onComplete requestComplete: SmsRequestComplete!) {
                self.username = username
                self.password = password
                requestComplete(PGMSmsResponse());
            }
        }
        
        var username = "username"
        var password = "password"
        
        var connector = FakeSmsConnector()

        var sut = PGMSmsCollectionsClient()
        sut.connector = connector
        sut.loginWithUsername(username, password: password) { (response) -> Void in
            //not testing this condition
        }

        XCTAssertEqual(username, connector.username!, "Expected usernames to be equal")
        XCTAssertEqual(password, connector.password!, "Expected passwords to be equal")
    }
    
    func testLoginWithUsernamePassword_noCredentials_error() {
        
        var smsClient = PGMSmsCollectionsClient()
        
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
        
        //With nil values
        smsClient.loginWithUsername(nil, password: nil, onComplete: loginCompletionHandler)
        
        XCTAssertNil(responseFromBlock.smsToken)
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertEqual(3, responseFromBlock.error.code, "Error code must be of type PGMSmsMissingCredentialsError")
        
        smsClient.loginWithUsername("username", password: nil, onComplete: loginCompletionHandler)
        
        XCTAssertNil(responseFromBlock.smsToken)
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertEqual(3, responseFromBlock.error.code, "Error code must be of type PGMSmsMissingCredentialsError")
        
        smsClient.loginWithUsername(nil, password: "password", onComplete: loginCompletionHandler)
        
        XCTAssertNil(responseFromBlock.smsToken)
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertEqual(3, responseFromBlock.error.code, "Error code must be of type PGMSmsMissingCredentialsError")
        
        //with "" values
        smsClient.loginWithUsername("", password: "", onComplete: loginCompletionHandler)
        
        XCTAssertNil(responseFromBlock.smsToken)
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertEqual(3, responseFromBlock.error.code, "Error code must be of type PGMSmsMissingCredentialsError")
        
        smsClient.loginWithUsername("username", password: "", onComplete: loginCompletionHandler)
        
        XCTAssertNil(responseFromBlock.smsToken)
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertEqual(3, responseFromBlock.error.code, "Error code must be of type PGMSmsMissingCredentialsError")
        
        smsClient.loginWithUsername("", password: "password", onComplete: loginCompletionHandler)
        
        XCTAssertNil(responseFromBlock.smsToken)
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertEqual(3, responseFromBlock.error.code, "Error code must be of type PGMSmsMissingCredentialsError")
    }
    
    func testLoginWithUsernamePassword_sucess() {

        class MockSmsConnector : PGMSmsConnector {
            
            private override func runAuthenticationRequestWithUsername(username: String!, andPassword password: String!, onComplete requestComplete: SmsRequestComplete!) {
                var response = PGMSmsResponse()
                response.smsToken = "1234567890"
                requestComplete(response)
            }
        }
        
        var mockConnector = MockSmsConnector()
        
        var smsClient = PGMSmsCollectionsClient()
        smsClient.connector = mockConnector
        
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
        
        smsClient.loginWithUsername("username", password: "password", onComplete: loginCompletionHandler)
        
        XCTAssertNil(responseFromBlock.error)
        XCTAssertNotNil(responseFromBlock.smsToken)
        XCTAssertEqual("1234567890", responseFromBlock.smsToken)
    }
    
    func testLoginWithUsernamePassword_errorInConnector_error() {
        class MockSmsConnector : PGMSmsConnector {
            
            private override func runAuthenticationRequestWithUsername(username: String!, andPassword password: String!, onComplete requestComplete: SmsRequestComplete!) {
                var response = PGMSmsResponse()
                response.error = PGMSmsError.createErrorForErrorCode(.AuthenticationError, andDescription: "Auth error")
                requestComplete(response)
            }
        }
        
        var mockConnector = MockSmsConnector()
        
        var smsClient = PGMSmsCollectionsClient()
        smsClient.connector = mockConnector
        
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
        
        smsClient.loginWithUsername("username", password: "password", onComplete: loginCompletionHandler)
        
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertNil(responseFromBlock.smsToken)
        XCTAssertEqual(0, responseFromBlock.error.code)
        
    }
    
    // MARK: - user profile tests
    
    func testObtainModuleIDsForTokenSaltOnComplete_noToken_error() {
        
        var smsClient = PGMSmsCollectionsClient()
        
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
        
        smsClient.obtainModuleIDsForToken(nil, salt: "ab", onComplete: moduleCompletionHandler)
        
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertNil(responseFromBlock.userProfile)
        XCTAssertEqual(4, responseFromBlock.error.code, "Error code must be of type PGMSmsMissingTokenError")
        
        smsClient.obtainModuleIDsForToken("", salt: "ab", onComplete: moduleCompletionHandler)
        
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertNil(responseFromBlock.userProfile)
        XCTAssertEqual(4, responseFromBlock.error.code, "Error code must be of type PGMSmsMissingTokenError")
    }
    
    func testObtainModuleIDsForTokenSaltOnComplete_tokenTooShort_error() {
        
        var smsClient = PGMSmsCollectionsClient()
        
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
        
        smsClient.obtainModuleIDsForToken("1234567", salt: "ab", onComplete: moduleCompletionHandler)
        
        XCTAssertNotNil(responseFromBlock.error)
        XCTAssertNil(responseFromBlock.userProfile)
        XCTAssertEqual(6, responseFromBlock.error.code, "Error code must be of type PGMSmsTokenShorterThan8Error")
    }
    
    func testObtainModuleIDsForTokenSaltOnComplete_success() {
        
        class MockSmsConnector : PGMSmsConnector {
            
            private override func runObtainModuleIDsRequestWithToken(token: String!, andSalt salt: String!, onComplete requestComplete: SmsRequestComplete!) {
                var response = PGMSmsResponse()
                var userProfile = PGMSmsUserProfile()
                userProfile.userId = "100"
                userProfile.loginName = "my.login"
                
                response.userProfile = userProfile;
                requestComplete(response)
            }
        }
        
        var smsClient = PGMSmsCollectionsClient(environment: PGMSmsEnvironment())
        smsClient.connector = MockSmsConnector(environment: PGMSmsEnvironment())
        
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
        
        smsClient.obtainModuleIDsForToken("12345678", salt: "ab", onComplete: moduleCompletionHandler)
        
        XCTAssertNil(responseFromBlock.error)
        XCTAssertNotNil(responseFromBlock.userProfile)
        XCTAssertEqual("100", responseFromBlock.userProfile.userId)
        XCTAssertEqual("my.login", responseFromBlock.userProfile.loginName)
    }
}
