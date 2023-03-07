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
    
    func testProductSearchRecPinExcludeResponse() {
        let urlResponse = URLResponse()
        
        let json: String = """
        {
            "reqid": "017a3bb0a050fb56218beb28b9e5ecf",
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
                    "pinned" : "false",
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
                }
               
            ],
            "excluded_pids" : ["p1" , "p2"],
            "strategy": {
                "id": 2,
                "name": "Model outfit",
                "algorithm": "STL"
            },
            "alt_limit": 5
        }

        """
        
        let data = json.data(using: .utf8)!
        
        let res = ViProductSearchResponse(response: urlResponse, data: data)
        
        let strategy = res.strategy!
        XCTAssertEqual(2, strategy.strategyId!)
        XCTAssertEqual("STL", strategy.algorithm!)
        
        XCTAssertEqual(2, res.excludedPids.count)
        XCTAssertEqual("p1", res.excludedPids[0])
        XCTAssertEqual("p2", res.excludedPids[1])

        XCTAssertFalse(res.result[0].pinned!)
    }
    
    func testProductSearchRecCtlSetBasedResponse() {
        let urlResponse = URLResponse()
        
        let json: String = """
        {
            "reqid": "017a3bb0a050fb56218beb28b9e5ecf",
            "status": "OK",
            "method": "product/recommendations",
            "page": 1,
            "limit": 10,
            "total": 2,
            "product_types": [],
            "result": [
                {
                  "product_id": "dress1",
                  "main_image_url": "http://test.com/img1.jpg",
                  "tags": {
                    "category": "dress",
                    "set_id": "set1"
                  },
                  "score": 0.9
                },
                {
                  "product_id": "shirt1",
                  "main_image_url": "http://test.com/img2.jpg",
                  "tags": {
                    "category": "shirt",
                    "set_id": "set1"
                  },
                  "score": 0.7
                },
                {
                  "product_id": "shoe2",
                  "main_image_url": "http://test.com/img2.jpg",
                  "tags": {
                    "category": "shoes",
                    "set_id": "set2"
                  },
                  "score": 0.8
                }
              ],
              "set_info": [
                {
                  "set_id": "set1",
                  "set_score": 1000,
                  "item_count": 2
                },
                {
                  "set_id": "set2",
                  "set_score": 900,
                  "item_count": 1
                }
              ]
        }

        """
        
        let data = json.data(using: .utf8)!
        
        let res = ViProductSearchResponse(response: urlResponse, data: data)
        
    
        XCTAssertEqual(3, res.result.count)
        let r1 = res.result[0]
        XCTAssertEqual("set1", r1.tags!["set_id"] as! String)
        XCTAssertEqual("dress", r1.tags!["category"] as! String)
    
        let r2 = res.result[1]
        XCTAssertEqual("set1", r2.tags!["set_id"] as! String)
        XCTAssertEqual("shirt", r2.tags!["category"] as! String)
        
        let r3 = res.result[2]
        XCTAssertEqual("set2", r3.tags!["set_id"] as! String)
        XCTAssertEqual("shoes", r3.tags!["category"] as! String)
    
        XCTAssertEqual(2, res.setInfoList.count)
        XCTAssertEqual("set1", res.setInfoList[0].setId)
        XCTAssertEqual(2, res.setInfoList[0].itemCount)
        
        XCTAssertTrue(res.setInfoList[0].setScore == 1000)
        XCTAssertEqual("set2", res.setInfoList[1].setId)
        XCTAssertTrue(res.setInfoList[1].setScore == 900)
        XCTAssertEqual(1, res.setInfoList[1].itemCount)

    }
    
    
    func testProductSearchRecBestImagesResponse() {
        let urlResponse = URLResponse()
        
        let json: String = """
        {
            "reqid": "01806a667776c6f8a31c28105fd99f",
            "status": "OK",
            "method": "product/recommendations",
            "page": 1,
            "limit": 10,
            "total": 2,
            "product_types": [],
            "result": [
                {
                  "product_id": "dress1",
                  "main_image_url": "http://test.com/img1.jpg",
                  "best_images" : [
                     {
                        "type" : "product",
                        "url" : "url11",
                        "index" : "0"
                     },
                     {
                        "type" : "outfit",
                        "url" : "url21",
                        "index" : "3"
                     }
                  ],
                  "tags": {
                    "category": "dress",
                    "set_id": "set1"
                  },
                  "score": 0.9
                }
                
              ],
              "set_info": [
                {
                  "set_id": "set1",
                  "set_score": 1000,
                  "item_count": 2
                },
                {
                  "set_id": "set2",
                  "set_score": 900,
                  "item_count": 1
                }
              ]
        }

        """
        
        let data = json.data(using: .utf8)!
        
        let res = ViProductSearchResponse(response: urlResponse, data: data)
    
        XCTAssertEqual(1, res.result.count)
        let r1 = res.result[0]
        XCTAssertEqual("set1", r1.tags!["set_id"] as! String)
        XCTAssertEqual("dress", r1.tags!["category"] as! String)
    
        let bestImages = res.result[0].bestImages
        XCTAssertEqual(2, bestImages.count)
        
        let b1 = bestImages[0]
        XCTAssertEqual("0", b1.index)
        XCTAssertEqual("product", b1.type)
        XCTAssertEqual("url11", b1.url)
        
        let b2 = bestImages[1]
        XCTAssertEqual("3", b2.index)
        XCTAssertEqual("outfit", b2.type)
        XCTAssertEqual("url21", b2.url)
    
        XCTAssertEqual(2, res.setInfoList.count)
        XCTAssertEqual("set1", res.setInfoList[0].setId)
        XCTAssertEqual(2, res.setInfoList[0].itemCount)
        
        XCTAssertTrue(res.setInfoList[0].setScore == 1000)
        XCTAssertEqual("set2", res.setInfoList[1].setId)
        XCTAssertTrue(res.setInfoList[1].setScore == 900)
        XCTAssertEqual(1, res.setInfoList[1].itemCount)

    }
    
    
}

