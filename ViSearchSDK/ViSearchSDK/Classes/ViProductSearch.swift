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
    
    public static let BASE_URL = "https://search.visenze.com/v1"
    public static let API_ENDPOINT = "similar-products"
    
    public static let sharedInstance = ViProductSearch();
    
    /// App Key for search-only access
    private var appKey : String? = nil
    
    /// Placement ID
    private var placementId : Int? = nil
    
    /// HTTP client gateway/wrapper
    private var client : ViProductSearchClient? = nil
    
    /// Set up the SDK with the proper authentications, needs to be called first prior to any other SDK
    /// functions
    public func setUp(appKey:String, placementId:Int) -> Void {
        self.appKey = appKey
        self.placementId = placementId
        
        if client == nil {
            client = ViProductSearchClient(baseUrl: ViProductSearch.BASE_URL, appKey: self.appKey!)
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
    public func imageSearch(params:ViSearchByImageParam,
                            successHandler: @escaping ViProductSearchClient.ProductSearchSuccess,
                            failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> Void {
        client?.post(
            path: ViProductSearch.API_ENDPOINT,
            params: addAuthToDict(dict: params.toDict()),
            imageData: params.getImageData(),
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }
    
    /// API for Search By ID
    public func visualSimilarSearch(params:ViSearchByIdParam,
                                    successHandler: @escaping ViProductSearchClient.ProductSearchSuccess,
                                    failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> Void {
        client?.get(
            path: ViProductSearch.API_ENDPOINT + "/" + String(params.productId!),
            params: addAuthToDict(dict: params.toDict()),
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }
    
    /// Internally appends the authentication key (which is App Key and Placement ID) to the param map
    private func addAuthToDict(dict:[String:Any]) -> [String:Any] {
        var result = dict
        
        if let k = appKey{
            result["app_key"] = k
        }
        
        if let i = placementId {
            result["placement_id"] = String(i)
        }
        
        return result
    }
    
}

