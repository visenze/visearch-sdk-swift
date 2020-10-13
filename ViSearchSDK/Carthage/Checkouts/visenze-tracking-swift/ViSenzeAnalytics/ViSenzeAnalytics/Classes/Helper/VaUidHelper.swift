//
//  UidHelper.swift
//  ViSenzeAnalytics
//
//  Created by Hung on 8/9/20.
//  Copyright © 2020 ViSenze. All rights reserved.
//

import UIKit

public class VaUidHelper: NSObject {

    /// Internal key for storing uid
    static let ViSenzeUidKey = "visenze_uid"
    
    /// retrieve unique device uid and store into userDefaults
    /// this is needed for tracking API to identify various actions
    ///
    /// - returns: unique device uid
    public static func uniqueDeviceUid() -> String {
        let storeUid = SettingHelper.getStringSettingProp(propName: ViSenzeUidKey)
        
        if storeUid == nil || storeUid?.count == 0 {
            let deviceId = UIDevice.current.identifierForVendor?.uuidString ;
            
            // store in the setting
            SettingHelper.setSettingProp(propName: ViSenzeUidKey, newValue: deviceId!)
            
            return deviceId!
        }
        
        return storeUid!
    }
    
    
    /// Force update the device uid and store in setting
    ///
    /// - parameter newUid: new device uid
    public static func updateStoreDeviceUid(newUid: String) -> Void {
        SettingHelper.setSettingProp(propName: ViSenzeUidKey, newValue: newUid)
    }
}
