//
//  StringHelper.swift
//  ViSenzeAnalytics
//
//  Created by Hung on 13/10/20.
//  Copyright © 2020 ViSenze. All rights reserved.
//

import UIKit

public class StringHelper: NSObject {

    public static func limitMaxLength(_ s: String, _ limit: Int) -> String {
        if (s.count <= limit) {
            return s
        }
        
        return String(s.prefix(limit))
    }
}
