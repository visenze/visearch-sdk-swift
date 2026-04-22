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

    // MARK: - Base URL constants

    /// Legacy default base URL (Azure hosted).
    public static let BASE_URL  = "https://multimodal.search.rezolve.com"

    /// New AWS-specific base URL.
    public static let AWS_URL   = "https://multisearch-aw.rezolve.com"

    /// New Azure-specific base URL.
    public static let AZURE_URL = "https://multisearch-az.rezolve.com"

    // MARK: - Legacy endpoint paths (used with BASE_URL)

    public static let SBI_ENDPOINT                      = "v1/product/search_by_image"
    public static let VSR_ENDPOINT                      = "v1/product/recommendations"
    public static let MULTISEARCH_ENDPOINT              = "v1/product/multisearch"
    public static let MULTISEARCH_AUTOCOMPLETE_ENDPOINT = "v1/product/multisearch/autocomplete"
    public static let MULTISEARCH_COMPL_ENDPOINT        = "v1/product/multisearch/complementary"
    public static let MULTISEARCH_OUTFIT_ENDPOINT       = "v1/product/multisearch/outfit-recommendations"

    // MARK: - New endpoint paths (used with AWS_URL / AZURE_URL)

    public static let SBI_ENDPOINT_NEW                      = "v1/visearch/search_by_image"
    public static let VSR_ENDPOINT_NEW                      = "v1/visearch/recommendations"
    public static let MULTISEARCH_ENDPOINT_NEW              = "v1/search"
    public static let MULTISEARCH_AUTOCOMPLETE_ENDPOINT_NEW = "v1/autocomplete"
    public static let MULTISEARCH_COMPL_ENDPOINT_NEW        = "v1/search/complementary"
    public static let MULTISEARCH_OUTFIT_ENDPOINT_NEW       = "v1/search/outfit-recommendations"

    // MARK: - Shared instance

    public static let sharedInstance = ViProductSearch()

    // MARK: - Private state

    /// App Key for search-only access
    private var appKey      : String? = nil

    /// Placement ID
    private var placementId : Int?    = nil

    public var client : ViProductSearchClient? = nil

    // Active endpoint paths — default to legacy values; overwritten by setUp(cloud:)
    // and by setUp(baseUrl:) when a new-domain URL is detected.
    var sbiEndpoint                     = ViProductSearch.SBI_ENDPOINT
    var vsrEndpoint                     = ViProductSearch.VSR_ENDPOINT
    var multiSearchEndpoint             = ViProductSearch.MULTISEARCH_ENDPOINT
    var multiSearchAutoCompleteEndpoint = ViProductSearch.MULTISEARCH_AUTOCOMPLETE_ENDPOINT
    var multiSearchComplEndpoint        = ViProductSearch.MULTISEARCH_COMPL_ENDPOINT
    var multiSearchOutfitEndpoint       = ViProductSearch.MULTISEARCH_OUTFIT_ENDPOINT

    // MARK: - Setup

    /// Set up for the new cloud-specific domains.
    ///
    /// - parameter appKey: App key
    /// - parameter placementId: Placement ID
    /// - parameter cloud: Cloud deployment target (.aws or .azure)
    public func setUp(appKey: String, placementId: Int, cloud: MsCloud) {
        self.appKey      = appKey
        self.placementId = placementId
        self.client      = ViProductSearchClient(baseUrl: cloud.baseUrl, appKey: appKey)

        sbiEndpoint                     = ViProductSearch.SBI_ENDPOINT_NEW
        vsrEndpoint                     = ViProductSearch.VSR_ENDPOINT_NEW
        multiSearchEndpoint             = ViProductSearch.MULTISEARCH_ENDPOINT_NEW
        multiSearchAutoCompleteEndpoint = ViProductSearch.MULTISEARCH_AUTOCOMPLETE_ENDPOINT_NEW
        multiSearchComplEndpoint        = ViProductSearch.MULTISEARCH_COMPL_ENDPOINT_NEW
        multiSearchOutfitEndpoint       = ViProductSearch.MULTISEARCH_OUTFIT_ENDPOINT_NEW
    }

    /// Set up using the legacy default base URL. Kept for backward compatibility.
    ///
    /// - parameter appKey: App key
    /// - parameter placementId: Placement ID
    public func setUp(appKey: String, placementId: Int) {
        setUp(appKey: appKey, placementId: placementId, baseUrl: ViProductSearch.BASE_URL)
    }

    /// Set up with an explicit base URL. Kept for backward compatibility.
    /// Automatically selects new endpoint paths when a new-domain URL is detected.
    ///
    /// - parameter appKey: App key
    /// - parameter placementId: Placement ID
    /// - parameter baseUrl: Overrides the default BASE_URL to call API from
    public func setUp(appKey: String, placementId: Int, baseUrl: String) {
        self.appKey      = appKey
        self.placementId = placementId
        self.client      = ViProductSearchClient(baseUrl: baseUrl, appKey: appKey)

        if ViProductSearch.isNewDomain(baseUrl) {
            sbiEndpoint                     = ViProductSearch.SBI_ENDPOINT_NEW
            vsrEndpoint                     = ViProductSearch.VSR_ENDPOINT_NEW
            multiSearchEndpoint             = ViProductSearch.MULTISEARCH_ENDPOINT_NEW
            multiSearchAutoCompleteEndpoint = ViProductSearch.MULTISEARCH_AUTOCOMPLETE_ENDPOINT_NEW
            multiSearchComplEndpoint        = ViProductSearch.MULTISEARCH_COMPL_ENDPOINT_NEW
            multiSearchOutfitEndpoint       = ViProductSearch.MULTISEARCH_OUTFIT_ENDPOINT_NEW
        } else {
            sbiEndpoint                     = ViProductSearch.SBI_ENDPOINT
            vsrEndpoint                     = ViProductSearch.VSR_ENDPOINT
            multiSearchEndpoint             = ViProductSearch.MULTISEARCH_ENDPOINT
            multiSearchAutoCompleteEndpoint = ViProductSearch.MULTISEARCH_AUTOCOMPLETE_ENDPOINT
            multiSearchComplEndpoint        = ViProductSearch.MULTISEARCH_COMPL_ENDPOINT
            multiSearchOutfitEndpoint       = ViProductSearch.MULTISEARCH_OUTFIT_ENDPOINT
        }
    }

    /// Returns true if baseUrl matches one of the new cloud-specific domains.
    private static func isNewDomain(_ baseUrl: String) -> Bool {
        return baseUrl.contains("multisearch-aw.rezolve.com")
            || baseUrl.contains("multisearch-az.rezolve.com")
    }

    // MARK: - Tracker

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

    // MARK: - API calls

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
        params: ViSearchByImageParam,
        successHandler: @escaping ViProductSearchClient.ProductSearchSuccess,
        failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> URLSessionTask {

        // important: this method must be before params.toDict
        // this will resize image and generate the resized box
        let imageData = params.getCompressedImageData()

        var parameters = addAuth(dict: params.toDict())
        parameters = addAnalytics(dict: parameters)
        return client!.post(
            path: sbiEndpoint,
            params: parameters,
            imageData: imageData,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }

    @discardableResult
    public func multiSearch(
        params: ViSearchByImageParam,
        successHandler: @escaping ViProductSearchClient.ProductSearchSuccess,
        failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> URLSessionTask {

        // important: this method must be before params.toDict
        // this will resize image and generate the resized box
        let imageData = params.getCompressedImageData()

        var parameters = addAuth(dict: params.toDict())
        parameters = addAnalytics(dict: parameters)
        return client!.post(
            path: multiSearchEndpoint,
            params: parameters,
            imageData: imageData,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }

    @discardableResult
    public func multiSearchComplementary(
        params: ViSearchByImageParam,
        successHandler: @escaping ViProductSearchClient.ProductSearchSuccess,
        failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> URLSessionTask {

        // important: this method must be before params.toDict
        // this will resize image and generate the resized box
        let imageData = params.getCompressedImageData()

        var parameters = addAuth(dict: params.toDict())
        parameters = addAnalytics(dict: parameters)
        return client!.post(
            path: multiSearchComplEndpoint,
            params: parameters,
            imageData: imageData,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }

    @discardableResult
    public func multiSearchOutfitRec(
        params: ViSearchByImageParam,
        successHandler: @escaping ViProductSearchClient.ProductSearchSuccess,
        failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> URLSessionTask {

        // important: this method must be before params.toDict
        // this will resize image and generate the resized box
        let imageData = params.getCompressedImageData()

        var parameters = addAuth(dict: params.toDict())
        parameters = addAnalytics(dict: parameters)
        return client!.post(
            path: multiSearchOutfitEndpoint,
            params: parameters,
            imageData: imageData,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }

    @discardableResult
    public func multiSearchAutoComplete(
        params: ViSearchByImageParam,
        successHandler: @escaping ViProductSearchClient.AutoCompleteSuccess,
        failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> URLSessionTask {

        // important: this method must be before params.toDict
        // this will resize image and generate the resized box
        let imageData = params.getCompressedImageData()

        var parameters = addAuth(dict: params.toDict())
        parameters = addAnalytics(dict: parameters)
        return client!.autoCompletePost(
            path: multiSearchAutoCompleteEndpoint,
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
        params: ViSearchByIdParam,
        successHandler: @escaping ViProductSearchClient.ProductSearchSuccess,
        failureHandler: @escaping ViProductSearchClient.ProductSearchFailure) -> URLSessionTask {

        var parameters = addAuth(dict: params.toDict())
        parameters = addAnalytics(dict: parameters)
        return client!.get(
            path: vsrEndpoint + "/" + String(params.productId!),
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

    // MARK: - Private helpers

    /// Internally appends the authentication key (which is App Key and Placement ID) to the param map
    ///
    /// - parameter dict: Dictionary to append authentication fields to
    ///
    /// - returns: A dictionary copy of the param "dict" with additional authentication fields
    private func addAuth(dict: [String: Any]) -> [String: Any] {
        var result = dict
        if let k = appKey {
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
    private func addAnalytics(dict: [String: Any]) -> [String: Any] {
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
