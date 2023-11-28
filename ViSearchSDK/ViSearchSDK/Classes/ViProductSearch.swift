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
    public static let SBI_ENDPOINT = "v1/product/search_by_image"
    public static let VSR_ENDPOINT = "v1/product/recommendations"
    public static let MULTISEARCH_ENDPOINT = "v1/product/multisearch"
    public static let MULTISEARCH_AUTOCOMPLETE_ENDPOINT = "v1/product/multisearch/autocomplete"
    
    
    public static let sharedInstance = ViProductSearch();
    
    /// App Key for search-only access
    private var appKey : String? = nil
    
    /// Placement ID
    private var placementId : Int? = nil
    
    public var client : ViProductSearchClient? = nil
    
    /// Set up the SDK with the proper authentications, needs to be called first prior to any other SDK
    /// functions
    ///
    /// - parameter appKey: App key
    /// - parameter placementId: Placement ID
    public func setUp(appKey:String, placementId:Int) -> Void {
        setUp(appKey: appKey, placementId: placementId, baseUrl: ViProductSearch.BASE_URL)
    }
    
    /// Set up the SDK with the proper authentications, needs to be called first prior to any other SDK
    /// functions
    ///
    /// - parameter appKey: App key
    /// - parameter placementId: Placement ID
    /// - parameter baseUrl: Overrides the default BASE_URL to call API from
    public func setUp(appKey:String, placementId:Int, baseUrl:String) -> Void {
        self.appKey = appKey
        self.placementId = placementId
        self.client = ViProductSearchClient(baseUrl: baseUrl, appKey: self.appKey!)
    }
    
    public func newTracker() -> ViSenzeTracker {
        return ViSearch.sharedInstance.newTracker(
            code: "\(appKey!):\(placementId!)",
            forCn: false
        )
    }
    
    /// Returns a tracker meant for ProductSearch
    ///
    /// - parameter forCn: If the tracker is meant for cn
    ///
    /// - returns: ViSenzeTracker
    public func newTracker(forCn: Bool) -> ViSenzeTracker {
        return ViSearch.sharedInstance.newTracker(
            code: "\(appKey!):\(placementId!)",
            forCn: forCn
        )
    }
    
    /// API for Search by Image, it is non-blocking (async func), need to wait for task to end or either
    /// handlers to execute
    ///
    /// - parameter params: Parameters to pass to the API request
    /// - parameter successHandler: Callback function for successful request
    /// - parameter failureHandler: Callback function for failed request
    ///
    /// - returns: URLSessionTask
    @discardableResult
    public func searchByImage(
        params:ViSearchByImageParam,
        successHandler: @escaping ViProductSearchClient.ProductSearchSuccess,
        failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> URLSessionTask {
        
        // important: this method must be before params.toDict
        // this will resize image and generate the resized box
        let imageData = params.getCompressedImageData()
        
        var parameters = addAuth(dict: params.toDict())
        parameters = addAnalytics(dict: parameters)
        return client!.post(
            path: ViProductSearch.SBI_ENDPOINT,
            params: parameters,
            imageData: imageData,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }
    
    @discardableResult
    public func multiSearch(
        params:ViSearchByImageParam,
        successHandler: @escaping ViProductSearchClient.ProductSearchSuccess,
        failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> URLSessionTask {
        
        // important: this method must be before params.toDict
        // this will resize image and generate the resized box
        let imageData = params.getCompressedImageData()
        
        var parameters = addAuth(dict: params.toDict())
        parameters = addAnalytics(dict: parameters)
        return client!.post(
            path: ViProductSearch.MULTISEARCH_ENDPOINT,
            params: parameters,
            imageData: imageData,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }
    
    @discardableResult
    public func multiSearchAutoComplete(
        params:ViSearchByImageParam,
        successHandler: @escaping ViProductSearchClient.AutoCompleteSuccess,
        failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> URLSessionTask {
        
        // important: this method must be before params.toDict
        // this will resize image and generate the resized box
        let imageData = params.getCompressedImageData()
        
        var parameters = addAuth(dict: params.toDict())
        parameters = addAnalytics(dict: parameters)
        return client!.autoCompletePost(
            path: ViProductSearch.MULTISEARCH_AUTOCOMPLETE_ENDPOINT,
            params: parameters,
            imageData: imageData,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }
    
    
    /// API for Search By ID, it is non-blocking (async func), need to wait for task to end or either
    /// handlers to execute
    ///
    /// - parameter params: Parameters to pass to the API request
    /// - parameter successHandler: Callback function for successful request
    /// - parameter failureHandler: Callback function for failed request
    ///
    /// - returns: URLSessionTask
    @discardableResult
    public func searchById(
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
    
    /// return generated uid (va_uid) string for Analytics
    public func getUid() -> String {
        return VaSessionManager.sharedInstance.getUid()
    }
    
    /// return session ID
    public func getSid() -> String {
        return VaSessionManager.sharedInstance.getSessionId()
    }
    
    /// Internally appends the authentication key (which is App Key and Placement ID) to the param map
    ///
    /// - parameter dict: Dictionary to append authentication fields to
    ///
    /// - returns: A dictionary copy of the param "dict" with additional authentication fields
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
    ///
    /// - parameter dict: Dictionary to append analytics fields to
    ///
    /// - returns: A dictionary copy of the param "dict" with additional analytics fields
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

