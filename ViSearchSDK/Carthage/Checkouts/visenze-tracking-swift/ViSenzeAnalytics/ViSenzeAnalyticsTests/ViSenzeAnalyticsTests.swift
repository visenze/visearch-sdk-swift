//
//  ViSenzeAnalyticsTests.swift
//  ViSenzeAnalyticsTests
//
//  Created by Hung on 8/9/20.
//  Copyright © 2020 ViSenze. All rights reserved.
//

import XCTest
@testable import ViSenzeAnalytics

class ViSenzeAnalyticsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitTracker() {
        let tracker = ViSenzeAnalytics.sharedInstance.newTracker(code: "test", forCn: false)
        let expectation = self.expectation(description: "wait_for_response")
        
        var testEvent: VaEvent = VaEvent(action: "click")!
        tracker.sendEvent(testEvent) { (eventResponse, networkError) in
            dump(eventResponse)
            print("done")
             expectation.fulfill()
        }
        
//        let productClickEvent =  VaEvent.newProductClickEvent(queryId: "ViSearch reqid in API response", pid: "product ID", imgUrl: "product image URL", pos: 3)
        
        waitForExpectations(timeout: 30, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testTrans() {
        let tracker = ViSenzeAnalytics.sharedInstance.newTracker(code: "test", forCn: false)
        let expectation = self.expectation(description: "wait_for_response")
        
        var testEvent: VaEvent = VaEvent.newTransactionEvent(queryId: "test", value: 2.0)!
        tracker.sendEvent(testEvent) { (eventResponse, networkError) in
            dump(eventResponse)
            print("done")
             expectation.fulfill()
        }
                
        waitForExpectations(timeout: 30, handler: nil)
    }

}
