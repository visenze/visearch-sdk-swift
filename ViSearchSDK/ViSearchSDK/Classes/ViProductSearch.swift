//
//  ViProductSearch.swift
//  ViSearchSDK
//
//  Created by visenze on 5/3/21.
//

import Foundation
import ViSenzeAnalytics

/// Singleton/Shared instance wrapper for various APIs
open class ViProductSearch : NSObject {
    
    public static let BASE_URL = "https://search.visenze.com"
    public static let SBI_ENDPOINT = "/v1/product/search_by_image"
    public static let VSR_ENDPOINT = "/v1/product/search_by_id"
    
    public static let sharedInstance = ViProductSearch();
    
    /// App Key for search-only access
    private var appKey : String? = nil
    
    /// Placement ID
    private var placementId : Int? = nil
    
    /// HTTP client gateway/wrapper
    private var client : ViProductSearchClient? = nil
    
    private override init() {
        super.init()
    }
    
    /// Set up the SDK with the proper authentications, needs to be called first prior to any other SDK
    /// functions
    public func setUp(appKey:String, placementId:Int) -> Void {
        self.appKey = appKey
        self.placementId = placementId
        if client == nil {
            client = ViProductSearchClient(baseUrl: ViProductSearch.BASE_URL, appKey: self.appKey!)
        }
    }
    
    /// Set up the SDK with the proper authentications, needs to be called first prior to any other SDK
    /// functions
    public func setUp(appKey:String, placementId:Int, baseUrl:String) -> Void {
        self.appKey = appKey
        self.placementId = placementId
        if client == nil {
            client = ViProductSearchClient(baseUrl: baseUrl, appKey: self.appKey!)
        }
    }
    
    /// Returns a tracker
    public func newTracker(forCn: Bool) -> ViSenzeTracker {
        return ViSearch.sharedInstance.newTracker(
            code: "\(appKey!):\(placementId!)",
            forCn: forCn
        )
    }
    
    /// API for Search by Image
    @discardableResult
    public func imageSearch(
        params:ViSearchByImageParam,
        successHandler: @escaping ViProductSearchClient.ProductSearchSuccess,
        failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> URLSessionTask {
        
        var parameters = addAuth(dict: params.toDict())
        parameters = addAnalytics(dict: parameters)
        return client!.post(
            path: ViProductSearch.SBI_ENDPOINT,
            params: parameters,
            imageData: params.getImageData(),
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }
    
    /// API for Search By ID
    @discardableResult
    public func visualSimilarSearch(
        params:ViSearchByIdParam,
        successHandler: @escaping ViProductSearchClient.ProductSearchSuccess,
        failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> URLSessionTask {
        
        var parameters = addAuth(dict: params.toDict())
        parameters = addAnalytics(dict: parameters)
        return client!.get(
            path: ViProductSearch.VSR_ENDPOINT + "/" + String(params.productId!),
            params: parameters,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }
    
    /// Internally appends the authentication key (which is App Key and Placement ID) to the param map
    private func addAuth(dict:[String:Any]) -> [String:Any] {
        var result = dict
        if let k = appKey{
            result["app_key"] = k
        }
        if let i = placementId {
            result["placement_id"] = String(i)
        }
        return result
    }
    
    /// Fills in all automatically detected Analytics fields that are not yet specified
    private func addAnalytics(dict:[String:Any]) -> [String:Any] {
        var result = dict
        
        let sessionManager = VaSessionManager.sharedInstance
        let deviceData = VaDeviceData.sharedInstance
        
        if result["va_uid"] == nil {
            result["va_uid"] = sessionManager.getUid()
        }
        
        if result["va_sid"] == nil {
            result["va_sid"] = sessionManager.getSessionId()
        }
        
        if result["va_sdk"] == nil {
            result["va_sdk"] = deviceData.sdk
        }
        
        if result["va_sdk_version"] == nil {
            result["va_sdk_version"] = deviceData.sdkVersion
        }
        
        if result["va_os"] == nil {
            result["va_os"] = deviceData.os
        }
        
        if result["va_osv"] == nil {
            result["va_osv"] = deviceData.osv
        }
        
        if result["va_device_brand"] == nil {
            result["va_device_brand"] = deviceData.deviceBrand
        }
        
        if result["va_device_model"] == nil {
            result["va_device_model"] = deviceData.deviceModel
        }
        
        if result["va_app_bundle_id"] == nil {
            result["va_app_bundle_id"] = deviceData.appBundleId
        }
        
        if result["va_app_name"] == nil {
            result["va_app_name"] = deviceData.appName
        }
        
        if result["va_app_version"] == nil {
            result["va_app_version"] = deviceData.appVersion
        }
        
        return result
    }
}

