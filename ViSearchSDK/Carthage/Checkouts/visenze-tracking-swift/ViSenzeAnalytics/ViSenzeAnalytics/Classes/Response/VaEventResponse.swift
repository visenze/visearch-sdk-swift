//
//  VaEventResponse.swift
//  ViSenzeAnalytics
//
//  Created by Hung on 9/9/20.
//  Copyright © 2020 ViSenze. All rights reserved.
//

import UIKit

public class VaEventResponse: NSObject {
    /// request ID
    public var reqid: String = ""
    
    /// the request status : OK, warning or fail
    public var status: String = ""
    
    public var error: VaError? = nil
    
    public init?(data: Data) {
         super.init()
         
         do{
             let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
             
             self.parseJson(json)
         
         }
         catch {
             print("\(type(of: self)).\(#function)[line:\(#line)] - error: Json response might be invalid. Error during processing:")
             print ("\(error)\n")
             return nil
         }

     }
     
     public func parseJson(_ json: [String : Any]) {
        if let status = json["status"] as? String {
            self.status = status
        }
        
        if let errorCode = json["error"] as? [String: Any] {
            if let error = errorCode["message"] as? String, let code = errorCode["code"] as? Int {
                self.error = VaError(code: code, message: error)
            }
        }
         
         if let requestId = json["reqid"] as? String {
             self.reqid = requestId
         }
     
    }
     
}
