//
//  ViAutoCompleteItem.swift
//  ViSearchSDK
//
//  Created by Hung on 27/11/23.
//  Copyright © 2023 Hung. All rights reserved.
//

import Foundation

open class ViAutoCompleteItem {
    public var text : String
    public var score : Double? = nil
    
    public init(text: String) {
        self.text = text
    }
}
