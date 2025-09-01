//
//  ViProductSearchResponse.swift
//  ViSearchSDK
//
//  Created by visenze on 8/3/21.
//

import Foundation

/// Response parameters from the search requests made
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
    
    public var productInfo : ViProduct? = nil
    
    // for multisearch
    public var qinfo : ViProduct? = nil
    
    public var objects : [ViProductObjectResult] = []
    
    public var groupResults : [ViGroupResult] = []
    
    public var groupByKey : String? = nil
    
    public var querySysMeta : [String:String] = [:]
    
    public var strategy: ViStrategy? = nil
    
    public var experiment: ViExperiment? = nil
    
    public var excludedPids: [String] = []
    
    public var setInfoList: [ViSetInfo] = []
    
    /// Constructor, uses the raw response from the URL query and parses it into the relevant data fields
    ///
    /// - parameter response: Response gotten from the URL request
    /// - parameter data: Data attached to the response from the server
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
            
            if let err = json["error"] as? [String:Any] {
                error = ViProductSearchResponse.parseErrorMsg(err: err)
            }
            
            if let strategyDict = json["strategy"] as? [String:Any] {
                strategy = ViProductSearchResponse.parseStrategy(strategyDict)
            }
            
            if let expDict = json["experiment"] as? [String:Any] {
                experiment = ViProductSearchResponse.parseExperiment(expDict)
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
            
            if let excludedPidList = json["excluded_pids"] as? [String] {
                excludedPids = excludedPidList
            }
            
            if let prodInfo = json["product_info"] as? [String:Any] {
                productInfo = ViProductSearchResponse.parseProduct(prodInfo)
            }
            
            if let queryInfo = json["qinfo"] as? [String:Any] {
                qinfo = ViProductSearchResponse.parseProduct(queryInfo)
            }
            
            if let objs = json["objects"] as? [Any] {
                objects = ViProductSearchResponse.parseObjectResults(objs)
            }
            
            if let groups = json["group_results"] as? [Any] {
                groupResults = ViProductSearchResponse.parseGroupResults(groups)
            }
            
            groupByKey = json["group_by_key"] as? String
            
            if let sysMeta = json["query_sys_meta"] as? [String:String] {
                querySysMeta = sysMeta
            }
            
            if let setInfoJson = json["set_info"] as? [Any] {
                self.setInfoList = ViResponseData.parseSetInfo(setInfoJson)
            }
            
        }
        catch {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Json response might be invalid. Error during processing:")
            print ("\(error)\n")
        }

    }
    
    // return whether the results are empty due to A/B test setting of returning no recommendations
    public func experimentNoRecommendation() -> Bool {
        if let experiment = self.experiment {
            return experiment.expNoRecommendation
        }
        
        return false
    }
    
    /// Returns a ViErrorMsg class that is parsed from a json-converted dictionary
    ///
    /// - parameter err: Json converted dictionary for the "error" field
    ///
    /// - returns: ViErrorMsg
    public static func parseErrorMsg(err: [String:Any]) -> ViErrorMsg {
        let result = ViErrorMsg()
        
        if let code = err["code"] as? Int {
            result.code = code
        }
        
        if let message = err["message"] as? String {
            result.message = message
        }
        
        return result
    }
    
    private static func parseStrategy(_ strategyDict:  [String:Any]) -> ViStrategy {
        let result = ViStrategy()
        
        result.strategyId = strategyDict["id"] as? Int
        result.name = strategyDict["name"] as? String
        result.algorithm = strategyDict["algorithm"] as? String
        
        return result
    }
    
    private static func parseExperiment(_ experimentDict: [String:Any]) -> ViExperiment {
        let result = ViExperiment()
        
        result.experimentId = experimentDict["experiment_id"] as? Int
        result.variantId = experimentDict["variant_id"] as? Int
        result.variantName = experimentDict["variant_name"] as? String
        result.strategyId = experimentDict["strategy_id"] as? Int
        if let expNoRecommendation = experimentDict["experiment_no_recommendation"] as? Bool {
            result.expNoRecommendation = expNoRecommendation
        }
        
        return result
    }
    
   /// Returns an array of ViProduct that is parsed from a json array format string
   ///
   /// - parameter jsonString: The json formatted string containing an array of ViProducts
   ///
   /// - returns: An array of ViProducts
    public static func parseProductResults(_ jsonString: String) -> [ViProduct] {
        do{
            let data = jsonString.data(using: .utf8)!
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
            return ViProductSearchResponse.parseProductResults(jsonArray)
        }
        catch {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Json response might be invalid. Error during processing:")
            print ("\(error)\n")
        }
        return []
    }
     
    /// Returns an array of ViProduct that is parsed from an array of json object
    ///
    /// - parameter arr: An array of json object for the "result" field
    ///
    /// - returns: An array of ViProducts found by the server
    private static func parseProductResults(_ arr: [Any]) -> [ViProduct] {
        var results : [ViProduct] = []
        // iterate through each json object
        for jsonItem in arr {
            // convert from json object to dictionary and then parse the data
            if let dict = jsonItem as? [String:Any] {
                
                let item = ViProductSearchResponse.parseProduct(dict)
                results.append(item)
            }
        }
        return results
    }
    
    public static func parseProduct(_ dict: [String:Any]) -> ViProduct {
    
        let item = ViProduct()
        
        if let productId = dict["product_id"] as? String {
            item.productId = productId
        }
        
        if let mainImageUrl = dict["main_image_url"] as? String {
            item.mainImageUrl = mainImageUrl
        }
        
        if let data = dict["data"] as? [String:Any] {
            item.data = data
        }
        
        if let vsData = dict["vs_data"] as? [String:Any] {
            item.vsData = vsData
        }
        
        if let sysData = dict["sys"] as? [String:Any] {
            item.sysData = sysData
        }
        
        if let tags = dict["tags"] as? [String:Any] {
            item.tags = tags
        }
        
        if let pinned = dict["pinned"] as? String {
            item.pinned = pinned == "true"
        }
        
        if let alt = dict["alternatives"] as? [Any] {
            item.alternatives = ViProductSearchResponse.parseProductResults(alt)
        }
        
        if let bestImages = dict["best_images"] as? [Any] {
            item.bestImages = ViResponseData.parseBestImages(bestImages)
        }
        
        if let score = dict["score"] as? Double {
            item.score = score
        }
        
        if let imageS3Url = dict["image_s3_url"] as? String {
            item.imageS3Url = imageS3Url
        }
        
        if let detect = dict["detect"] as? String {
            item.detect = detect
        }
        
        if let keyword = dict["keyword"] as? String {
            item.keyword = keyword
        }
        
        if let box = dict["box"] as? [Int] {
            if box.count >= 4 {
                item.box = ViBox(x1: box[0], y1: box[1], x2: box[2], y2: box[3])
            }
        }
        
        return item
    }
    
   /// Returns an array of ViProductObjectResult that is parsed from a json array format string
   ///
   /// - parameter jsonString: The json formatted string containing an array of ViProductObjectResult
   ///
   /// - returns: An array of ViProductObjectResult
    public static func parseObjectResults(_ jsonString: String) -> [ViProductObjectResult] {
        do{
            let data = jsonString.data(using: .utf8)!
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
            return ViProductSearchResponse.parseObjectResults(jsonArray)
        }
        catch {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Json response might be invalid. Error during processing:")
            print ("\(error)\n")
        }
        return []
    }
    
    ///
    /// - parameter arr:
    ///
    /// - returns:
    private static func parseObjectResults(_ arr: [Any]) -> [ViProductObjectResult] {
        var results : [ViProductObjectResult] = []
        for jsonItem in arr {
            if let dict = jsonItem as? [String:Any] {
                
                let object = ViProductObjectResult()
                
                if let type = dict["type"] as? String {
                    object.type = type
                }
                
                if let score = dict["score"] as? Double {
                    object.score = score
                }
                
                if let box = dict["box"] as? [Int] {
                    if box.count >= 4 {
                        object.box = ViBox(x1: box[0], y1: box[1], x2: box[2], y2: box[3])
                    }
                }
                
                if let attributes = dict["attributes"] as? [String:Any] {
                    object.attributes = attributes
                }
                
                if let total = dict["total"] as? Int {
                    object.total = total
                }
                
                if let res = dict["result"] as? [Any] {
                    object.result = ViProductSearchResponse.parseProductResults(res)
                }
                
                if let groups = dict["group_results"] as? [Any] {
                    object.groupResults = ViProductSearchResponse.parseGroupResults(groups)
                }
                
                object.id = dict["id"] as? String
                object.category = dict["category"] as? String
                object.name = dict["name"] as? String
                object.boxType = dict["box_type"] as? String
                
                if let excludedPidList = dict["excluded_pids"] as? [String] {
                    object.excludedPids = excludedPidList
                }
                
                if let facetListJson = dict["facets"] as? [Any] {
                    object.facets = ViResponseData.parseFacets(facetListJson)
                }
                
                results.append(object)
            }
        }
        return results
    }
    
   /// Returns an array of ViGroupResult that is parsed from a json array format string
   ///
   /// - parameter jsonString: The json formatted string containing an array of ViGroupResult
   ///
   /// - returns: An array of ViGroupResult
    public static func parseGroupResults(_ jsonString: String) -> [ViGroupResult] {
        do{
            let data = jsonString.data(using: .utf8)!
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
            return ViProductSearchResponse.parseGroupResults(jsonArray)
        }
        catch {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Json response might be invalid. Error during processing:")
            print ("\(error)\n")
        }
        return []
    }
    
    /// Returns an array of ViGroupResult that is parsed from an array of json object
    ///
    /// - parameter arr: An array of json object for the "group_results" field
    ///
    /// - returns: An array of ViGroupResult grouped by the server
    private static func parseGroupResults(_ arr: [Any]) -> [ViGroupResult] {
        var results: [ViGroupResult] = []
        // iterate through each json object
        for jsonItem in arr {
            // convert from json object to dictionary and then parse the data
            if let dict = jsonItem as? [String:Any] {
                
                let group = dict["group_by_value"] as! String
                
                let item = ViGroupResult(group: group)!
                
                if let groupedResults = dict["result"] as? [Any] {
                    item.results = ViProductSearchResponse.parseProductResults(groupedResults)
                }
                
                results.append(item)
            }
        }
        
        return results
    }
    
}
