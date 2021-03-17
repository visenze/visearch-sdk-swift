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
    
    public var returnProductInfo : Bool? = nil
    
    /// Constructor, checks for non-empty productId
    ///
    /// - parameter productId: Product's ID, retrieved from ViProduct if prior search was made
    ///
    /// - returns: Nil if paramter is an empty string
    public init?(productId: String){
        self.productId = productId
        
        if productId.isEmpty {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: productId is missing")
            return nil
        }
    }
    
    /// Get a dictionary containing all of this class' member variables as keys and their corresponding values
    ///
    /// - returns: A dictionary representing this class
    public override func toDict() -> [String: Any] {
        var dict = super.toDict()
        if let returnProductInfo = returnProductInfo {
            dict["return_product_info"] = returnProductInfo ? "true" : "false"
        }
        return dict
    }
}

