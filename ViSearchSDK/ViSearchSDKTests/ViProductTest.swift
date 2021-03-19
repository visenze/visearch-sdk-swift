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
        XCTAssertEqual(result!.productId, "POMELO2-AF-SG_b28d580ccf5dfd999d1006f15f773bb371542559")
        XCTAssertEqual(result!.mainImageUrl, "http://d3vhkxmeglg6u9.cloudfront.net/img/p/2/2/1/8/0/6/221806.jpg")
        
        let link = result!.data["link"] as! String
        XCTAssertEqual(link, "https://iprice.sg/r/p/?_id=b28d580ccf5dfd999d1006f15f773bb371542559")
        
        let productName = result!.data["product_name"] as! String
        XCTAssertEqual(productName, "Skrrrrt Cropped Graphic Hoodie Light Grey")
        
        let price = result!.data["sale_price"] as! Dictionary<String,String>
        
        let currency = price["currency"]
        XCTAssertEqual(currency, "SGD")
        
        let value = price["value"]
        XCTAssertEqual(value, "44.0")
    }
    
    func parseMethod(text: String) -> ViProduct? {
        do {
            let data = text.data(using: .utf8)!
            let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
            
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
            
            return item
        }
        catch {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Json response might be invalid. Error during processing:")
            print ("\(error)\n")
        }
        return nil
    }
}

