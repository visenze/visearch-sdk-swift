//
//  VaError.swift
//  ViSenzeAnalytics
//
//  Created by Hung on 9/9/20.
//  Copyright © 2020 ViSenze. All rights reserved.
//

import UIKit

public class VaError: NSObject {
    public let code: Int
    public let message: String
    
    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}
