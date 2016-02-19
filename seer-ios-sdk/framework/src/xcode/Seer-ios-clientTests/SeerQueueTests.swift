//
//  SeerQueueTests.swift
//  Seer-ios-client
//
//  Created by Richard Rosiak on 3/12/15.
//  Copyright (c) 2015 Pearson. All rights reserved.
//

import UIKit
import XCTest
//import SeerQueue

class SeerQueueTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: test for queueing Seer items
    func testQueueSeerServerRequest_fullDB_noOldItemsRemoval_error() {
        
        class MockSeerDatabaseManager: SeerDatabaseManager {
            private override func databaseSize() -> UInt {
                return 10485600
            }
        }
        
        var seerQueue: SeerQueue! = SeerQueue()
        seerQueue.dbManager = MockSeerDatabaseManager()
        seerQueue.performSeerQueueSetUp()
        
        var response = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload(),
            removeOldItemsWhenFullDB: false)
        
        XCTAssertNotNil(response.error)
        XCTAssertEqual(9, response.error.code, "Error code should be of type SeerQueueFullDBError")
        XCTAssertNotNil(response.error.userInfo?.values.first as String, "Error msg should be included")
        XCTAssertFalse(response.success)
        
        println(response.error.description)
    }
    
    func testQueueSeerServerRequest_fullDB_noOldItemsFound_error() {
        
        class MockSeerDatabaseManager: SeerDatabaseManager {
            override func databaseSize() -> UInt {
                return 10485600
            }
            
            override func createGetSeerQueueOldestRowStatementForOffset(offset: Int32) -> String! {
                return "my mock statement"
            }
            
            override func getSeerQueueRowForStatement(statement: String!) -> SeerQueueDBItem! {
                return nil
            }
        }
        
        var seerQueue: SeerQueue! = SeerQueue()
        seerQueue.dbManager = MockSeerDatabaseManager()
        seerQueue.performSeerQueueSetUp()
        
        var response = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload(),
            removeOldItemsWhenFullDB: true)
        
        XCTAssertNotNil(response.error)
        XCTAssertEqual(9, response.error.code, "Error code should be of type SeerQueueFullDBError")
        XCTAssertNotNil(response.error.userInfo?.values.first as String, "Error msg should be included")
        XCTAssertFalse(response.success)
        
        println(response.error.description)
    }
    
    func testQueueSeerServerRequest_fullDB_notEnuoghOldItemsFound_error() {
        
        class MockSeerDatabaseManager: SeerDatabaseManager {
            
            var getOldestItemCallCounter: Int = 0

            override func databaseSize() -> UInt {
                return 10485600
            }
            
            override func createGetSeerQueueOldestRowStatementForOffset(offset: Int32) -> String! {
                return "my mock statement"
            }
            
            override func getSeerQueueRowForStatement(statement: String!) -> SeerQueueDBItem! {
                
                getOldestItemCallCounter++
                
                var mockPayload = "{\"object\":{\"id\":\"tag:pearson.com,2014:myObject\",\"objectType\":\"myObject\"},\"generator\":{\"appId\":\"mockApp\"},\"actor\":{\"id\":\"mockActor\"},\"verb\":\"myVerb\"}"
                
                var seerQueueDBItem = SeerQueueDBItem(seerQueueDBItemWithQueueId: 1, requestId: 1, requestType: "activityStream", payload: mockPayload, requestCreated: 23329489238, requestStatus: kServerRequestStatusPending)
                
                if getOldestItemCallCounter == 1 {
                    return seerQueueDBItem
                } else { //simulating not finding more items
                    return nil
                }
            }
        }
        
        var seerQueue: SeerQueue! = SeerQueue()
        seerQueue.dbManager = MockSeerDatabaseManager()
        seerQueue.performSeerQueueSetUp()
        
        var response = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload(),
            removeOldItemsWhenFullDB: true)
        
        XCTAssertNotNil(response.error)
        XCTAssertEqual(9, response.error.code, "Error code should be of type SeerQueueFullDBError")
        XCTAssertNotNil(response.error.userInfo?.values.first as String, "Error msg should be included")
        XCTAssertFalse(response.success)
        
        println(response.error.description)
    }
    
    //TODO: more test cases here
    
    func testQueueSeerServerRequest_fullDB_couldNotRemoveOldItemsFromDB_error() {
        
        class MockSeerDatabaseManager: SeerDatabaseManager {
            override func databaseSize() -> UInt {
                return 10485600
            }
            
            override func createGetSeerQueueOldestRowStatementForOffset(offset: Int32) -> String! {
                return "my mock statement"
            }
            
            override func getSeerQueueRowForStatement(statement: String!) -> SeerQueueDBItem! {
                
                var mockPayload = "{\"object\":{\"id\":\"tag:pearson.com,2014:myObject\",\"objectType\":\"myObject\"},\"generator\":{\"appId\":\"mockApp\"},\"actor\":{\"id\":\"mockActor\"},\"verb\":\"myVerb\"}"
                
                var seerQueueDBItem = SeerQueueDBItem(seerQueueDBItemWithQueueId: 1, requestId: 1, requestType: "activityStream", payload: mockPayload, requestCreated: 23329489238, requestStatus: kServerRequestStatusPending)
                
                return seerQueueDBItem
            }
            
            private override func deleteSeerQueueRowsForQueueIds(queueIds: [AnyObject]!) -> Bool {
                return false
            }
        }
        
        var seerQueue: SeerQueue! = SeerQueue()
        seerQueue.dbManager = MockSeerDatabaseManager()
        seerQueue.performSeerQueueSetUp()
        
        var response = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload(),
            removeOldItemsWhenFullDB: true)
        
        XCTAssertNotNil(response.error)
        XCTAssertEqual(9, response.error.code, "Error code should be of type SeerQueueFullDBError")
        XCTAssertNotNil(response.error.userInfo?.values.first as String, "Error msg should be included")
        XCTAssertFalse(response.success)
        
        println(response.error.description)
    }
    
    func testQueueSeerServerRequest_fullDB_success() {
        
        class MockSeerDatabaseManager: SeerDatabaseManager {
            override func databaseSize() -> UInt {
                return 10485600
            }
            
            override func createGetSeerQueueOldestRowStatementForOffset(offset: Int32) -> String! {
                return "my mock statement"
            }
            
            override func getSeerQueueRowForStatement(statement: String!) -> SeerQueueDBItem! {
                
                var mockPayload = "{\"object\":{\"id\":\"tag:pearson.com,2014:myObject\",\"objectType\":\"myObject\"},\"generator\":{\"appId\":\"mockApp\"},\"actor\":{\"id\":\"mockActor\"},\"verb\":\"myVerb\"}"
                
                var seerQueueDBItem = SeerQueueDBItem(seerQueueDBItemWithQueueId: 1, requestId: 1, requestType: "activityStream", payload: mockPayload, requestCreated: 23329489238, requestStatus: kServerRequestStatusPending)
                
                return seerQueueDBItem
            }
            
            private override func deleteSeerQueueRowsForQueueIds(queueIds: [AnyObject]!) -> Bool {
                return true
            }
            
            private override func removeEmptyPagesFromDB() {
                //no code
            }
            
            private override func createSeeqQueueInsertStatementForRequest(request: SeerServerRequest!) -> String! {
                return "my mock insert statement"
            }
            
            private override func insertSeerQueueRowForSqlStatement(statement: String!) -> Int32 {
                return SQLITE_DONE
            }
        }
        
        var seerQueue: SeerQueue! = SeerQueue()
        seerQueue.dbManager = MockSeerDatabaseManager()
        seerQueue.performSeerQueueSetUp()
        
        var response = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload(),
            removeOldItemsWhenFullDB: true)
        
        XCTAssertNil(response.error)
        XCTAssertTrue(response.success)
        XCTAssertEqual(2, response.deletedOldestQueueItems.count, "We have deleted 2 oldest items")
    }
    
    func testQueueSeerServerRequest_emptyDB_success() {
        
        class MockSeerDatabaseManager: SeerDatabaseManager {
            override func databaseSize() -> UInt {
                return 10000
            }
            
            private override func createSeeqQueueInsertStatementForRequest(request: SeerServerRequest!) -> String! {
                return "my mock insert statement"
            }
            
            private override func insertSeerQueueRowForSqlStatement(statement: String!) -> Int32 {
                return SQLITE_DONE
            }
        }
        
        var seerQueue: SeerQueue! = SeerQueue()
        seerQueue.dbManager = MockSeerDatabaseManager()
        seerQueue.performSeerQueueSetUp()
        
        var response = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload(),
            removeOldItemsWhenFullDB: true)
        
        XCTAssertNil(response.error)
        XCTAssertTrue(response.success)
        XCTAssertNil(response.deletedOldestQueueItems)
    }
    
    func testQueueSeerServerRequest_cantInsertNewItem_error() {
        
        class MockSeerDatabaseManager: SeerDatabaseManager {
            override func databaseSize() -> UInt {
                return 10000
            }
            
            private override func createSeeqQueueInsertStatementForRequest(request: SeerServerRequest!) -> String! {
                return "my mock insert statement"
            }
            
            private override func insertSeerQueueRowForSqlStatement(statement: String!) -> Int32 {
                return SQLITE_ERROR
            }
        }
        
        var seerQueue: SeerQueue! = SeerQueue()
        seerQueue.dbManager = MockSeerDatabaseManager()
        seerQueue.performSeerQueueSetUp()
        
        var response = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload(),
            removeOldItemsWhenFullDB: true)
        
        XCTAssertNotNil(response.error)
        XCTAssertEqual(6, response.error.code, "Error code should be of type SeerQueueError")
        XCTAssertNotNil(response.error.userInfo?.values.first as String, "Error msg should be included")
        XCTAssertFalse(response.success)
        XCTAssertNil(response.deletedOldestQueueItems)
        
        println(response.error.description)
    }
    
    func testQueueSeerServerRequest_fullDisk_noOldItemsRemoval_error() {
        
        class MockSeerDatabaseManager: SeerDatabaseManager {
            override func databaseSize() -> UInt {
                return 10000
            }
            
            private override func createSeeqQueueInsertStatementForRequest(request: SeerServerRequest!) -> String! {
                return "my mock insert statement"
            }
            
            private override func insertSeerQueueRowForSqlStatement(statement: String!) -> Int32 {
                return SQLITE_FULL
            }
        }
        
        var seerQueue: SeerQueue! = SeerQueue()
        seerQueue.dbManager = MockSeerDatabaseManager()
        seerQueue.performSeerQueueSetUp()
        
        var response = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload(),
            removeOldItemsWhenFullDB: false)
        
        XCTAssertNotNil(response.error)
        XCTAssertEqual(10, response.error.code, "Error code should be of type SeerQueueFullDiskError")
        XCTAssertNotNil(response.error.userInfo?.values.first as String, "Error msg should be included")
        XCTAssertFalse(response.success)
        XCTAssertNil(response.deletedOldestQueueItems)
        
        println(response.error.description)
    }
    
    func testQueueSeerServerRequest_fullDisk_successDeletingOldest_fullDisk_error() {
        
        class MockSeerDatabaseManager: SeerDatabaseManager {
            
            override func databaseSize() -> UInt {
                return 10000
            }
            
            //Stubs to delete oldest row(s)
            override func createGetSeerQueueOldestRowStatementForOffset(offset: Int32) -> String! {
                return "my mock statement"
            }
            
            override func getSeerQueueRowForStatement(statement: String!) -> SeerQueueDBItem! {
                
                var mockPayload = "{\"object\":{\"id\":\"tag:pearson.com,2014:myObject\",\"objectType\":\"myObject\"},\"generator\":{\"appId\":\"mockApp\"},\"actor\":{\"id\":\"mockActor\"},\"verb\":\"myVerb\"}"
                
                var seerQueueDBItem = SeerQueueDBItem(seerQueueDBItemWithQueueId: 1, requestId: 1, requestType: "activityStream", payload: mockPayload, requestCreated: 23329489238, requestStatus: kServerRequestStatusPending)
                
                return seerQueueDBItem
            }
            
            private override func deleteSeerQueueRowsForQueueIds(queueIds: [AnyObject]!) -> Bool {
                return true
            }
            
            private override func removeEmptyPagesFromDB() {
                //no code
            }
            
            //Stubs to insert in DB - returning SQLITE_FULL - both calls
            private override func createSeeqQueueInsertStatementForRequest(request: SeerServerRequest!) -> String! {
                return "my mock insert statement"
            }
            
            private override func insertSeerQueueRowForSqlStatement(statement: String!) -> Int32 {
                
                return SQLITE_FULL
            }
        }
        
        var seerQueue: SeerQueue! = SeerQueue()
        seerQueue.dbManager = MockSeerDatabaseManager()
        seerQueue.performSeerQueueSetUp()
        
        var response = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload(),
            removeOldItemsWhenFullDB: true)
        
        XCTAssertNotNil(response.error)
        XCTAssertEqual(10, response.error.code, "Error code should be of type SeerQueueFullDiskError")
        XCTAssertNotNil(response.error.userInfo?.values.first as String, "Error msg should be included")
        XCTAssertFalse(response.success)
        XCTAssertEqual(2, response.deletedOldestQueueItems.count, "We have deleted 2 oldest items")
        
        println(response.error.description)
    }
    
    func testQueueSeerServerRequest_fullDisk_successDeletingOldest_cantInsert_error() {
        
        class MockSeerDatabaseManager: SeerDatabaseManager {
            
            var insertCallCounter:Int = 0;
            
            override func databaseSize() -> UInt {
                return 10000
            }
            
            //Stubs to delete oldest row(s)
            override func createGetSeerQueueOldestRowStatementForOffset(offset: Int32) -> String! {
                return "my mock statement"
            }
            
            override func getSeerQueueRowForStatement(statement: String!) -> SeerQueueDBItem! {
                
                var mockPayload = "{\"object\":{\"id\":\"tag:pearson.com,2014:myObject\",\"objectType\":\"myObject\"},\"generator\":{\"appId\":\"mockApp\"},\"actor\":{\"id\":\"mockActor\"},\"verb\":\"myVerb\"}"
                
                var seerQueueDBItem = SeerQueueDBItem(seerQueueDBItemWithQueueId: 1, requestId: 1, requestType: "activityStream", payload: mockPayload, requestCreated: 23329489238, requestStatus: kServerRequestStatusPending)
                
                return seerQueueDBItem
            }
            
            private override func deleteSeerQueueRowsForQueueIds(queueIds: [AnyObject]!) -> Bool {
                return true
            }
            
            private override func removeEmptyPagesFromDB() {
                //no code
            }
            
            //Stubs to insert in DB - returning SQLITE_FULL on 1st call and SQLITE_ERROR on 2nd call
            private override func createSeeqQueueInsertStatementForRequest(request: SeerServerRequest!) -> String! {
                return "my mock insert statement"
            }
            
            private override func insertSeerQueueRowForSqlStatement(statement: String!) -> Int32 {
                insertCallCounter++
                println("In mock of DB insert - counter is now: \(insertCallCounter)")
                
                if insertCallCounter == 1 {
                    return SQLITE_FULL
                } else {
                    return SQLITE_ERROR
                }
            }
        }
        
        var seerQueue: SeerQueue! = SeerQueue()
        seerQueue.dbManager = MockSeerDatabaseManager()
        seerQueue.performSeerQueueSetUp()
        
        var response = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload(),
            removeOldItemsWhenFullDB: true)
        
        XCTAssertNotNil(response.error)
        XCTAssertEqual(6, response.error.code, "Error code should be of type SeerQueueError")
        XCTAssertNotNil(response.error.userInfo?.values.first as String, "Error msg should be included")
        XCTAssertFalse(response.success)
        XCTAssertEqual(2, response.deletedOldestQueueItems.count, "We have deleted 2 oldest items")
        
        println(response.error.description)
    }
    
    func testQueueSeerServerRequest_fullDisk_successDeletingOldest_success() {
        
        class MockSeerDatabaseManager: SeerDatabaseManager {
            
            var insertCallCounter:Int = 0;
            
            override func databaseSize() -> UInt {
                return 10000
            }
            
            //Stubs to delete oldest row(s)
            override func createGetSeerQueueOldestRowStatementForOffset(offset: Int32) -> String! {
                return "my mock statement"
            }
            
            override func getSeerQueueRowForStatement(statement: String!) -> SeerQueueDBItem! {
                
                var mockPayload = "{\"object\":{\"id\":\"tag:pearson.com,2014:myObject\",\"objectType\":\"myObject\"},\"generator\":{\"appId\":\"mockApp\"},\"actor\":{\"id\":\"mockActor\"},\"verb\":\"myVerb\"}"
                
                var seerQueueDBItem = SeerQueueDBItem(seerQueueDBItemWithQueueId: 1, requestId: 1, requestType: "activityStream", payload: mockPayload, requestCreated: 23329489238, requestStatus: kServerRequestStatusPending)
                
                return seerQueueDBItem
            }
            
            private override func deleteSeerQueueRowsForQueueIds(queueIds: [AnyObject]!) -> Bool {
                return true
            }
            
            private override func removeEmptyPagesFromDB() {
                //no code
            }
            
            //Stubs to insert in DB - returning SQLITE_FULL on 1st call and SQLITE_DONE on 2nd call
            private override func createSeeqQueueInsertStatementForRequest(request: SeerServerRequest!) -> String! {
                return "my mock insert statement"
            }
            
            private override func insertSeerQueueRowForSqlStatement(statement: String!) -> Int32 {
                insertCallCounter++
                println("In mock of DB insert - counter is now: \(insertCallCounter)")
                
                if insertCallCounter == 1 {
                    return SQLITE_FULL
                } else {
                    return SQLITE_DONE
                }
            }
        }
        
        var seerQueue: SeerQueue! = SeerQueue()
        seerQueue.dbManager = MockSeerDatabaseManager()
        seerQueue.performSeerQueueSetUp()
        
        var response = seerQueue.queueSeerServerRequest(self.createActivityStreamPayload(),
            removeOldItemsWhenFullDB: true)
        
        XCTAssertNil(response.error)
        XCTAssertTrue(response.success)
        XCTAssertEqual(2, response.deletedOldestQueueItems.count, "We have deleted 2 oldest items")
    }
    
    func createActivityStreamPayload() -> SeerServerRequest {
        
        var jsonString = "{\"object\":{\"id\":\"tag:pearson.com,2014:myObject\",\"objectType\":\"myObject\"},\"generator\":{\"appId\":\"seer_ios_client_app\"},\"actor\":{\"id\":\"myActor\"},\"verb\":\"myVerb\",\"target\":{\"id\":\"tag:pearson.com,2014:myTarget\"},\"published\":\"2015-03-12T22:41:24Z\"}"
        
        var seerRequest = SeerServerRequest()
        seerRequest.requestJSON = jsonString
        seerRequest.requestId = 1
        seerRequest.requestType = "SeerActivityStreamReport"
        
        return seerRequest
    }

}
