//
//  ViObjectResult.swift
//  ViSearchSDK
//
//  Created by Hung on 24/11/17.
//  Copyright © 2017 Hung. All rights reserved.
//

import UIKit

open class ViObjectResult: NSObject {
    public var type  : String
    public var attributes : [String: Any] = [:]
    public var box   : ViBox?
    public var point : ViPoint?
    public var score : Float = 0
    public var total : Int = 0
    public var result: [ViImageResult] = []
    public var facets : [ViFacet] = []
    
    public init(type: String) {
        self.type = type
    }
}
