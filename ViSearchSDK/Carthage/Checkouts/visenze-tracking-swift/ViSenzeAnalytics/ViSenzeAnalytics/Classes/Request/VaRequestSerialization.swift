//
//  VaRequestSerialization.swift
//  ViSenzeAnalytics
//
//  Created by Hung on 8/9/20.
//  Copyright © 2020 ViSenze. All rights reserved.
//

import UIKit

public class VaRequestSerialization: NSObject {
    
    /// generate the url with query string and escape parameter properly
    public func generateRequestUrl(
                                    baseUrl: String ,
                                    code: String,
                                    apiMethod: VaApiMethod ,
                                    params : VaParamsProtocol,
                                    deviceData: VaDeviceData) -> String {
        
        var paramDict = params.toDict()
        paramDict["code"] = code
        
        // add in device data
        paramDict["sdk"] = deviceData.sdk
        paramDict["v"] = deviceData.sdkVersion
        paramDict["p"] = deviceData.platform
        paramDict["os"] = deviceData.os
        paramDict["osv"] = deviceData.osv
        paramDict["sr"] = deviceData.screenResolution
        paramDict["ab"] = deviceData.appBundleId
        paramDict["an"] = deviceData.appName
        paramDict["av"] = deviceData.appVersion
        paramDict["db"] = deviceData.deviceBrand
        paramDict["dm"] = deviceData.deviceModel
        paramDict["lang"] = deviceData.language
        
        
        
        let queryString = generateQueryString(paramDict)
        
        return "\(baseUrl)/\(apiMethod.rawValue)?\(queryString)"
    }
    
    /// generate the query string to append to the url
    public func generateQueryString(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    /// Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
    ///
    /// - parameter key:   The key of the query component.
    /// - parameter value: The value of the query component.
    ///
    /// - returns: The percent-escaped, URL encoded query string components.
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)", value: value)
            }
        } else {
            let pair = ( escape(key), escape("\(value)") )
            components.append( pair )
        }
        
        return components
    }
    
    /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    ///
    /// - parameter string: The string to be percent-escaped.
    ///
    /// - returns: The percent-escaped string.
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
}
