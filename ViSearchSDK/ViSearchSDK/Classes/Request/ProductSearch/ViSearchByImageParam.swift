//
//  ViSearchByImageParam.swift
//  ViSearchSDK
//
//  Created by visenze on 8/3/21.
//

import Foundation
import UIKit

/// This class contains the specific parameters only required when calling the Search By Image API. It inherits
/// ViBaseProductSearchParam which contains all general parameters
open class ViSearchByImageParam : ViBaseProductSearchParam {
    
    public var imUrl : String? = nil
    
    public var imId : String? = nil
    
    public var image : UIImage? = nil
    
    public var box : ViBox? = nil
    
    public var detection : String? = nil
    
    public var detectionLimit : Int = 0
    
    public var detectionSensitivity : String? = nil
    
    public var searchAllObjects : Bool = false
    
    // public var point: [Int]? = nil
    
    /// Constructor using image URL
    ///
    /// - parameter imUrl: URL to an image
    ///
    /// - returns: Nil if paramter is an empty string
    public init?(imUrl: String){
        self.imUrl = imUrl
        
        if imUrl.isEmpty {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: imUrl is missing")
            return nil
        }
    }
    
    /// Constructor using image ID
    ///
    /// - parameter imId: Image ID can be found in any image retrieved from the server
    ///
    /// - returns: Nil if paramter is an empty string
    public init?(imId: String){
        self.imId = imId
        
        if imId.isEmpty {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: imId is missing")
            return nil
        }
    }
    
    /// Constructor using image file
    ///
    /// - parameter image: Loaded image data
    public init(image: UIImage){
        self.image = image
    }
    
    /// Get the compressed/resize image data
    ///
    /// - returns: Compressed jpegData
    public func getImageData() -> Data? {
        if let image = image {
            return image.jpegData(compressionQuality: 0.97)
        }
        return nil
    }
    
    /// Get a dictionary containing all of this class' member variables as keys and their corresponding values
    ///
    /// - returns: A dictionary representing this class
    public override func toDict() -> [String: Any] {
        var dict = super.toDict()
        
        if imUrl != nil {
            dict["im_url"] = imUrl
        }
        
        if imId != nil {
            dict["im_id"] = imId
        }
        
        if image != nil {
            dict["image"] = getImageData()
        }
        
        if let b = box {
            dict["box"] = "\(b.x1),\(b.y1),\(b.x2),\(b.y2)"
        }
        
        if detection != nil {
            dict["detection"] = detection
        }
        
        if detectionLimit > 0 {
            dict["detection_limit"] = detectionLimit
        }
        
        if detectionSensitivity != nil {
            dict["detection_sensitivity"] = detectionSensitivity
        }
        
        dict["search_all_objects"] = searchAllObjects
        
        return dict
    }
}
