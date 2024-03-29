import Foundation
import ViSenzeAnalytics

/// wrapper for various API calls
/// create shared client
open class ViSearch: NSObject {
    
    public static let sharedInstance = ViSearch()
    
    public var client : ViSearchClient?
    
    private override init(){
        super.init()
    }
    
    
    /// Check if search client is setup properly
    ///
    /// - returns: true if client is setup
    public func isClientSetup() -> Bool {
        return client != nil
    }
    
    // MARK: setup
    
    /// Setup API client. Must be called first before various API calls
    ///
    /// - parameter accessKey: application access key
    /// - parameter secret:    application secret key
    public func setup(accessKey: String, secret: String) -> Void {
        if client == nil {
            client = ViSearchClient(accessKey: accessKey, secret: secret)
        }
        
        client?.accessKey = accessKey
        client?.secret = secret
        client?.isAppKeyEnabled = false
    }
    
    /// Setup API client. Must be called first before various API calls
    ///
    /// - parameter appKey: application app key
    public func setup(appKey: String) -> Void {
        if client == nil {
            client = ViSearchClient(appKey: appKey)
        }
        
        client?.accessKey = appKey
        client?.isAppKeyEnabled = true

    }
    
    // MARK: Analytics
    
    public func newTracker(code: String) -> ViSenzeTracker {
        return ViSenzeTracker(code: code, isCn: false)!
    }
    
    public func newTracker(code: String, forCn: Bool) -> ViSenzeTracker {
        return ViSenzeTracker(code: code, isCn: forCn)!
    }
    
    
    
    // MARK: API calls
    
    /// Search by Image API
    @discardableResult public func uploadSearch(params: ViUploadSearchParams,
                                                successHandler: @escaping ViSearchClient.SuccessHandler,
                                                failureHandler: @escaping ViSearchClient.FailureHandler) -> URLSessionTask?
    {
        if let client = client {
            return client.uploadSearch(params: params, successHandler: successHandler, failureHandler: failureHandler);
        }
        
        print("\(type(of: self)).\(#function)[line:\(#line)] - error: client is not initialized. Please call setup(accessKey, secret) before using the API.")
        return nil
    }
    
    /// Discover Search API
    @discardableResult public func discoverSearch(params: ViUploadSearchParams,
                                                successHandler: @escaping ViSearchClient.SuccessHandler,
                                                failureHandler: @escaping ViSearchClient.FailureHandler) -> URLSessionTask?
    {
        if let client = client {
            return client.discoverSearch(params: params, successHandler: successHandler, failureHandler: failureHandler);
        }
        
        print("\(type(of: self)).\(#function)[line:\(#line)] - error: client is not initialized. Please call setup(accessKey, secret) before using the API.")
        return nil
    }
    
    /// Search by Color API
    @discardableResult public func colorSearch(params: ViColorSearchParams,
                                               successHandler: @escaping ViSearchClient.SuccessHandler,
                                               failureHandler: @escaping ViSearchClient.FailureHandler
        ) -> URLSessionTask?
    {
        if let client = client {
            return client.colorSearch(params: params, successHandler: successHandler, failureHandler: failureHandler)
        }
        
        print("\(type(of: self)).\(#function)[line:\(#line)] - error: client is not initialized. Please call setup(accessKey, secret) before using the API.")
        return nil
    }
    
    /// Find Similar API
    @discardableResult public func findSimilar(params: ViSearchParams,
                                               successHandler: @escaping ViSearchClient.SuccessHandler,
                                               failureHandler: @escaping ViSearchClient.FailureHandler
        ) -> URLSessionTask?
    {
        if let client = client {
            return client.findSimilar(params: params, successHandler: successHandler, failureHandler: failureHandler)
        }
        
        print("\(type(of: self)).\(#function)[line:\(#line)] - error: client is not initialized. Please call setup(accessKey, secret) before using the API.")
        return nil
    }
    
    /// You may also like API
    @discardableResult public func recommendation(params: ViRecParams,
                                                  successHandler: @escaping ViSearchClient.SuccessHandler,
                                                  failureHandler: @escaping ViSearchClient.FailureHandler
        ) -> URLSessionTask?
    {
        if let client = client {
            return client.recommendation(params: params, successHandler: successHandler, failureHandler: failureHandler)
        }
        
        print("\(type(of: self)).\(#function)[line:\(#line)] - error: client is not initialized. Please call setup(accessKey, secret) before using the API.")
        return nil
    }
    
    

}
