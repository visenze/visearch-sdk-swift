//
//  SettingHelper.swift
//  ViSenzeAnalytics
//
//  Created by Hung on 8/9/20.
//  Copyright © 2020 ViSenze. All rights reserved.
//

import UIKit

open class SettingHelper: NSObject {

    public static func setBoolSettingProp(propName: String , newValue: Bool) -> Void {
        let userDefault = UserDefaults.standard
        userDefault.set(newValue, forKey: propName)
    }
    
    public static func getBoolSettingProp (propName: String) -> Bool? {
       let userDefault = UserDefaults.standard
       return userDefault.bool(forKey: propName)
    }
    
    public static func getInt64Prop(propName: String) -> Int64 {
        if let storeString = getStringSettingProp(propName: propName) {
            if let num = Int64(storeString) {
                return num
            }
        }
        
        return 0;
    }
    
    public static func setInt64Prop(propName: String, newValue: Int64) {
        return setSettingProp(propName: propName, newValue: String(newValue))
    }
    
    /// Set a property , store in userDefault
    ///
    /// - parameter propName: property name
    /// - parameter newValue: new value for property
    public static func setSettingProp(propName: String , newValue: Any?) -> Void {
        let userDefault = UserDefaults.standard
        userDefault.set(newValue, forKey: propName)
    }
    
    
    /// retrieve setting in userdefault as String
    ///
    /// - parameter propName: name of property
    ///
    /// - returns: value as String?
    public static func getStringSettingProp (propName: String) -> String? {
        let userDefault = UserDefaults.standard
        return userDefault.string(forKey: propName)
    }
}
