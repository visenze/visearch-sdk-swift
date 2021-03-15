//
//  ViProductSearchClient.swift
//  ViSearchSDK
//
//  Created by visenze on 8/3/21.
//

import Foundation

/// Variation of a HTTP client to perform request, reuses most of the functionality of ViSearchClient but adds
/// a new interface for more  Product Search specifics
open class ViProductSearchClient : ViSearchClient {
    
    public typealias ProductSearchSuccess = (ViProductSearchResponse?) -> ()
    public typealias ProductSearchFailure = (Error) -> ()
    
    /// Constructor, requires a base URL for endpoint and app key
    ///
    /// - parameter baseUrl: Base URL for the endpoints
    /// - parameter appKey: App key
    ///
    /// - returns: Nil if either params are empty
    public override init?(baseUrl: String, appKey: String) {
        super.init(baseUrl: baseUrl, appKey: appKey)
    }
    
    /// POST API, forms the request to execute, results in starting an async URL data task
    ///
    /// - parameter path: Base URL for the endpoints
    /// - parameter params: App key
    /// - parameter imageData: Data of a loaded image
    /// - parameter successHandler: Callback on success
    /// - parameter failureHandler: Callback on failure
    ///
    /// - returns: URLSessionTask
    @discardableResult
    public func post(path:String, params:[String:Any], imageData:Data?, 
                          successHandler: @escaping ProductSearchSuccess,
                          failureHandler: @escaping ProductSearchFailure) -> URLSessionTask {
        // make url
        let url = requestSerialization.generateRequestUrl(
            baseUrl: baseUrl,
            apiEndPoint: path,
            searchParams: params
        )
        // make request
        let request = NSMutableURLRequest(
            url: URL(string: url)!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: timeoutInterval
        )
        // if an image data is provided, then the request will use multi-part
        // form to send the image data, else the fallback is looking at imageUrl
        if let data = imageData {
            let boundary = ViMultipartFormData.randomBoundary()
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = ViMultipartFormData.encode(imageData: data, boundary: boundary);
        }
        // make tracking call to record the action
        return httpRequest(
            method: ViHttpMethod.POST,
            request: request,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }
     
    /// GET API, forms the request to execute, results in starting an async URL data task
    ///
    /// - parameter path: Base URL for the endpoints
    /// - parameter params: App key
    /// - parameter successHandler: Callback on success
    /// - parameter failureHandler: Callback on failure
    ///
    /// - returns: URLSessionTask
    @discardableResult
    public func get(path:String, params:[String:Any],
                    successHandler: @escaping ProductSearchSuccess,
                    failureHandler: @escaping ProductSearchFailure) -> URLSessionTask {
        // make url
        let url = requestSerialization.generateRequestUrl(
            baseUrl: baseUrl,
            apiEndPoint: path,
            searchParams: params
        )
        // make request
        let request = NSMutableURLRequest(
            url: URL(string: url)!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: timeoutInterval
        )
        // make tracking call to record the action
        return httpRequest(
            method: ViHttpMethod.GET,
            request: request,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }
    
    /// Creates the http request, and prepare it as an async URL data task
    ///
    /// - parameter method: Which API method to use, POST/GET
    /// - parameter request: The formed request to send
    /// - parameter successHandler: Callback on success
    /// - parameter failureHandler: Callback on failure
    ///
    /// - returns: URLSessionTask
    private func httpRequest(method: ViHttpMethod,
                             request: NSMutableURLRequest,
                             successHandler: @escaping ProductSearchSuccess,
                             failureHandler: @escaping ProductSearchFailure) -> URLSessionTask {
        
        request.httpMethod = method.rawValue
        let task = createSessionTaskWithRequest(
            request: request,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
        task.resume()
        
        return task
    }
    
    /// Executing an the request
    ///
    /// - parameter request: The http request to send
    /// - parameter successHandler: Callback on success
    /// - parameter failureHandler: Callback on failure
    ///
    /// - returns: URLSessionTask
    private func createSessionTaskWithRequest(request: NSMutableURLRequest,
                                              successHandler: @escaping ProductSearchSuccess,
                                              failureHandler: @escaping ProductSearchFailure) -> URLSessionTask {
        request.addValue(
            getUserAgentValue(),
            forHTTPHeaderField: ViSearchClient.userAgentHeader
        )
         
        let task = session.dataTask(with: request as URLRequest , completionHandler:{
            (data, response, error) in
            if (error != nil) {
                failureHandler(error!)
            }
            else {
                if response == nil || data == nil {
                    successHandler(nil)
                }
                else{
                    let responseData = ViProductSearchResponse(response: response!, data: data!)
                    successHandler(responseData)
                }
            }
        })
        
        return task
    }
}




