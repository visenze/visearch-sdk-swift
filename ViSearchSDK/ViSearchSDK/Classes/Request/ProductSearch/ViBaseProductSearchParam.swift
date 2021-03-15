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
    
    public var page : Int? = nil
    
    public var limit : Int? = nil
    
    public var filters : [String:String] = [:]
    
    public var textFilters : [String:String] = [:]
    
    public var attributesToGet : [String] = []
    
    public var facets : [String] = []
    
    public var facetsLimit : Int? = nil
    
    public var facetsShowCount : Bool = true
    
    public var sortBy : String? = nil
    
    public var groupBy : String? = nil
    
    public var groupLimit : Int? = nil
    
    public var sortGroupBy : String? = nil
    
    public var sortGroupStrategy : String? = nil
    
    public var score : Bool? = nil
    
    public var scoreMin : Float? = nil

    public var scoreMax : Float? = nil
    
    public var colorRelWeight : Float? = nil
    
    public var returnFieldsMapping : Bool? = nil
    
    public var returnQuerySysMeta : Bool? = nil
    
    public var dedup : Bool? = nil
    
    public var dedupScoreThreshold : Float? = nil

    public var returnImageS3Url : Bool? = nil
    
    public var debug : Bool? = nil
    
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
    
    /// Converts a dictionary of into an array of Strings with a fixed format
    ///
    /// - parameter dict: Dictionary of key-values to convert
    ///
    /// - returns: An arrary of Strings of format ["key1:value1", "key2:value2", ...]
    private func toStringArr(dict : [String:Any]) -> [String] {
        var list : [String] = []
        
        for (k,v) in dict {
            let s = "\(k):\(v)"
            list.append(s)
        }
        
        return list.sorted(by: <)
    }
    
    /// Get a dictionary containing all of this class' member variables as keys and their corresponding values
    ///
    /// - returns: A dictionary representing this class
    public func toDict() -> [String : Any] {
        var dict : [String:Any] = [:]
        
        if let page = page {
            dict["page"] = String(page)
        }
        
        if let limit = limit {
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
        
        if let sort = sortBy {
            dict["sort_by"] = sort
        }
        
        if let group = groupBy {
            dict["group_by"] = group
        }
        
        if let limit = groupLimit {
            dict["group_limit"] = String(limit)
        }
        
        if let sort = sortGroupBy {
            dict["sort_group_by"] = sort
        }
        
        if let sort = sortGroupStrategy{
            dict["sort_group_strategy"] = sort
        }
        
        if let score = score {
            dict["score"] = score ? "true" : "false"
        }
        
        if let score = scoreMin {
            dict["score_min"] = String(score)
        }
        
        if let score = scoreMax {
            dict["score_max"] = String(score)
        }
        
        if let weight = colorRelWeight {
            dict["color_rel_weight"] = String(weight)
        }
        
        if let mapping = returnFieldsMapping {
            dict["return_fields_mapping"] = mapping ? "true" : "false"
        }
        
        if let queryMeta = returnQuerySysMeta {
            dict["return_query_sys_meta"] = queryMeta ? "true" : "false"
        }
        
        if let dedup = dedup {
            dict["dedup"] = dedup ? "true" : "false"
        }
        
        if let score = dedupScoreThreshold {
            dict["dedup_score_threshold"] = String(score)
        }
        
        if let returnS3 = returnImageS3Url {
            dict["return_image_s3_url"] = returnS3 ? "true" : "false"
        }
        
        if let debug = debug {
            dict["debug"] = debug ? "true" : "false"
        }
        
        if !customParams.isEmpty {
            for (k,v) in customParams {
                dict[k] = v
            }
        }
        
        if let val = vaUid {
            dict["va_uid"] = val
        }
        
        if let val = vaSid {
            dict["va_sid"] = val
        }
        
        if let val = vaSdk {
            dict["va_sdk"] = val
        }
        
        if let val = vaSdkVersion {
            dict["va_sdk_version"] = val
        }
        
        if let val = vaOs {
            dict["va_os"] = val
        }
        
        if let val = vaOsv {
            dict["va_osv"] = val
        }
        
        if let val = vaDeviceBrand {
            dict["va_device_brand"] = val
        }
        
        if let val = vaDeviceModel {
            dict["va_device_model"] = val
        }
        
        if let val = vaAppBundleId {
            dict["va_app_bundle_id"] = val
        }
        
        if let val = vaAppName {
            dict["va_app_name"] = val
        }
        
        if let val = vaAppVersion {
            dict["va_app_version"] = val
        }
        
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
