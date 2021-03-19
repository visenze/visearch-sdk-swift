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
    {
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
    }
    """;
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParse() {
        
        let result = parseMethod(text: RESPONSE)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.type, "top")
        XCTAssertEqual(result!.score, 0.683)
        XCTAssertEqual(result!.box!.x1, 32)
        XCTAssertEqual(result!.box!.y1, 183)
        XCTAssertEqual(result!.box!.x2, 862)
        XCTAssertEqual(result!.box!.y2, 1062)
        XCTAssertEqual(result!.total, 985)
        XCTAssertEqual(result!.result.count, 1)
        XCTAssertEqual(result!.result[0].productId, "POMELO2-AF-SG_b28d580ccf5dfd999d1006f15f773bb371542559")
        XCTAssertEqual(result!.result[0].mainImageUrl, "http://d3vhkxmeglg6u9.cloudfront.net/img/p/2/2/1/8/0/6/221806.jpg")
        
        let data = result!.result[0].data
        
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
    
    func parseMethod(text: String) -> ViProductObjectResult? {
        do {
            let data = text.data(using: .utf8)!
            let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
            
            let object = ViProductObjectResult()
            
            if let type = dict["type"] as? String {
                object.type = type
            }
            
            if let score = dict["score"] as? Double {
                object.score = score
            }
            
            if let box = dict["box"] as? [Int] {
                if box.count >= 4 {
                    object.box = ViBox(x1: box[0], y1: box[1], x2: box[2], y2: box[3])
                }
            }
            
            if let attributes = dict["attributes"] as? [String:Any] {
                object.attributes = attributes
            }
            
            if let total = dict["total"] as? Int {
                object.total = total
            }
            
            if let res = dict["result"] as? [Any] {
                object.result = [ViProduct]()
                for jsonItem in res {
                    if let dict = jsonItem as? [String:Any] {
                        
                        let item = ViProduct()
                        
                        if let productId = dict["product_id"] as? String {
                            item.productId = productId
                        }
                        
                        if let mainImageUrl = dict["main_image_url"] as? String {
                            item.mainImageUrl = mainImageUrl
                        }
                        
                        if let data = dict["data"] as? [String:Any] {
                            item.data = data
                        }
                        
                        if let score = dict["score"] as? Double {
                            item.score = score
                        }
                        
                        if let imageS3Url = dict["image_s3_url"] as? String {
                            item.imageS3Url = imageS3Url
                        }
                        
                        if let detect = dict["detect"] as? String {
                            item.detect = detect
                        }
                        
                        if let keyword = dict["keyword"] as? String {
                            item.keyword = keyword
                        }
                        
                        if let box = dict["box"] as? [Int] {
                            if box.count >= 4 {
                                item.box = ViBox(x1: box[0], y1: box[1], x2: box[2], y2: box[3])
                            }
                        }
                        object.result.append(item)
                    }
                }
            }
            
            return object
        }
        catch {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Json response might be invalid. Error during processing:")
            print ("\(error)\n")
        }
        return nil
    }
    
}
