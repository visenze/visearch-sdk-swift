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
    
    func testProductSearchRecResponse() {
        let urlResponse = URLResponse()
        
        let json: String = """
        {
            "reqid": "017a3bb0a050fb56218beb28b9e5ec",
            "status": "OK",
            "method": "product/recommendations",
            "page": 1,
            "limit": 10,
            "total": 2,
            "product_types": [],
            "result": [
                {
                    "product_id": "top-name-1",
                    "main_image_url": "https://localhost/top-name-1.jpg",
                    "data": {
                        "title": "top-name-001"
                    },
                    "tags": {
                        "category": "top"
                    },
                    "alternatives": [
                        {
                            "product_id": "top-name-2",
                            "main_image_url": "https://localhost/top-name-2.jpg",
                            "data": {
                                "title": "top-name-002"
                            }
                        },
                        {
                            "product_id": "top-name-3",
                            "main_image_url": "https://localhost/top-name-3.jpg",
                            "data": {
                                "title": "top-name-003"
                            }
                        }
                    ]
                },
                {
                    "product_id": "pants-name-1",
                    "main_image_url": "https://localhost/pants-name-1.jpg",
                    "data": {
                        "title": "pants-name-001"
                    },
                    "tags": {
                        "category": "pants"
                    },
                    "alternatives": [
                        {
                            "product_id": "pants-name-2",
                            "main_image_url": "https://localhost/pants-name-2.jpg",
                            "data": {
                                "title": "pants-name-002"
                            }
                        }
                    ]
                }
            ],
            "strategy": {
                "id": 1,
                "name": "Visually similar",
                "algorithm": "VSR"
            },
            "alt_limit": 5
        }

        """
        
        let data = json.data(using: .utf8)!
        
        let res = ViProductSearchResponse(response: urlResponse, data: data)
        
        let strategy = res.strategy!
        XCTAssertEqual(1, strategy.strategyId!)
        XCTAssertEqual("VSR", strategy.algorithm!)
        XCTAssertEqual("Visually similar", strategy.name!)
        XCTAssertEqual("top", res.result[0].tags!["category"] as? String)
        
        XCTAssertEqual(2, res.result[0].alternatives.count)
        XCTAssertEqual("top-name-2", res.result[0].alternatives[0].productId!)
        XCTAssertEqual("top-name-003", res.result[0].alternatives[1].data["title"] as! String)
        
    }
    
    func testExperimentResponse() {
        let urlResponse = URLResponse()
        
        let json: String = """
        {
            "reqid": "0180602bd8e119333d39b3f7a9fbf3",
            "status": "OK",
            "method": "product/recommendations",
            "page": 1,
            "limit": 10,
            "total": 1000,
            "product_types": [],
            "result": [
                
            ],
            "strategy": {
                "id": 215,
                "name": "test01",
                "algorithm": "VSR"
            },
            "experiment": {
                "experiment_id": 522,
                "variant_id": 2019,
                "variant_name": "a",
                "strategy_id": 3,
                "experiment_no_recommendation": true
            }
        }

        """
        
        let data = json.data(using: .utf8)!
        
        let res = ViProductSearchResponse(response: urlResponse, data: data)
        
        let experiment = res.experiment!
        XCTAssertEqual(3, experiment.strategyId!)
        XCTAssertEqual(522, experiment.experimentId!)
        XCTAssertEqual(2019, experiment.variantId!)
        XCTAssertEqual("a", experiment.variantName!)
        XCTAssertTrue(experiment.expNoRecommendation)
        XCTAssertTrue(res.experimentNoRecommendation())
        
    }
    
    
}

