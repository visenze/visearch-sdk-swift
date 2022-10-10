//
//  ViSenzeAnalytics.swift
//  ViSenzeAnalytics
//
//  Created by Hung on 8/9/20.
//  Copyright © 2020 ViSenze. All rights reserved.
//

import UIKit

public class ViSenzeAnalytics: NSObject {
    public static let sharedInstance = ViSenzeAnalytics()
    
    private override init(){
        super.init()
    }
    
    public func newTracker(code: String) -> ViSenzeTracker {
        return ViSenzeTracker(code: code, isCn: false)!
    }
    
    /// Setup API client. Must be called first before various API calls
    ///
    /// - parameter appKey: application app key
    /// - parameter country: which country to search
    public func newTracker(code: String, forCn: Bool) -> ViSenzeTracker {
        return ViSenzeTracker(code: code, isCn: forCn)!
    }
}
