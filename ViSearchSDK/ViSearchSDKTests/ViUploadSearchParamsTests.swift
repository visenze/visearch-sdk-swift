//
//  ViUploadSearchParamsTests.swift
//  ViSearchSDK
//
//  Created by Hung on 6/10/16.
//  Copyright © 2016 Hung. All rights reserved.
//

import XCTest
@testable import ViSearchSDK

class ViUploadSearchParamsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNil( ViUploadSearchParams(im_id: "") , "Missing image id")
        XCTAssertNil( ViUploadSearchParams(im_url: "") , "Missing image url")
        
        /*
        let expectation = self.expectation(description: "wait_for_response")
        
        ViSearch.sharedInstance.setup(appKey: "")
        let params = ViUploadSearchParams(im_url: "https://visenze-productivity-evaluation.s3.ap-southeast-1.amazonaws.com/956e8a53af44bd65c9287bde62016106")
        params?.score = true
        let p = ViPoint(x: 458, y: 309)
        params?.points = [p]
        
        ViSearch.sharedInstance.discoverSearch(params: params!,
        successHandler: {
            (data : ViResponseData?) -> Void in
            // Do something when request succeeds
            // preview by calling : dump(data)
            // check ViResponseData.hasError and ViResponseData.error for any errors return by ViSenze server
            dump(data)
            expectation.fulfill()
            
        },
        failureHandler: {
            (err) -> Void in
            // Do something when request fails e.g. due to network error
            print ("error: \\(err.localizedDescription)")
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 30, handler: nil)
        */
    }
    
}
