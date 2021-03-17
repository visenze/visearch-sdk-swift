//
//  ViProductSearchTest.swift
//  ViSearchSDKTests
//
//  Created by visenze on 8/3/21.
//

import XCTest
@testable import ViSearchSDK

class ViProductSearchTest: XCTestCase {
    
    private let sbiKey      : String = ""
    private let vsrKey      : String = ""
    private let sbiPlacement: Int = 1000
    private let vsrPlacement: Int = 1002
    private let imageUrl    : String = "https://img.ltwebstatic.com/images2_pi/2019/09/09/15679978193855617200_thumbnail_900x1199.jpg"
    private let imageFile   : String = ""
    
    private var imageId     : String? = nil
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    private func createSdk(appKey: String, placement: Int) -> ViProductSearch {
        let sdk = ViProductSearch.sharedInstance
        sdk.setUp(appKey: appKey, placementId: placement, baseUrl: "https://search-dev.visenze.com")
        return sdk
    }
    
    private func getCatalogFields(response: ViProductSearchResponse) -> [String] {
        return Array(response.catalogFieldsMapping.values)
    }
    
    private func verifyResponse(response: ViProductSearchResponse?) -> Void {
        if response == nil || response!.status == "fail" {
            XCTFail("response failure")
        }
    }
    
    private func onRequestFailure(err: Error) -> Void {
        XCTFail(err.localizedDescription)
    }
    
    private func runSearchImage(sdk: ViProductSearch,
                                params: ViSearchByImageParam,
                                imUrl: String, imFile: String,
                                successUrlCallback: @escaping ViProductSearchClient.ProductSearchSuccess,
                                successFileCallback: @escaping ViProductSearchClient.ProductSearchSuccess) {
        
        self.semaphore.wait()
        
        // by Image URL - imUrl
        params.imUrl = imUrl
        params.image = nil
        
        sdk.imageSearch(
            params: params,
            successHandler: { (response: ViProductSearchResponse?) in
                self.verifyResponse(response: response)
                successUrlCallback(response)
                self.semaphore.signal()
            },
            failureHandler: self.onRequestFailure
        )
        
        self.semaphore.wait()
        
        // by Image File - image
        params.imUrl = nil
        params.image = UIImage(contentsOfFile: imFile)
        
        sdk.imageSearch(
            params: params,
            successHandler: { (response: ViProductSearchResponse?) in
                self.verifyResponse(response: response)
                successFileCallback(response)
                self.semaphore.signal()
            },
            failureHandler: self.onRequestFailure
        )
        
        self.semaphore.wait()
    }
    
    public func testSearchByImageFacets() {
        if sbiKey.isEmpty {
             return
        }
        
        let sdk = createSdk(appKey: sbiKey, placement: sbiPlacement)
        let params = ViSearchByImageParam(imUrl: imageUrl)!
        // look into catalogFieldsMapping to know what values you can use
        // params.returnFieldsMapping = true
        params.facets = ["brand_name", "merchant_category"]
        params.facetsLimit = 10
        params.facetsShowCount = true
        
        runSearchImage(
            sdk: sdk, params: params, imUrl: imageUrl, imFile: imageFile,
            successUrlCallback: {
                (response: ViProductSearchResponse?) in
                if response!.facets.count != params.facets.count {
                    XCTFail("Facets count mismatch")
                }
            },
            successFileCallback: {
                (response: ViProductSearchResponse?) in
                if response!.facets.count != params.facets.count {
                    XCTFail("Facets count mismatch")
                }
            }
        )
    }
    
    public func testSearchByImageObjects() {
        if sbiKey.isEmpty {
             return
        }
        
        let sdk = createSdk(appKey: sbiKey, placement: sbiPlacement)
        let params = ViSearchByImageParam(imUrl: imageUrl)!
        
        params.searchAllObjects = true
        params.detectionLimit = 10
        params.detection = "all"
        
        runSearchImage(
            sdk: sdk, params: params, imUrl: imageUrl, imFile: imageFile,
            successUrlCallback: {
                (response: ViProductSearchResponse?) in
                if response!.objects.count == 0 {
                    XCTFail("Failed to search via all objects")
                }
            },
            successFileCallback: {
                (response: ViProductSearchResponse?) in
                if response!.objects.count == 0 {
                    XCTFail("Failed to search via all objects")
                }
            }
        )
    }
    
    public func testSearchByImageGroups() {
        if sbiKey.isEmpty {
             return
        }
        
        let sdk = createSdk(appKey: sbiKey, placement: sbiPlacement)
        let params = ViSearchByImageParam(imUrl: imageUrl)!
        // look into catalogFieldsMapping to know what values you can use
        // params.returnFieldsMapping = true
        params.groupBy = "brand_name"
        params.groupLimit = 10
        
        runSearchImage(
            sdk: sdk, params: params, imUrl: imageUrl, imFile: imageFile,
            successUrlCallback: {
                (response: ViProductSearchResponse?) in
                if response!.groupResults.count == 0 {
                    XCTFail("Failed search by group objects")
                }
            },
            successFileCallback: {
                (response: ViProductSearchResponse?) in
                if response!.groupResults.count == 0 {
                    XCTFail("Failed search by group objects")
                }
            }
        )
    }
    
    
    
}

