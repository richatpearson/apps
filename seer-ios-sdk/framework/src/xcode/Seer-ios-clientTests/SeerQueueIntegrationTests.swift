//
//  SeerQueueIntegrationTests.swift
//  Seer-ios-client
//
//  Created by Richard Rosiak on 3/13/15.
//  Copyright (c) 2015 Pearson. All rights reserved.
//

import UIKit
import XCTest

class SeerQueueIntegrationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func IgnoretestQueueItemsOnDifferentThreads() {
        
        var seerQueue: SeerQueue! = SeerQueue()
        seerQueue.performSeerQueueSetUp() //create db
        
        let seerExpectation1 = expectationWithDescription("Seer queue expectation 1")
        let seerExpectation2 = expectationWithDescription("Seer queue expectation 2")
        
        var response1: SeerQueueResponse!
        var response2: SeerQueueResponse!
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            println("1: Runnig task to queue seer item - on thread \(NSThread.currentThread())")
            response1 = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload1(),
                                                            removeOldItemsWhenFullDB: true)
            seerExpectation1.fulfill()
        })
        
        //NSThread.sleepForTimeInterval(0.001)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            println("2: Runnig task to queue seer item - on thread \(NSThread.currentThread())")
            response2 = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload2(),
                                                            removeOldItemsWhenFullDB: true)
            seerExpectation2.fulfill()
        })
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
        
        XCTAssertTrue(response1.success)
        XCTAssertNil(response1.error)
        
        XCTAssertTrue(response2.success)
        XCTAssertNil(response2.error)
    }
    
    func createActivityStreamPayload1() -> SeerServerRequest {
        
        var jsonString = "{\"object\":{\"id\":\"tag:pearson.com,2014:myObject\",\"objectType\":\"myObject1\"},\"generator\":{\"appId\":\"seer_ios_client_app\"},\"actor\":{\"id\":\"myActor1\"},\"verb\":\"myVerb1\",\"target\":{\"id\":\"tag:pearson.com,2014:myTarget1\"},\"published\":\"2015-03-12T22:41:24Z\"}"
        
        var seerRequest = SeerServerRequest()
        seerRequest.requestJSON = jsonString
        seerRequest.requestId = 1
        seerRequest.requestType = "SeerActivityStreamReport"
        
        return seerRequest
    }
    
    func createActivityStreamPayload2() -> SeerServerRequest {
        
        var jsonString = "{\"object\":{\"id\":\"tag:pearson.com,2014:myObject\",\"objectType\":\"myObject2\"},\"generator\":{\"appId\":\"seer_ios_client_app\"},\"actor\":{\"id\":\"myActor2\"},\"verb\":\"myVerb2\",\"target\":{\"id\":\"tag:pearson.com,2014:myTarget2\"},\"published\":\"2015-03-12T22:41:24Z\"}"
        
        var seerRequest = SeerServerRequest()
        seerRequest.requestJSON = jsonString
        seerRequest.requestId = 1
        seerRequest.requestType = "SeerActivityStreamReport"
        
        return seerRequest
    }
}
