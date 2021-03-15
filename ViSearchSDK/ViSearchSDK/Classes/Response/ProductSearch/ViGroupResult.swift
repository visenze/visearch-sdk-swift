//
//  ViGroupResult.swift
//  ViSearchSDK
//
//  Created by visenze on 15/3/21.x
//

import Foundation

open class ViGroupResult : NSObject {
    
    public var groupByValue : String? = nil
    
    public var results: [[String:String]] = []
    
    public init(jsonData: [String:Any]) {
        super.init()
        
        groupByValue = jsonData["group_by_value"] as? String
        
        if let resArr = jsonData["results"] as? [Any] {
            for jsonItem in resArr {
                if let dict = jsonItem as? [String:String] {
                    results.append(dict)
                }
            }
        }
    }
    
}


