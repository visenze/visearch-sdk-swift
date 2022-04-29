//
//  ViExperiment.swift
//  ViSearchSDK
//
//  Created by Hung on 29/4/22.
//  Copyright © 2022 Hung. All rights reserved.
//

import Foundation

open class ViExperiment: NSObject {
    public var experimentId : Int? = nil
    public var variantId : Int? = nil
    public var variantName: String? = nil
    public var strategyId : Int? = nil
    public var expNoRecommendation: Bool = false
}
