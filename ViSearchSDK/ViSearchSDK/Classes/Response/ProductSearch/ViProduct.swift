//
//  ViProduct.swift
//  ViSearchSDK
//
//  Created by visenze on 8/3/21.
//

import Foundation

/// Class representing a single product's data (eg. 1 pants detected in the image)
open class ViProduct {
    
    public var productId : String? = nil
    
    public var mainImageUrl : String? = nil
    
    public var data : [String:Any] = [:]
    
    public var vsData : [String:Any] = [:]
    
    // for multisearch
    public var sysData : [String:Any] = [:]
    
    public var score : Double? = nil
    
    public var imageS3Url : String? = nil
    
    public var detect: String? = nil
    
    public var keyword : String? = nil
    
    public var box : ViBox? = nil
    
    // recommendation related
    public var tags: [String: Any]?
    
    public var alternatives: [ViProduct] = []
    
    public var pinned: Bool? = nil
    
    public var bestImages: [ViBestImage] = []
}
