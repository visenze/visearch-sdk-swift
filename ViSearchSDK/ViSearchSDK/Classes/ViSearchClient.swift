import Foundation
import ViSenzeAnalytics

public enum ViHttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

public enum ViAPIEndPoints: String {
    case COLOR_SEARCH  = "colorsearch"
    case ID_SEARCH     = "search"
    case UPLOAD_SEARCH = "uploadsearch"
    case REC_SEARCH    = "recommendations"
    case DISCOVER_SEARCH = "discoversearch"
    case TRACK         = "__aq.gif"
}

/// Search client
open class ViSearchClient: NSObject, URLSessionDelegate {
    
    public static let VISENZE_URL = "https://visearch.visenze.com"
    
    public typealias SuccessHandler = (ViResponseData?) -> ()
    public typealias FailureHandler = (Error) -> ()
    
    // MARK: properties
    
    // if isAppKeyEnabled is true, this refers to the appKey. If fail it is accessKey and meant to be used with secret
    public var accessKey : String
    
    // with the new authentication, this would be optional
    public var secret    : String = ""
    public var baseUrl   : String
    
    public var session: URLSession
    public var sessionConfig: URLSessionConfiguration
//    private var uploadSession: URLSession?

    public var timeoutInterval : TimeInterval = 10 // how long to timeout request
    public var requestSerialization: ViRequestSerialization
    
    public var userAgent : String = "visearch-swift-sdk/1.10.6"
    public static let userAgentHeader : String = "X-Requested-With"
    
    // whether to authenticate by appkey or by access/secret key point
    public var isAppKeyEnabled : Bool = true
    
 
    // MARK: constructors
    public init?(baseUrl: String, accessKey: String , secret: String) {
        
        if baseUrl.isEmpty {
            return nil;
        }
        
        if accessKey.isEmpty {
            return nil;
        }
        
        if secret.isEmpty {
            return nil;
        }
        
        self.baseUrl = baseUrl
        self.accessKey = accessKey
        self.secret = secret
        self.isAppKeyEnabled = false
        
        self.requestSerialization = ViRequestSerialization()
        
        // config default session
        sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess = true
        sessionConfig.timeoutIntervalForRequest = timeoutInterval
        sessionConfig.timeoutIntervalForResource = timeoutInterval
        
        // Configuring caching behavior for the default session
        let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheURL = cachesDirectoryURL.appendingPathComponent("viSearchCache")
        let diskPath = cacheURL.path
        
        let cache = URLCache(memoryCapacity:16384, diskCapacity: 268435456, diskPath: diskPath)
        sessionConfig.urlCache = cache
        sessionConfig.requestCachePolicy = .useProtocolCachePolicy
        
        // base 64 authentication
        sessionConfig.httpAdditionalHeaders = ["Authorization" : requestSerialization.getBasicAuthenticationString(accessKey: accessKey, secret: secret)]
        
        session = URLSession(configuration: sessionConfig)
        
    }
    
    public init?(baseUrl: String, appKey: String ) {
        
        if baseUrl.isEmpty {
            return nil;
        }
        
        if appKey.isEmpty {
            return nil;
        }
        
        self.baseUrl = baseUrl
        self.accessKey = appKey
        self.secret = ""
        self.isAppKeyEnabled = true
        
        self.requestSerialization = ViRequestSerialization()
        
        // config default session
        sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess = true
        sessionConfig.timeoutIntervalForRequest = timeoutInterval
        sessionConfig.timeoutIntervalForResource = timeoutInterval
        
        // Configuring caching behavior for the default session
        let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheURL = cachesDirectoryURL.appendingPathComponent("viSearchCache")
        let diskPath = cacheURL.path
        
        let cache = URLCache(memoryCapacity:16384, diskCapacity: 268435456, diskPath: diskPath)
        sessionConfig.urlCache = cache
        sessionConfig.requestCachePolicy = .useProtocolCachePolicy
        
        session = URLSession(configuration: sessionConfig)
        
    }

    
    public convenience init?(accessKey: String , secret: String)
    {
        self.init( baseUrl: ViSearchClient.VISENZE_URL , accessKey: accessKey, secret: secret)
    }
    
    public convenience init?(appKey: String)
    {
        self.init( baseUrl: ViSearchClient.VISENZE_URL , appKey: appKey)
    }
    
    // MARK: Visenze APIs
    @discardableResult public func uploadSearch(params: ViUploadSearchParams,
                             successHandler: @escaping SuccessHandler,
                             failureHandler: @escaping FailureHandler) -> URLSessionTask
    {
        var url : String? = nil
        self.addAnalyticParams(params: params)
        
        // NOTE: image must be first line before generating of url
        // url box parameters depend on whether the compress image is generated
        let imageData: Data? = params.generateCompressImageForUpload()
        
        if self.isAppKeyEnabled {
            url = requestSerialization.generateRequestUrl(baseUrl: baseUrl, apiEndPoint: .UPLOAD_SEARCH , searchParams: params, appKey: self.accessKey)
        }
        else {
            url = requestSerialization.generateRequestUrl(baseUrl: baseUrl, apiEndPoint: .UPLOAD_SEARCH , searchParams: params)
            
        }
        
        let request = NSMutableURLRequest(url: URL(string: url!)! , cachePolicy: .useProtocolCachePolicy , timeoutInterval: timeoutInterval)
        
        let boundary = ViMultipartFormData.randomBoundary()
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = ViMultipartFormData.encode(imageData: imageData, boundary: boundary);
        
        // make tracking call to record the action
        return httpPost(request: request,
                       successHandler: {
                        (data: ViResponseData?) -> Void in
                        successHandler(data)
            },
                       failureHandler: failureHandler )
    }
    
    @discardableResult public func discoverSearch(params: ViUploadSearchParams,
                                                successHandler: @escaping SuccessHandler,
                                                failureHandler: @escaping FailureHandler) -> URLSessionTask
    {
        var url : String? = nil
        self.addAnalyticParams(params: params)
        
        // NOTE: image must be first line before generating of url
        // url box parameters depend on whether the compress image is generated
        let imageData: Data? = params.generateCompressImageForUpload()
        
        if self.isAppKeyEnabled {
            url = requestSerialization.generateRequestUrl(baseUrl: baseUrl, apiEndPoint: .DISCOVER_SEARCH , searchParams: params, appKey: self.accessKey)
        }
        else {
            url = requestSerialization.generateRequestUrl(baseUrl: baseUrl, apiEndPoint: .DISCOVER_SEARCH , searchParams: params)
        }
        
        let request = NSMutableURLRequest(url: URL(string: url!)! , cachePolicy: .useProtocolCachePolicy , timeoutInterval: timeoutInterval)
        
        let boundary = ViMultipartFormData.randomBoundary()
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = ViMultipartFormData.encode(imageData: imageData, boundary: boundary);
        
        // make tracking call to record the action
        return httpPost(request: request,
                        successHandler: {
                            (data: ViResponseData?) -> Void in
                            
                            successHandler(data)
        },
                        failureHandler: failureHandler )
    }
    
    @discardableResult public func colorSearch(params: ViColorSearchParams,
                            successHandler: @escaping SuccessHandler,
                            failureHandler: @escaping FailureHandler
                            ) -> URLSessionTask
    {
        return makeGetApiRequest(params: params, apiEndPoint: .COLOR_SEARCH, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    public func findSimilar(params: ViSearchParams,
                            successHandler: @escaping SuccessHandler,
                            failureHandler: @escaping FailureHandler
        ) -> URLSessionTask
    {
        return makeGetApiRequest(params: params, apiEndPoint: .ID_SEARCH, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    public func recommendation(params: ViRecParams,
                            successHandler: @escaping SuccessHandler,
                            failureHandler: @escaping FailureHandler
        ) -> URLSessionTask
    {
        return makeGetApiRequest(params: params, apiEndPoint: .REC_SEARCH, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    // MARK: http requests internal
    
    // make API call and also send a tracking request immediately if successful
    private func makeGetApiRequest(params: ViBaseSearchParams,
                                   apiEndPoint: ViAPIEndPoints,
                                   successHandler: @escaping SuccessHandler,
                                   failureHandler: @escaping FailureHandler
        ) -> URLSessionTask{
        
        self.addAnalyticParams(params: params)
        
        var url : String? = nil
        if self.isAppKeyEnabled {
            url = requestSerialization.generateRequestUrl(baseUrl: baseUrl, apiEndPoint: apiEndPoint , searchParams: params, appKey: self.accessKey)
        }
        else {
            url = requestSerialization.generateRequestUrl(baseUrl: baseUrl, apiEndPoint: apiEndPoint , searchParams: params)
            
        }
        
        let request = NSMutableURLRequest(url: URL(string: url!)! , cachePolicy: .useProtocolCachePolicy , timeoutInterval: timeoutInterval)
        
        // make tracking call to record the action 
        return httpGet(request: request,
                       successHandler: {
                             (data: ViResponseData?) -> Void in
                        
                               successHandler(data)
                       },
                       failureHandler: failureHandler )
        
    }
    
    private func addAnalyticParams(params: ViBaseSearchParams) {
        let sessionManager = VaSessionManager.sharedInstance
        let deviceData = VaDeviceData.sharedInstance
        
        if params.uid == nil {
            params.uid = sessionManager.getUid()
        }
        
        if params.sid == nil {
            params.sid = sessionManager.getSessionId()
        }
        
        if params.appId == nil {
            params.appId = deviceData.appBundleId
        }
        
        if params.appName == nil {
            params.appName = deviceData.appName
        }
        
        if params.appVersion == nil {
            params.appVersion = deviceData.appVersion
        }
        
        if params.deviceBrand == nil {
            params.deviceBrand = deviceData.deviceBrand
        }
        
        if params.deviceModel == nil {
            params.deviceModel = deviceData.deviceModel
        }
        
        if params.language == nil {
            params.language = deviceData.language
        }
        
        if params.os == nil {
            params.os = deviceData.os
        }
        
        if params.osv == nil {
            params.osv = deviceData.osv
        }
        
        if params.platform == nil {
            params.platform = deviceData.platform
        }
        
    
    }
    
    private func httpGet(request: NSMutableURLRequest,
                         successHandler: @escaping SuccessHandler,
                         failureHandler: @escaping FailureHandler) -> URLSessionTask
    {
        return httpRequest(method: ViHttpMethod.GET, request: request, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    private func httpPost(request: NSMutableURLRequest,
                         successHandler: @escaping SuccessHandler,
                         failureHandler: @escaping FailureHandler) -> URLSessionTask
    {
        return httpRequest(method: ViHttpMethod.POST, request: request, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    private func httpRequest(method: ViHttpMethod,
                             request: NSMutableURLRequest,
                             successHandler: @escaping SuccessHandler,
                             failureHandler: @escaping FailureHandler) -> URLSessionTask {
        
        request.httpMethod = method.rawValue
        let task = createSessionTaskWithRequest(request: request, successHandler: successHandler, failureHandler: failureHandler)
        task.resume()
        
        return task
    }
    
    /**
     *  create data task session for request
     *
     *  @param URLRequest   request
     *  @param SuccessHandler success handler closure
     *  @param FailureHandler failure handler closure
     *
     *  @return session task
     */
    private func createSessionTaskWithRequest(request: NSMutableURLRequest,
                                              successHandler: @escaping SuccessHandler,
                                              failureHandler: @escaping FailureHandler) -> URLSessionTask
    {
        request.addValue(getUserAgentValue() , forHTTPHeaderField: ViSearchClient.userAgentHeader )
        
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
                    let responseData = ViResponseData(response: response!, data: data!)
                    successHandler(responseData)
                }
            }
        })
        
        return task
    }
    
    public func getUserAgentValue() -> String{
        return userAgent ;
    }
    
    
}
