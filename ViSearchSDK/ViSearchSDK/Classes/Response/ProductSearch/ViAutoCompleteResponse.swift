//
//  ViAutoCompleteResponse.swift
//  ViSearchSDK
//
//  Created by Hung on 27/11/23.
//  Copyright © 2023 Hung. All rights reserved.
//

import Foundation

open class ViAutoCompleteResponse : NSObject {
    
    public var requestId : String? = nil
    
    public var status : String? = nil
    
    public var page : Int? = nil
    
    public var limit : Int? = nil
    
    public var total : Int? = nil
    
    public var error : ViErrorMsg? = nil
    
    public var result : [ViAutoCompleteItem] = []
    
    public init(response: URLResponse, data: Data) {
        super.init()
        
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
            
            requestId = json["reqid"]  as? String
            status    = json["status"] as? String
            page      = json["page"]   as? Int
            limit     = json["limit"]  as? Int
            total     = json["total"]  as? Int
            
            if let err = json["error"] as? [String:Any] {
                error = ViProductSearchResponse.parseErrorMsg(err: err)
            }
            
            if let results = json["result"] as? [Any] {
                result = ViAutoCompleteResponse.parseResult(results)
            }
            
        }
        catch {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Json response might be invalid. Error during processing:")
            print ("\(error)\n")
        }

    }
    
    public static func parseResult(_ jsonString: String) -> [ViAutoCompleteItem] {
        do{
            let data = jsonString.data(using: .utf8)!
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
            return ViAutoCompleteResponse.parseResult(jsonArray)
        }
        catch {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Json response might be invalid. Error during processing:")
            print ("\(error)\n")
        }
        return []
    }
    
    private static func parseResult(_ arr: [Any]) -> [ViAutoCompleteItem] {
        var results : [ViAutoCompleteItem] = []
        
        for jsonItem in arr {
            if let dict = jsonItem as? [String:Any] {
                if let text = dict["text"] as? String {
                    let item = ViAutoCompleteItem(text: text)
                    item.score = dict["score"] as? Double
                    results.append(item)
                }
            }
        }
        
        return results
    }
    
    
}
