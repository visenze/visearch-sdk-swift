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
    
    private let STI_RESPONSE: String = """
    [{
        "id": "b0eedf870030ebb7ec637cd2641d0591",
        "category": "eyewear",
        "box": [
            54,
            55,
            200,
            200
        ],
        
        "total": 111,
        "result": [
            {
                "product_id": "pid1",
                "main_image_url": "http://test.jpg",
                "pinned" : "true",
                "data": {
                    "link": "https://liink.com",
                    "product_name": "test name",
                    "sale_price": {
                        "currency": "SGD",
                        "value": "43.0"
                    }
                },
                "vs_data" : {
                    "index_filter.product_tagging" : "others",
                    "detect" : "glass"
                }
            }
        ],
        "excluded_pids" : ["pid2", "pid3"],
        "facets" : [
            {
                "key": "category",
                "items" : [
                    {"value" : "Women > Women's Dresses"}
                ]
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
    
    func testParseSti() {
        let results = ViProductSearchResponse.parseObjectResults(STI_RESPONSE)
        
        XCTAssertEqual(results.isEmpty, false)
        XCTAssertNotNil(results[0])
        XCTAssertEqual(results[0].category, "eyewear")
        
        XCTAssertEqual(results[0].box!.x1, 54)
        XCTAssertEqual(results[0].box!.y1, 55)
        XCTAssertEqual(results[0].box!.x2, 200)
        XCTAssertEqual(results[0].box!.y2, 200)
        XCTAssertEqual(results[0].total, 111)
        XCTAssertEqual(results[0].result.count, 1)
        XCTAssertEqual(results[0].result[0].productId, "pid1")
        XCTAssertEqual(results[0].result[0].mainImageUrl, "http://test.jpg")
        
        let data = results[0].result[0].data
        
        let link = data["link"] as! String
        XCTAssertEqual(link, "https://liink.com")
        
        let productName = data["product_name"] as! String
        XCTAssertEqual(productName, "test name")
        
        let price = data["sale_price"] as! Dictionary<String,String>
        
        let currency = price["currency"]
        XCTAssertEqual(currency, "SGD")
        
        let value = price["value"]
        XCTAssertEqual(value, "43.0")
        
        let vsData = results[0].result[0].vsData
        XCTAssertEqual("others", vsData["index_filter.product_tagging"] as! String)
        XCTAssertEqual("glass", vsData["detect"] as! String)
        
        XCTAssertEqual(2, results[0].excludedPids.count)
        XCTAssertEqual("pid2", results[0].excludedPids[0])
        XCTAssertEqual("pid3", results[0].excludedPids[1])
        
    }
    
}
