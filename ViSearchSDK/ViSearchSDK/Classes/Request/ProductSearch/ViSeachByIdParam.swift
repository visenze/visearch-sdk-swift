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
    
    // for recommendation
    public var altLimit : Int? = nil
    
    public var strategyId: Int? = nil
    
    public var showPinnedPids: Bool? = nil
    
    public var showExcludedPids: Bool? = nil
    
    public var useSetBasedCtl: Bool? = nil
    
    public var setLimit: Int?
    
    public var showBestProductImages: Bool? = nil
    
    public var nonProductBasedRecs: Bool? = nil
    
    public var boxList : [String] = []
    
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
        
        if let altLimit = self.altLimit {
            dict["alt_limit"] = String(altLimit)
        }
        
        if let strategyId = self.strategyId {
            dict["strategy_id"] = String(strategyId)
        }
        
        if let showPinnedPids = showPinnedPids {
            dict["show_pinned_pids"] = showPinnedPids ? "true" : "false"
        }
        
        if let showExcludedPids = showExcludedPids {
            dict["show_excluded_pids"] = showExcludedPids ? "true" : "false"
        }
        
        if let useSetBasedCtl = useSetBasedCtl {
            dict["use_set_based_ctl"] = useSetBasedCtl ? "true" : "false"
        }
        
        if let setLimit = self.setLimit {
            dict["set_limit"] = String(setLimit)
        }
        
        if let showBestProductImages = showBestProductImages {
            dict["show_best_product_images"] = showBestProductImages ? "true" : "false"
        }
        
        if let nonProductBasedRecs = nonProductBasedRecs {
            dict["non_product_based_recs"] = nonProductBasedRecs ? "true" : "false"
        }
        
        if !boxList.isEmpty {
            dict["box"] = boxList
        }
        
        return dict
    }
}

