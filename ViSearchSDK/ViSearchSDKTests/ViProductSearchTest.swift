//
//  ViProductSearchTest.swift
//  ViSearchSDKTests
//
//  Created by visenze on 8/3/21.
//

import XCTest
@testable import ViSearchSDK

class ViProductSearchTest: XCTestCase {
    
    private let sbiKey : String = ""
    private let vsrKey : String = ""
    private let sbiPlacement : Int = 1000
    private let vsrPlacement : Int = 1002
    private let imageUrl : String = "https://img.ltwebstatic.com/images2_pi/2019/09/09/15679978193855617200_thumbnail_900x1199.jpg"
    private let imageFile : String = ""
    
    private var imageId : String? = nil
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func createSdk(appKey: String, placement: Int) -> ViProductSearch {
        let sdk = ViProductSearch.sharedInstance
        sdk.setUp(appKey: appKey, placementId: placement, baseUrl:"https://search-dev.visenze.com")
        return sdk
    }
    
    func testSearch() {
        var productId : String = ""
        var sdk = createSdk(appKey: sbiKey, placement: sbiPlacement)
        var params = ViSearchByImageParam(imUrl: imageUrl)!
        
        self.semaphore.wait()
        
        sdk.imageSearch(
            params: params,
            successHandler: {
                (response: ViProductSearchResponse?) in
                self.imageId = response!.imageId
                if response!.result.count > 0 {
                    productId = response!.result[0].productId!
                }
                if response!.status == "fail" {
                    XCTFail("response status: fail")
                }
                self.semaphore.signal()
            },
            failureHandler: {
                (err : Error) in
                XCTFail(err.localizedDescription)
            }
        )
        
        self.semaphore.wait()
        
        params = ViSearchByImageParam(imId: self.imageId!)!
        sdk.imageSearch(
            params: params,
            successHandler: {
                (response: ViProductSearchResponse?) in
                if response!.status == "fail" {
                    XCTFail("response status: fail")
                }
                self.semaphore.signal()
            },
            failureHandler: {
                (err : Error) in
                XCTFail(err.localizedDescription)
            }
        )
        
        self.semaphore.wait()
        
        let vsrParam = ViSearchByIdParam(productId: productId)!
        sdk = createSdk(appKey: vsrKey, placement: vsrPlacement)
        sdk.visualSimilarSearch(
            params: vsrParam,
            successHandler: {
                (response: ViProductSearchResponse?) in
                if response!.status == "fail" {
                    XCTFail("response status: fail")
                }
                self.semaphore.signal()
            },
            failureHandler: {
                (err : Error) in
                XCTFail(err.localizedDescription)
            }
        )
        
        self.semaphore.wait()
    }
    
    func testSearchUsingFile() {
        let image = UIImage(contentsOfFile: imageFile)
        let sdk = createSdk(appKey: sbiKey, placement: sbiPlacement)
        let params = ViSearchByImageParam(image: image!)
        
        self.semaphore.wait()
        
        sdk.imageSearch(
            params: params,
            successHandler: {
                (response: ViProductSearchResponse?) in
                if response!.status == "fail" {
                    XCTFail("response status: fail")
                }
                self.semaphore.signal()
            },
            failureHandler: {
                (err : Error) in
                XCTFail(err.localizedDescription)
            }
        )
        
        self.semaphore.wait()
    }
}

