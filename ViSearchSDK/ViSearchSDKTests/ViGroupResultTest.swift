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
    {
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
    }
    """;
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParse() {
        let groupObject = parseMethod(text: RESPONSE)
        
        XCTAssertNotNil(groupObject)
        XCTAssertEqual(groupObject!.groupByValue, "Pomelo")
        XCTAssertEqual(groupObject!.results.count, 2)
        
        let result = groupObject!.results[1]
        
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
    
    func parseMethod(text: String) -> ViGroupResult? {
        do {
            let data = text.data(using: .utf8)!
            let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
            
            let group = dict["group_by_value"] as! String
            
            let object = ViGroupResult(group: group)!
            
            if let res = dict["result"] as? [Any] {
                object.results = [ViProduct]()
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
                        object.results.append(item)
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

