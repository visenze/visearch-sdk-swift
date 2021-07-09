//
//  ViRecParams.swift
//  ViSearchSDK
//
//  Created by Hung on 9/7/21.
//  Copyright © 2021 Hung. All rights reserved.
//

import UIKit

public class ViRecParams: ViSearchParams {
    public var algorithm: String?
    
    public var altLimit: Int?
    
    public var dedupBy: String?
    
    
    public override init?(imName: String) {
        super.init(imName: imName)
    }
    
    public override func toDict() -> [String: Any] {
        var dict = super.toDict()
        
        if let algorithm = self.algorithm {
            dict["algorithm"] = algorithm
        }
        
        if let altLimit = self.altLimit {
            dict["alt_limit"] = String(altLimit)
        }
        
        if let dedupBy = self.dedupBy {
            dict["dedup_by"] = dedupBy
        }
        
        return dict;
    }

}
