//
//  ViProductTest.swift
//  ViSearchSDKTests
//
//  Created by visenze on 19/3/21.
//

import XCTest
@testable import ViSearchSDK

class ViProductTest: XCTestCase {
 
    private let RESPONSE: String = """
    [{
       "product_id": "POMELO2-AF-SG_b28d580ccf5dfd999d1006f15f773bb371542559",
       "main_image_url": "http://d3vhkxmeglg6u9.cloudfront.net/img/p/2/2/1/8/0/6/221806.jpg",
       "data": {
           "link": "https://iprice.sg/r/p/?_id=b28d580ccf5dfd999d1006f15f773bb371542559",
           "product_name": "Skrrrrt Cropped Graphic Hoodie Light Grey",
           "sale_price": {
               "currency": "SGD",
               "value": "44.0"
           }
       }
    }]
    """;
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParse() {
        
        let results = ViProductSearchResponse.parseProductResults(RESPONSE)
        
        XCTAssertEqual(results.isEmpty, false)
        XCTAssertNotNil(results[0])
        XCTAssertEqual(results[0].productId, "POMELO2-AF-SG_b28d580ccf5dfd999d1006f15f773bb371542559")
        XCTAssertEqual(results[0].mainImageUrl, "http://d3vhkxmeglg6u9.cloudfront.net/img/p/2/2/1/8/0/6/221806.jpg")
        
        let link = results[0].data["link"] as! String
        XCTAssertEqual(link, "https://iprice.sg/r/p/?_id=b28d580ccf5dfd999d1006f15f773bb371542559")
        
        let productName = results[0].data["product_name"] as! String
        XCTAssertEqual(productName, "Skrrrrt Cropped Graphic Hoodie Light Grey")
        
        let price = results[0].data["sale_price"] as! Dictionary<String,String>
        
        let currency = price["currency"]
        XCTAssertEqual(currency, "SGD")
        
        let value = price["value"]
        XCTAssertEqual(value, "44.0")
    }
}

