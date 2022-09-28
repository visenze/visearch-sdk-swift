//
//  ViSearchSDKTests.swift
//  ViSearchSDKTests
//
//  Created by Hung on 3/10/16.
//  Copyright © 2016 Hung. All rights reserved.
//

import XCTest
@testable import ViSearchSDK

class ViSearchSDKTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testRecommendationResponse() {
        
        let urlResponse = URLResponse()
        
        let json: String = """
        {
          "status": "OK",
          "method": "recommendations",
          "algorithm": "VSR",
          "error": [],
          "page": 1,
          "limit": 10,
          "total": 10,
          "result": [
            {
              "im_name": "top-name-1",
              "value_map": {
                "title": "top-name-001"
              },
              "tags": {
                "category": "top"
              },
              "alternatives": [
                {
                  "im_name": "top-name-2",
                  "value_map": {
                    "title": "top-name-002"
                  }
                },
                {
                  "im_name": "top-name-3",
                  "value_map": {
                    "title": "top-name-003"
                  }
                }
              ]
            }
          ],
          "reqid": "1156773933236717419"
        }
        """
        
        let data = json.data(using: .utf8)!
    
        let res = ViResponseData(response: urlResponse, data: data)
        
        XCTAssertEqual("VSR", res.algorithm!)
        XCTAssertEqual("recommendations", res.method)
        let product = res.result[0]
        XCTAssertEqual("top-name-1", product.im_name)
        XCTAssertEqual("top", product.tags!["category"] as! String )
        XCTAssertEqual(2, product.alternatives.count)
        XCTAssertEqual("top-name-2", product.alternatives[0].im_name)
        XCTAssertEqual("top-name-003", product.alternatives[1].metadataDict!["title"] as! String)
        
        
    }
    
    func testRecommendationResponseWithPinExclude() {
        
        let urlResponse = URLResponse()
        
        let json: String = """
        {
          "status": "OK",
          "method": "recommendations",
          "algorithm": "STL",
          "error": [],
          "page": 1,
          "limit": 3,
          "total": 1,
          "result": [
            {
              "im_name": "image_F01",
              "value_map": {
                "title": "image_F01"
              },
              "tags": {
                "category": "top"
              },
              "pinned" : "true",
              "alternatives": [
                {
                  "im_name": "image_bag_3",
                  "value_map": {
                    "title": "image_bag_3"
                  }
                }
              ]
            }
          ],
          "excluded_im_names" : ["im1", "im2"],
          "reqid": "1156773933236717418"
        }
        """
        
        let data = json.data(using: .utf8)!
    
        let res = ViResponseData(response: urlResponse, data: data)
        
        XCTAssertEqual("STL", res.algorithm!)
        let product = res.result[0]
        XCTAssertEqual("image_F01", product.im_name)
        XCTAssertEqual(1, product.alternatives.count)
        XCTAssertEqual("image_bag_3", product.alternatives[0].im_name)
        
        XCTAssertEqual(2, res.excludedImNames.count)
        XCTAssertEqual("im1", res.excludedImNames[0])
        XCTAssertEqual("im2", res.excludedImNames[1])
        
        XCTAssertTrue(product.pinned!)
    }
        
    /*
    func testVSR(){
        let expectation = self.expectation(description: "wait_for_response")
        
        ViProductSearch.sharedInstance.setUp(appKey: "", placementId: 1002, baseUrl: "https://search-dev.visenze.com")
        
        let param = ViSearchByIdParam(productId: "POMELO2-AF-SG_959d1d7d52dad7da611c7d5e062e041f59fba389")!
        
        param.attributesToGet = ["sku","brand_name","sale_date","merchant_category"]
        
        ViProductSearch.sharedInstance.searchById(params: param) { (data: ViProductSearchResponse?) in
            dump(data)
            expectation.fulfill()
        } failureHandler: { (err) in
            print ("error: \\(err.localizedDescription)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    
    func testSBI() {
        let expectation = self.expectation(description: "wait_for_response")
        
        ViProductSearch.sharedInstance.setUp(appKey: "", placementId: 1, baseUrl: "https://search.visenze.com")
        
        //let param = ViSearchByImageParam(imUrl: "https://cf.shopee.sg/file/e65789da4e612e63c79a4edf012adbdc")
        
        //let param = ViSearchByImageParam(imId: "20210325365b3b7e5b1fc8c02a8fa301646a86405abc9a0a892.jpg")
        
        let param = ViSearchByImageParam(image: getImageWithColor(color: UIColor.red, size: CGSize(width:2000, height:2000)) )
        
        //param.box = ViBox(x1: 0, y1: 0, x2: 1000, y2: 1000)
        
        //param?.groupBy = "merchant_category"
        param.searchAllObjects = true
        
        //param.attributesToGet = ["sku","brand_name","sale_date","merchant_category"]
        //param.filters = ["merchant_category":"Clothing/Jackets/Denim"]
        let p1 = ViPoint(x: 0, y: 0)
        let p2 = ViPoint(x: 100, y:100)
        
        param.points.append(p1)
        param.points.append(p2)
        
        
        ViProductSearch.sharedInstance.searchByImage(params: param) { (data: ViProductSearchResponse?) in
            dump(data)
            dump(param)
            expectation.fulfill()
        } failureHandler: { (err) in
            print ("error: \\(err.localizedDescription)")
            expectation.fulfill()
        }

        
        waitForExpectations(timeout: 30, handler: nil)
    }

    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x:0, y:0, width:size.width, height:size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
     */
}
