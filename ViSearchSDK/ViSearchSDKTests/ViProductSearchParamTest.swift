//
//  ViProductSearchParamTest.swift
//  ViSearchSDKTests
//
//  Created by visenze on 8/3/21.
//

import XCTest
@testable import ViSearchSDK

class ViProductSearchParamTest: XCTestCase {
    public static let SBI_ENDPOINT = "https://search-dev.visenze.com/v1/product/search_by_image?";
    public static let VSR_ENDPOINT = "https://search-dev.visenze.com/v1/product/recommendations?";
    public static let PARAM_DESIRED_SIMPLE = "app_key=APP_KEY&placement_id=1";
    public static let PARAM_DESIRED_COMPLEX = "app_key=APP_KEY&placement_id=1&return_fields_mapping=true&score=true&text_filters=A%3AB&text_filters=C%3AD";
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBaseParams() -> Void {
        var params = ViBaseProductSearchParam()
        var dict = params.toDict()
        dict["app_key"] = "APP_KEY"
        dict["placement_id"] = "1"
        
        let serializer = ViRequestSerialization()
        
        XCTAssertEqual(
            ViProductSearchParamTest.PARAM_DESIRED_SIMPLE,
            serializer.generateQueryString(dict)
        )
        
        params = ViBaseProductSearchParam()
        params.returnFieldsMapping = true
        params.score = true
        params.textFilters = [
            "A":"B",
            "C":"D"
        ]
        dict = params.toDict()
        dict["app_key"] = "APP_KEY"
        dict["placement_id"] = "1"
        
        XCTAssertEqual(
            ViProductSearchParamTest.PARAM_DESIRED_COMPLEX,
            serializer.generateQueryString(dict)
        )
    }
    
    func testSearchByImageParameters() -> Void {
        XCTAssertNil(ViSearchByImageParam(imId: ""))
        XCTAssertNotNil(ViSearchByImageParam(imId: "SOME_IMAGE_ID"))
        XCTAssertNil(ViSearchByImageParam(imUrl: ""))
        XCTAssertNotNil(ViSearchByImageParam(imUrl: "SOME_URL"))
    }
    
    func testSearchByIdParameters() -> Void {
        XCTAssertNil(ViSearchByIdParam(productId: ""))
        XCTAssertNotNil(ViSearchByIdParam(productId: "PRODUCT_ID"))
    }
    
}


