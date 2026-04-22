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

    // MARK: - MsCloud enum

    func testMsCloudValues() {
        XCTAssertEqual(MsCloud.aws.baseUrl,   "https://multisearch-aw.rezolve.com")
        XCTAssertEqual(MsCloud.azure.baseUrl, "https://multisearch-az.rezolve.com")
    }

    // MARK: - setUp(cloud:)

    func testSetUpWithCloudAWS() {
        let sdk = ViProductSearch()
        sdk.setUp(appKey: "TEST_KEY", placementId: 1, cloud: .aws)

        XCTAssertEqual(sdk.client?.baseUrl, ViProductSearch.AWS_URL)
        XCTAssertEqual(sdk.sbiEndpoint,                     ViProductSearch.SBI_ENDPOINT_NEW)
        XCTAssertEqual(sdk.vsrEndpoint,                     ViProductSearch.VSR_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchEndpoint,             ViProductSearch.MULTISEARCH_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchComplEndpoint,        ViProductSearch.MULTISEARCH_COMPL_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchOutfitEndpoint,       ViProductSearch.MULTISEARCH_OUTFIT_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchAutoCompleteEndpoint, ViProductSearch.MULTISEARCH_AUTOCOMPLETE_ENDPOINT_NEW)
    }

    func testSetUpWithCloudAzure() {
        let sdk = ViProductSearch()
        sdk.setUp(appKey: "TEST_KEY", placementId: 1, cloud: .azure)

        XCTAssertEqual(sdk.client?.baseUrl, ViProductSearch.AZURE_URL)
        XCTAssertEqual(sdk.sbiEndpoint,                     ViProductSearch.SBI_ENDPOINT_NEW)
        XCTAssertEqual(sdk.vsrEndpoint,                     ViProductSearch.VSR_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchEndpoint,             ViProductSearch.MULTISEARCH_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchComplEndpoint,        ViProductSearch.MULTISEARCH_COMPL_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchOutfitEndpoint,       ViProductSearch.MULTISEARCH_OUTFIT_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchAutoCompleteEndpoint, ViProductSearch.MULTISEARCH_AUTOCOMPLETE_ENDPOINT_NEW)
    }

    // MARK: - setUp(baseUrl:) domain detection

    func testSetUpLegacyBackwardCompat() {
        let sdk = ViProductSearch()
        sdk.setUp(appKey: "TEST_KEY", placementId: 1)

        XCTAssertEqual(sdk.client?.baseUrl, ViProductSearch.BASE_URL)
        XCTAssertEqual(sdk.sbiEndpoint,                     ViProductSearch.SBI_ENDPOINT)
        XCTAssertEqual(sdk.vsrEndpoint,                     ViProductSearch.VSR_ENDPOINT)
        XCTAssertEqual(sdk.multiSearchEndpoint,             ViProductSearch.MULTISEARCH_ENDPOINT)
        XCTAssertEqual(sdk.multiSearchComplEndpoint,        ViProductSearch.MULTISEARCH_COMPL_ENDPOINT)
        XCTAssertEqual(sdk.multiSearchOutfitEndpoint,       ViProductSearch.MULTISEARCH_OUTFIT_ENDPOINT)
        XCTAssertEqual(sdk.multiSearchAutoCompleteEndpoint, ViProductSearch.MULTISEARCH_AUTOCOMPLETE_ENDPOINT)
    }

    func testSetUpWithBaseUrlNewAwsDomain() {
        let sdk = ViProductSearch()
        sdk.setUp(appKey: "TEST_KEY", placementId: 1, baseUrl: ViProductSearch.AWS_URL)

        XCTAssertEqual(sdk.client?.baseUrl, ViProductSearch.AWS_URL)
        XCTAssertEqual(sdk.sbiEndpoint,                     ViProductSearch.SBI_ENDPOINT_NEW)
        XCTAssertEqual(sdk.vsrEndpoint,                     ViProductSearch.VSR_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchEndpoint,             ViProductSearch.MULTISEARCH_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchComplEndpoint,        ViProductSearch.MULTISEARCH_COMPL_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchOutfitEndpoint,       ViProductSearch.MULTISEARCH_OUTFIT_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchAutoCompleteEndpoint, ViProductSearch.MULTISEARCH_AUTOCOMPLETE_ENDPOINT_NEW)
    }

    func testSetUpWithBaseUrlNewAzureDomain() {
        let sdk = ViProductSearch()
        sdk.setUp(appKey: "TEST_KEY", placementId: 1, baseUrl: ViProductSearch.AZURE_URL)

        XCTAssertEqual(sdk.client?.baseUrl, ViProductSearch.AZURE_URL)
        XCTAssertEqual(sdk.sbiEndpoint,                     ViProductSearch.SBI_ENDPOINT_NEW)
        XCTAssertEqual(sdk.vsrEndpoint,                     ViProductSearch.VSR_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchEndpoint,             ViProductSearch.MULTISEARCH_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchComplEndpoint,        ViProductSearch.MULTISEARCH_COMPL_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchOutfitEndpoint,       ViProductSearch.MULTISEARCH_OUTFIT_ENDPOINT_NEW)
        XCTAssertEqual(sdk.multiSearchAutoCompleteEndpoint, ViProductSearch.MULTISEARCH_AUTOCOMPLETE_ENDPOINT_NEW)
    }

    func testSetUpWithBaseUrlLegacyDomain() {
        let sdk = ViProductSearch()
        sdk.setUp(appKey: "TEST_KEY", placementId: 1, baseUrl: "https://search-dev.visenze.com")

        XCTAssertEqual(sdk.sbiEndpoint,                     ViProductSearch.SBI_ENDPOINT)
        XCTAssertEqual(sdk.vsrEndpoint,                     ViProductSearch.VSR_ENDPOINT)
        XCTAssertEqual(sdk.multiSearchEndpoint,             ViProductSearch.MULTISEARCH_ENDPOINT)
        XCTAssertEqual(sdk.multiSearchComplEndpoint,        ViProductSearch.MULTISEARCH_COMPL_ENDPOINT)
        XCTAssertEqual(sdk.multiSearchOutfitEndpoint,       ViProductSearch.MULTISEARCH_OUTFIT_ENDPOINT)
        XCTAssertEqual(sdk.multiSearchAutoCompleteEndpoint, ViProductSearch.MULTISEARCH_AUTOCOMPLETE_ENDPOINT)
    }

}


