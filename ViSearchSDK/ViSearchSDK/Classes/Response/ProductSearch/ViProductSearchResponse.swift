//
//  ViProductSearchResponse.swift
//  ViSearchSDK
//
//  Created by visenze on 8/3/21.
//

import Foundation

open class ViProductSearchResponse : NSObject {
    
    public var requestId : String? = nil
    
    public var status : String? = nil
    
    public var imageId : String? = nil
    
    public var page : Int? = nil
    
    public var limit : Int? = nil
    
    public var total : Int? = nil
    
    public var error : ViErrorMsg? = nil
    
    public var productTypes : [ViProductType] = []
    
    public var result : [ViProduct] = []
    
    public var catalogFieldsMapping : [String:String] = [:]
    
    public var facets : [ViFacet] = []
    
    public var productInfo : [String:Any] = [:]
    
    public var objects : [ViObjectResult] = []
    
    public var groupResults : [ViGroupResult] = []
    
    public var groupByKey : String? = nil
    
    public var querySysMeta : [String:String] = [:]
    
    public init(response: URLResponse, data: Data) {
        super.init()
        
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
            
            requestId = json["reqid"]  as? String
            status    = json["status"] as? String
            imageId   = json["im_id"]  as? String
            page      = json["page"]   as? Int
            limit     = json["limit"]  as? Int
            total     = json["total"]  as? Int
            
            if let err = json["error"] as? String {
                error = ViErrorMsg(jsonString: ViProductSearchResponse.convertStringToDictionary(text: err))
            }
            
            if let pTypesJson = json["product_types"] as? [Any] {
                productTypes = ViResponseData.parseProductTypes(pTypesJson)
            }
            
            if let results = json["result"] as? [Any] {
                result = ViProductSearchResponse.parseProductResults(results)
            }
            
            if let mappings = json["catalog_fields_mapping"] as? [String:String] {
                catalogFieldsMapping = mappings
            }
            
            if let facetListJson = json["facets"] as? [Any] {
                facets = ViResponseData.parseFacets(facetListJson)
            }
            
            if let prodInfo = json["product_info"] as? [String:Any] {
                productInfo = prodInfo
            }
            
            if let objs = json["objects"] as? [Any] {
                objects = ViResponseData.parseObjectResults(objs)
            }
            
            if let groups = json["group_results"] as? [Any] {
                groupResults = ViProductSearchResponse.parseGroupResults(groups)
            }
            
            groupByKey = json["group_by_key"] as? String
            
            if let sysMeta = json["query_sys_meta"] as? [String:String] {
                querySysMeta = sysMeta
            }
            
        }
        catch {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Json response might be invalid. Error during processing:")
            print ("\(error)\n")
        }

    }
    
    private static func convertStringToDictionary(text: String) -> [String:Any]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
        
    private static func parseProductResults(_ arr: [Any]) -> [ViProduct] {
        var results : [ViProduct] = []
        for jsonItem in arr {
            if let dict = jsonItem as? [String:Any] {
                let item = ViProduct(jsonData: dict)
                results.append(item)
            }
        }
        return results
    }
    
    private static func parseGroupResults(_ arr: [Any]) -> [ViGroupResult] {
        var results: [ViGroupResult] = []
        for jsonItem in arr {
            if let dict = jsonItem as? [String:Any] {
                let item = ViGroupResult(jsonData: dict)
                results.append(item)
            }
        }
        return results
    }
    
}
