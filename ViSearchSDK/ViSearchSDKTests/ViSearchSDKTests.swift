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
        
        ViProductSearch.sharedInstance.setUp(appKey: "", placementId: 1000, baseUrl: "https://search-dev.visenze.com")
        
        //let param = ViSearchByImageParam(imUrl: "https://cf.shopee.sg/file/e65789da4e612e63c79a4edf012adbdc")
        
        //let param = ViSearchByImageParam(imId: "20210325365b3b7e5b1fc8c02a8fa301646a86405abc9a0a892.jpg")
        
        let param = ViSearchByImageParam(image: getImageWithColor(color: UIColor.red, size: CGSize(width:2000, height:2000)) )
        
        param.box = ViBox(x1: 0, y1: 0, x2: 1000, y2: 1000)
        
        //param?.groupBy = "merchant_category"
        //param?.searchAllObjects = true
        param.attributesToGet = ["sku","brand_name","sale_date","merchant_category"]
        param.filters = ["merchant_category":"Clothing/Jackets/Denim"]
        
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
