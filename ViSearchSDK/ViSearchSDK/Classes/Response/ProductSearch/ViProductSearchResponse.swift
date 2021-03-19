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
    
    public var productInfo : [String:Any] = [:]
    
    public var objects : [ViProductObjectResult] = []
    
    public var groupResults : [ViGroupResult] = []
    
    public var groupByKey : String? = nil
    
    public var querySysMeta : [String:String] = [:]
    
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
                objects = ViProductSearchResponse.parseObjectResults(objs)
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
    
    /// Returns a ViErrorMsg class that is parsed from a json-converted dictionary
    ///
    /// - parameter err: Json converted dictionary for the "error" field
    ///
    /// - returns: ViErrorMsg
    private static func parseErrorMsg(err: [String:Any]) -> ViErrorMsg {
        let result = ViErrorMsg()
        
        if let code = err["code"] as? Int {
            result.code = code
        }
        
        if let message = err["message"] as? String {
            result.message = message
        }
        
        return result
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
                
                results.append(item)
            }
        }
        return results
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
                
                results.append(object)
            }
        }
        return results
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
