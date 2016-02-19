//
//  PGMSmsAuthenticationResponseHandlerTests.swift
//  sms-collections-client
//
//  Created by Joe Miller on 12/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit
import XCTest

class PGMSmsAuthenticationResponseHandlerTests: XCTestCase {

    func testHandleAuthenticationResponse() {
        var token = "123456789"
        
        var sut = PGMSmsAuthenticationResponseHandler()
        
        var url = NSURL(string: "http://www.google.com/?key="+token)!
        var result = sut.handleAuthenticationResponse(self.urlResponse(url), withError: nil)
        
        XCTAssertEqual(result.smsToken, token, "Expected parsed response token to be equal to token")
        XCTAssertNil(result.error, "Expected nil error")
    }
    
    func testHandleAuthenticationResponse_withError() {
        var error = NSError(domain: "domain", code: 0, userInfo: ["" : ""])
        var url = NSURL(string: "http://www.google.com/?key=123456789")!
        
        var sut = PGMSmsAuthenticationResponseHandler()
        var result = sut.handleAuthenticationResponse(self.urlResponse(url), withError: error)

        XCTAssertNil(result.smsToken, "Expected nil token")
        XCTAssertNotNil(result.error, "Expected not nil error")
        XCTAssertEqual(result.error.code, PGMSmsClientErrorCode.NetworkCallError.rawValue, "Expected errors codes to be equal")
    }
    
    func testHandleAuthenticationResponse_withEmbeddedErrorMessage() {
        var url = NSURL(string: "http://www.google.com/?key=ebedded+error+message")!
        
        var sut = PGMSmsAuthenticationResponseHandler()
        var result = sut.handleAuthenticationResponse(self.urlResponse(url), withError: nil)
        
        XCTAssertNil(result.smsToken, "Expected nil token")
        XCTAssertNotNil(result.error, "Expected not nil error")
        XCTAssertEqual(result.error.code, PGMSmsClientErrorCode.AuthenticationError.rawValue, "Expected errors codes to be equal")
    }

    func urlResponse(url: NSURL) -> NSURLResponse
    {
        return NSURLResponse(URL: url, MIMEType: "", expectedContentLength: 0, textEncodingName: nil)
    }
}
