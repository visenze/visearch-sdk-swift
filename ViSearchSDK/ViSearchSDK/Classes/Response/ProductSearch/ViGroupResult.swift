//
//  ViGroupResult.swift
//  ViSearchSDK
//
//  Created by visenze on 15/3/21.x
//

import Foundation

/// When grouping of results is enabled in the search parameters, this class contains the grouping results
open class ViGroupResult : NSObject {
    
    public var groupByValue : String
    
    public var results: [ViProduct] = []
    
    /// Constructor, every ViGroupResult should have a value that it is grouped by
    ///
    /// - parameter group: What this group result is grouped by
    ///
    /// - returns: Nil if group is empty
    public init?(group: String) {
        groupByValue = group
        
        if groupByValue.isEmpty {
            return nil
        }
    }
}


