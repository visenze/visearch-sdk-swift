//
//  ViBaseProductSearchParam.swift
//  ViSearchSDK
//
//  Created by visenze on 8/3/21.
//

import Foundation
import ViSenzeAnalytics

/// Base class that contains all the required parameters to perform any Product Search API calls. Not meant
/// to be called directly.
open class ViBaseProductSearchParam : ViSearchParamsProtocol {
    
    // General
    
    public var page : Int = 1
    
    public var limit : Int = 10
    
    public var filters : [String:String] = [:]
    
    public var textFilters : [String:String] = [:]
    
    public var attributesToGet : [String] = []
    
    public var facets : [String] = []
    
    public var facetsLimit : Int = 10
    
    public var facetsShowCount : Bool = true
    
    public var sortBy : String? = nil
    
    public var groupBy : String? = nil
    
    public var groupLimit : Int = 1
    
    public var sortGroupBy : String? = nil
    
    public var sortGroupStrategy : String? = nil
    
    public var score : Bool = true
    
    public var scoreMin : Float = 0.0

    public var scoreMax : Float = 1.0
    
    public var returnFieldsMapping : Bool = true
    
    public var returnImageS3Url : Bool = true
    
    public var customParams : [String:String] = [:]
    
    
    
    public var vaUid : String? = nil
    
    public var vaSid : String? = nil
    
    public var vaSdk : String? = nil
    
    public var vaSdkVersion : String? = nil
    
    public var vaOs : String? = nil
    
    public var vaOsv : String? = nil
    
    public var vaDeviceBrand : String? = nil
    
    public var vaDeviceModel : String? = nil
    
    public var vaAppBundleId : String? = nil
    
    public var vaAppName : String? = nil

    public var vaAppVersion : String? = nil

    public var vaAaid : String? = nil

    public var vaDidmd5 : String? = nil

    public var vaN1 : Int? = nil

    public var vaN2 : Int? = nil

    public var vaS1 : String? = nil

    public var vaS2 : String? = nil
    
    /// Takes a dictionary and returns a list of "key:val" strings
    private func toStringArr(dict : [String:Any]) -> [String] {
        var list : [String] = []
        for (k,v) in dict {
            let s = "\(k):\(v)"
            list.append(s)
        }
        return list
    }
    
    // Protocol
    
    /// Returns a  dictionary containing all the parameters
    public func toDict() -> [String : Any] {
        var dict : [String:Any] = [:]
        
        if page > 0 {
            dict["page"] = String(page)
        }
        
        if limit > 0 {
            dict["limit"] = String(limit)
        }
        
        if !filters.isEmpty {
            dict["filters"] = toStringArr(dict: filters)
        }
        
        if !textFilters.isEmpty {
            dict["text_filters"] = toStringArr(dict: textFilters)
        }
        
        if !attributesToGet.isEmpty {
            dict["attrs_to_get"] = attributesToGet
        }
        
        if facets.count > 0 {
            dict["facets"] = facets
            
            dict["facets_limit"] = facetsLimit
            
            dict["facets_show_count"] = facetsShowCount ? "true" : "false"
        }
        
        if sortBy != nil {
            dict["sort_by"] = sortBy
        }
        
        if groupBy != nil {
            dict["group_by"] = groupBy
        }
        
        dict["group_limit"] = String(groupLimit)
        
        if sortGroupBy != nil {
            dict["sort_group_by"] = sortGroupBy
        }
        
        if sortGroupStrategy != nil {
            dict["sort_group_strategy"] = sortGroupStrategy
        }
        
        dict["score"] = score ? "true" : "false"
        
        dict["score_min"] = String(scoreMin)
        
        dict["score_max"] = String(scoreMax)
        
        dict["return_fields_mapping"] = returnFieldsMapping ? "true" : "false"
        
        dict["return_image_s3_url"] = returnImageS3Url ? "true" : "false"

        if !customParams.isEmpty {
            for (k,v) in customParams {
                dict[k] = v
            }
        }
        
        
        
        let sessionManager = VaSessionManager.sharedInstance
        let deviceData = VaDeviceData.sharedInstance
        
        dict["va_uid"] = vaUid != nil ? vaUid : sessionManager.getUid()
        dict["va_sid"] = vaSid != nil ? vaSid : sessionManager.getSessionId()
        dict["va_sdk"] = vaSdk != nil ? vaSdk : deviceData.sdk
        dict["va_sdk_version"] = vaSdkVersion != nil ? vaSdkVersion : deviceData.sdkVersion
        dict["va_os"] = vaOs != nil ? vaOs : deviceData.os
        dict["va_osv"] = vaOsv != nil ? vaOsv : deviceData.osv
        dict["va_device_brand"] = vaDeviceBrand != nil ? vaDeviceBrand : deviceData.deviceBrand
        dict["va_device_model"] = vaDeviceModel != nil ? vaDeviceModel : deviceData.deviceModel
        dict["va_app_bundle_id"] = vaAppBundleId != nil ? vaAppBundleId : deviceData.appBundleId
        dict["va_app_name"] = vaAppName != nil ? vaAppName : deviceData.appName
        dict["va_app_version"] = vaAppVersion != nil ? vaAppVersion : deviceData.appVersion
        
        if vaAaid != nil {
            dict["va_aaid"] = vaAaid
        }
        
        if vaDidmd5 != nil {
            dict["va_didmd5"] = vaDidmd5
        }
        
        if vaN1 != nil {
            dict["va_n1"] = vaN1
        }
        
        if vaN2 != nil {
            dict["va_n2"] = vaN2
        }
        
        if vaS1 != nil {
            dict["va_s1"] = vaS1
        }
        
        if vaS2 != nil {
            dict["va_s2"] = vaS2
        }
        
        return dict
    }
    
}
