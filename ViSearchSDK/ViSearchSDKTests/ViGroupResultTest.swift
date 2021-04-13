//
//  ViGroupResultTest.swift
//  ViSearchSDKTests
//
//  Created by visenze on 19/3/21.
//

import XCTest
@testable import ViSearchSDK

class ViGroupResultTest: XCTestCase {
    
    private let RESPONSE: String = """
    [{
        "group_by_value": "Pomelo",
        "result": [
        {
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
        },
        {
            "product_id": "POMELO2-AF-SG_43d7a0fb6e12d1f1079e6efb38b9d392fa135cdd",
            "main_image_url": "http://d3vhkxmeglg6u9.cloudfront.net/img/p/1/6/2/3/2/1/162321.jpg",
            "data": {
                "link": "https://iprice.sg/r/p/?_id=43d7a0fb6e12d1f1079e6efb38b9d392fa135cdd",
                "product_name": "Premium Twisted Cold Shoulder Top Pink",
                "sale_price": {
                    "currency": "SGD",
                    "value": "54.0"
                }
            }
        }
        ]
    }]
    """;
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParse() {
        let groupObjects = ViProductSearchResponse.parseGroupResults(RESPONSE)
        
        XCTAssertEqual(groupObjects.isEmpty, false)
        XCTAssertNotNil(groupObjects[0])
        XCTAssertEqual(groupObjects[0].groupByValue, "Pomelo")
        XCTAssertEqual(groupObjects[0].results.count, 2)
        
        let result = groupObjects[0].results[1]
        
        XCTAssertEqual(result.productId, "POMELO2-AF-SG_43d7a0fb6e12d1f1079e6efb38b9d392fa135cdd")
        XCTAssertEqual(result.mainImageUrl, "http://d3vhkxmeglg6u9.cloudfront.net/img/p/1/6/2/3/2/1/162321.jpg")
        
        let data = result.data
        
        let link = data["link"] as! String
        XCTAssertEqual(link, "https://iprice.sg/r/p/?_id=43d7a0fb6e12d1f1079e6efb38b9d392fa135cdd")
        
        let productName = data["product_name"] as! String
        XCTAssertEqual(productName, "Premium Twisted Cold Shoulder Top Pink")
        
        let price = data["sale_price"] as! Dictionary<String,String>
        
        let currency = price["currency"]
        XCTAssertEqual(currency, "SGD")
        
        let value = price["value"]
        XCTAssertEqual(value, "54.0")
    }
}

