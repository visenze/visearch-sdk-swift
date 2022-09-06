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
    
    public var showPinnedImNames: Bool? = nil
    
    public var showExcludedImNames: Bool? = nil
    
    public var useSetBasedCtl: Bool? = nil
    
    public var setLimit: Int?
    
    
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
        
        if let showPinnedImNames = showPinnedImNames {
            dict["show_pinned_im_names"] = showPinnedImNames ? "true" : "false"
        }
        
        if let showExcludedImNames = showExcludedImNames {
            dict["show_excluded_im_names"] = showExcludedImNames ? "true" : "false"
        }
        
        if let useSetBasedCtl = useSetBasedCtl {
            dict["use_set_based_ctl"] = useSetBasedCtl ? "true" : "false"
        }
        
        if let setLimit = self.setLimit {
            dict["set_limit"] = String(setLimit)
        }
        
        return dict;
    }

}
