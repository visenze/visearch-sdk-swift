//
//  StringHelperTests.swift
//  ViSenzeAnalyticsTests
//
//  Created by Hung on 13/10/20.
//  Copyright © 2020 ViSenze. All rights reserved.
//

import XCTest

@testable import ViSenzeAnalytics

class StringHelperTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLimit() {
        XCTAssertEqual("", StringHelper.limitMaxLength("", 5))
        XCTAssertEqual("abc", StringHelper.limitMaxLength("abc", 5))
        XCTAssertEqual("ab", StringHelper.limitMaxLength("abc", 2))
        XCTAssertEqual("a", StringHelper.limitMaxLength("abc", 1))
        
        XCTAssertEqual("123456", StringHelper.limitMaxLength("1234567", 6))
        XCTAssertEqual("1234587", StringHelper.limitMaxLength("1234587", 7))
              
        
    }

    

}
