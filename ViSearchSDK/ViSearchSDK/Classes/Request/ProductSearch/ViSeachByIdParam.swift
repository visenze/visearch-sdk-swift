//
//  ViSeachByIdParam.swift
//  ViSearchSDK
//
//  Created by visenze on 8/3/21.
//

import Foundation

/// This class contains the specific parameters only required when calling the Search By ID API. It inherits
/// ViBaseProductSearchParam which contains all general parameters
open class ViSearchByIdParam : ViBaseProductSearchParam {
    
    /// Product ID is actually used as part of the query path and not a normal parameter variable
    public var productId : String? = nil
    
    /// Constructor, checks for non-empty productId
    public init?(productId: String){
        self.productId = productId
        
        if productId.isEmpty {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: productId is missing")
            return nil
        }
    }
    
    /// Returns a  dictionary containing all the parameters
    public override func toDict() -> [String: Any] {
        return super.toDict()
    }
}

