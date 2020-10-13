//
//  VaSessionManager.swift
//  ViSenzeAnalytics
//
//  Created by Hung on 9/9/20.
//  Copyright © 2020 ViSenze. All rights reserved.
//

import UIKit

public class VaSessionManager: NSObject {
    public static let sharedInstance = VaSessionManager()
    
    static let sidKey = "visenze_sid"
    static let sidTimestampKey = "visenze_sid_ts"
    static let sessionTimeout : Int = 1800000 // 30 mins
    static let DAY_IN_MS : Int64 = 86400000;
    
    private override init() {
        super.init()
    }
    
    public func getSessionId() -> String{
        let newSid = generateSessionId()
        
        // check if session expired, if so generate new sessionID
        if isSessionExpired() {
            // save
            saveSessionId(newSid)
            saveSessionTimestamp()
            
            return newSid
        }
        
        if let storedSid = SettingHelper.getStringSettingProp(propName: VaSessionManager.sidKey) {
            return storedSid
        }
        
        return newSid
    }
    
    public func isSessionExpired() -> Bool {
        let now = getCurrentTimestamp()
        let storedTs = SettingHelper.getInt64Prop(propName: VaSessionManager.sidTimestampKey)
        
        return (now - storedTs > VaSessionManager.sessionTimeout) || !isSameDay(storedTs, now)
    }
        
    private func isSameDay(_ storedTs: Int64, _ now: Int64) -> Bool{
        let d1 = storedTs / VaSessionManager.DAY_IN_MS;
        let d2 = now / VaSessionManager.DAY_IN_MS;
        return d1 == d2;
    }
    
    private func saveSessionId(_ sid: String) {
        SettingHelper.setSettingProp(propName: VaSessionManager.sidKey, newValue: sid)
    }
    
    private func saveSessionTimestamp() -> Int64{
        let now = getCurrentTimestamp()
        SettingHelper.setInt64Prop(propName: VaSessionManager.sidTimestampKey, newValue: now)
        return now
    }
    
    // generate random sid
    private func generateSessionId() -> String {
        return UUID().uuidString
    }
    
    public func getUid() -> String {
        return VaUidHelper.uniqueDeviceUid()
    }
    
    public func getCurrentTimestamp() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
}
