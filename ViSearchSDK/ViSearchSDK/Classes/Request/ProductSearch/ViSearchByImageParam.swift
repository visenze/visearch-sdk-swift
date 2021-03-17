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
    
    public var detectionLimit : Int? = nil
    
    public var detectionSensitivity : String? = nil
    
    public var searchAllObjects : Bool? = nil
    
    public var imgSettings : ViImageSettings = ViImageSettings()
    
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
    public func getCompressedImageData() -> Data? {
        if let image = image {
        
            let quality = imgSettings.quality;
            
            // maxWidth should not larger than 1024 pixels
            let maxWidth = CGFloat(min(imgSettings.maxWidth, 1024));
            
            var actualHeight : CGFloat = image.size.height * image.scale;
            var actualWidth  : CGFloat = image.size.width * image.scale;
            let maxHeight : CGFloat = maxWidth
            var imgRatio  : CGFloat = actualWidth/actualHeight;
            let maxRatio  : CGFloat = maxWidth/maxHeight;
            
            if (actualHeight > maxHeight || actualWidth > maxWidth) {
                if(imgRatio < maxRatio) {
                    // adjust width according to maxHeight
                    imgRatio = maxHeight / actualHeight;
                    actualWidth = imgRatio * actualWidth;
                    actualHeight = maxHeight;
                }
                else if(imgRatio > maxRatio) {
                    // adjust height according to maxWidth
                    imgRatio = CGFloat(imgSettings.maxWidth) / actualWidth;
                    actualHeight = imgRatio * actualHeight;
                    actualWidth = maxWidth;
                }
                else {
                    actualHeight = maxHeight;
                    actualWidth = maxWidth;
                }
            }
            
            let rect : CGRect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight);
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0);
            image.draw(in: rect)
            let img = UIGraphicsGetImageFromCurrentImageContext();
            let imageData : Data = img!.jpegData(compressionQuality: CGFloat(quality))!;
            UIGraphicsEndImageContext();
            
            return imageData
        }
        return nil
    }
    
    /// Get a dictionary containing all of this class' member variables as keys and their corresponding values
    ///
    /// - returns: A dictionary representing this class
    public override func toDict() -> [String: Any] {
        var dict = super.toDict()
        
        if let imUrl = imUrl {
            dict["im_url"] = imUrl
        }
        
        if let imId = imId {
            dict["im_id"] = imId
        }
        
        if let b = box {
            dict["box"] = "\(b.x1),\(b.y1),\(b.x2),\(b.y2)"
        }
        
        if let detection = detection {
            dict["detection"] = detection
        }
        
        if let detectionLimit = detectionLimit {
            dict["detection_limit"] = String(detectionLimit)
        }
        
        if let detectionSensitivity = detectionSensitivity {
            dict["detection_sensitivity"] = detectionSensitivity
        }
        
        if let searchAllObjects = searchAllObjects {
            dict["search_all_objects"] = searchAllObjects ? "true" : "false"
        }
        
        return dict
    }
}
