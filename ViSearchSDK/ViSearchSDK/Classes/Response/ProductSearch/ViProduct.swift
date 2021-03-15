//
//  ViProduct.swift
//  ViSearchSDK
//
//  Created by visenze on 8/3/21.
//

import Foundation

open class ViProduct {
    
    public var productId : String? = nil
    
    public var mainImageUrl : String? = nil
    
    public var data : [String:Any] = [:]
    
    public var score : Float? = nil
    
    public var imageS3Url : String? = nil
    
    public var detect: String? = nil
    
    public var keyword : String? = nil
    
    public var box : ViBox? = nil
    
    public init(jsonData: [String:Any]) {
        
        if let productId = jsonData["product_id"] as? String {
            self.productId = productId
        }
        
        if let mainImageUrl = jsonData["main_image_url"] as? String {
            self.mainImageUrl = mainImageUrl
        }
        
        if let data = jsonData["data"] as? [String:Any] {
            self.data = data
        }
        
        if let score = jsonData["score"] as? Float {
            self.score = score
        }
        
        if let imageS3Url = jsonData["image_s3_url"] as? String {
            self.imageS3Url = imageS3Url
        }
        
        if let detect = jsonData["detect"] as? String {
            self.detect = detect
        }
        
        if let keyword = jsonData["keyword"] as? String {
            self.keyword = keyword
        }
        
        if let box = jsonData["box"] as? [Int] {
            self.box = ViBox(x1: box[0], y1: box[1], x2: box[2], y2: box[3])
        }
        
    }
}
