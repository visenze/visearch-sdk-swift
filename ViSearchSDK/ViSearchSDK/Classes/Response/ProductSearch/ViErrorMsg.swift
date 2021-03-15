//
//  ViErrorMsg.swift
//  ViSearchSDK
//
//  Created by visenze on 8/3/21.
//

import Foundation

open class ViErrorMsg {
    
    public var code : Int? = nil
    
    public var message : String? = nil
    
    public init(jsonString: [String:Any]?) {
        if let string = jsonString {
            if let c = string["code"] as? Int {
                code = c
            }
            if let msg = string["message"] as? String {
                message = msg
            }
        }
    }
    
}
