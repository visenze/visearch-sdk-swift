//
//  ViProductObjectResultTest.swift
//  ViSearchSDKTests
//
//  Created by visenze on 19/3/21.
//

import XCTest
@testable import ViSearchSDK

class ViProductObjectResultTest: XCTestCase {
    
    private let RESPONSE: String = """
    [{
        "type": "top",
        "score": 0.683,
        "box": [
            32,
            183,
            862,
            1062
        ],
        "attributes": {},
        "total": 985,
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
        let results = ViProductSearchResponse.parseObjectResults(RESPONSE)
        
        XCTAssertEqual(results.isEmpty, false)
        XCTAssertNotNil(results[0])
        XCTAssertEqual(results[0].type, "top")
        XCTAssertEqual(results[0].score, 0.683)
        XCTAssertEqual(results[0].box!.x1, 32)
        XCTAssertEqual(results[0].box!.y1, 183)
        XCTAssertEqual(results[0].box!.x2, 862)
        XCTAssertEqual(results[0].box!.y2, 1062)
        XCTAssertEqual(results[0].total, 985)
        XCTAssertEqual(results[0].result.count, 1)
        XCTAssertEqual(results[0].result[0].productId, "POMELO2-AF-SG_b28d580ccf5dfd999d1006f15f773bb371542559")
        XCTAssertEqual(results[0].result[0].mainImageUrl, "http://d3vhkxmeglg6u9.cloudfront.net/img/p/2/2/1/8/0/6/221806.jpg")
        
        let data = results[0].result[0].data
        
        let link = data["link"] as! String
        XCTAssertEqual(link, "https://iprice.sg/r/p/?_id=b28d580ccf5dfd999d1006f15f773bb371542559")
        
        let productName = data["product_name"] as! String
        XCTAssertEqual(productName, "Skrrrrt Cropped Graphic Hoodie Light Grey")
        
        let price = data["sale_price"] as! Dictionary<String,String>
        
        let currency = price["currency"]
        XCTAssertEqual(currency, "SGD")
        
        let value = price["value"]
        XCTAssertEqual(value, "44.0")
    }
    
}
