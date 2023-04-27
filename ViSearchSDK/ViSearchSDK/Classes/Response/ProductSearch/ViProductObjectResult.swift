//
//  ViProductObjectResult.swift
//  ViSearchSDK
//
//  Created by visenze on 17/3/21.
//

import Foundation

open class ViProductObjectResult {
    
    public var type: String? = nil
    
    public var score: Double? = nil
    
    public var box : ViBox? = nil
    
    public var attributes: [String:Any] = [:]
    
    public var total: Int? = nil
    
    public var result: [ViProduct] = []
    public var groupResults : [ViGroupResult] = []
    
    public var id: String?
    public var category: String?
    public var name: String?
    public var facets : [ViFacet] = []
    public var excludedPids: [String] = []
}
