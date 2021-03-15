//
//  ViProductSearchTest.swift
//  ViSearchSDKTests
//
//  Created by visenze on 8/3/21.
//

import XCTest
@testable import ViSearchSDK

class ViProductSearchTest: XCTestCase {
    
    private let appKey : String = ""
    private let placementId : Int = 1000
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
    
    func createSdk() -> ViProductSearch {
        let sdk = ViProductSearch.sharedInstance
        sdk.setUp(appKey: appKey, placementId: placementId, baseUrl:"https://search-dev.visenze.com")
        return sdk
    }
    
    func testSearchClientSBI() {
        let sdk = createSdk()
        var params = ViSearchByImageParam(imUrl: imageUrl)
        
        self.semaphore.wait()
        
        sdk.imageSearch(
            params: params!,
            successHandler: {
                (response: ViProductSearchResponse?) in
                self.imageId = response?.imageId
                self.semaphore.signal()
            },
            failureHandler: {
                (err : Error) in
                XCTFail(err.localizedDescription)
            }
        )
        
        self.semaphore.wait()
        
        params = ViSearchByImageParam(imId: self.imageId!)
        sdk.imageSearch(
            params: params!,
            successHandler: {
                (response: ViProductSearchResponse?) in
                self.semaphore.signal()
            },
            failureHandler: {
                (err : Error) in
                XCTFail(err.localizedDescription)
            }
        )
        
        self.semaphore.wait()
    }
    
    func testSearchClientVSR() {
        let sdk = createSdk()
        
    }
}

