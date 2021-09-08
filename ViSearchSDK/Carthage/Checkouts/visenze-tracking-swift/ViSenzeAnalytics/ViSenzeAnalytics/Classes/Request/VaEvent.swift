//
//  VaEvent.swift
//  ViSenzeAnalytics
//
//  Created by Hung on 8/9/20.
//  Copyright © 2020 ViSenze. All rights reserved.
//

import UIKit

/// Protocol to generate dictionary for query parameters (in the URL)
public protocol VaParamsProtocol{
    
    
    /// Generate dictionary of parameters , will be appended into query string
    ///
    /// - returns: dictionary
    func toDict() -> [String: String]
}

// predefine events
public enum VaEventAction: String {
    case PRODUCT_CLICK  = "product_click"
    case PRODUCT_VIEW = "product_view"
    case VIEW = "view"
    case CLICK = "click"
    case SEARCH = "search"
    case APP_INSTALL = "app_install"
    case APP_UNINSTALL = "app_uninstall"
    case TRANSACTION = "transaction"
    case ADD_TO_CART = "add_to_cart"
    case RESULT_LOAD = "result_load"
}

public class VaEvent: VaParamsProtocol {

    // MARK: common fields
    
    /// event category
    public var category: String? = nil
    
    // action
    public var action: String
    
    // event name
    public var name: String? = nil
    
    // Linux timestamp
    public var ts: Int64
    
    public var value: String? = nil
    
    public var label: String? = nil
        
    public var queryId: String? = nil
    
    public var fromReqId: String? = nil
    
    public var uid: String? = nil
    
    public var sid: String? = nil
    
    public var source: String? = nil
    
    // product ID
    public var pid: String? = nil
    
    // image URL
    public var imUrl: String? = nil
    
    // position of product in search result
    public var pos: Int? = nil
    
    public var brand: String? = nil
    
    public var price: Double? = nil
    
    public var currency: String? = nil
    
    public var productUrl: String? = nil
    
    public var transId: String? = nil
    
    public var url: String? = nil
    
    public var referrer: String? = nil
    
    // MARK: device fields
    public var aaid: String? = nil
    
    public var didmd5: String? = nil
    
    public var geo: String? = nil
    
    // MARK: other fields
    public var campaign: String? = nil
    public var adGroup: String? = nil
    public var creative: String? = nil
    
    public var n1: Double? = nil
    public var n2: Double? = nil
    public var n3: Double? = nil
    public var n4: Double? = nil
    public var n5: Double? = nil
    
    public var s1: String? = nil
    public var s2: String? = nil
    public var s3: String? = nil
    public var s4: String? = nil
    public var s5: String? = nil
    
    public var json: String? = nil

    
    // this is for custom event
    public init?(action: String){
        if action.isEmpty {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: action parameter is missing")
            return nil
        }
        self.action = action
        self.ts = Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    // MARK: event constructor helpers
    public static func newSearchEvent(queryId: String) -> VaEvent? {
        if queryId.isEmpty {
            print("ViSenze Analytics - missing queryId for search event")
            return nil
        }
        
        let searchEvent = VaEvent(action: VaEventAction.SEARCH.rawValue)
        searchEvent?.queryId = queryId
        return searchEvent
    }
    
    public static func newProductClickEvent(queryId: String, pid: String, imgUrl: String, pos: Int) -> VaEvent? {
        if queryId.isEmpty || pid.isEmpty || imgUrl.isEmpty{
            print("ViSenze Analytics - missing queryId or pid or imgUrl for product click event")
            return nil
        }
        
        if pos < 1 {
            print("ViSenze Analytics - pos (product position in search results) must be at least 1")
            
            return nil
        }
        
        let productClick = VaEvent(action: VaEventAction.PRODUCT_CLICK.rawValue)
        productClick?.queryId = queryId
        productClick?.pid = pid
        productClick?.imUrl = imgUrl
        productClick?.pos = pos
        return productClick
    }
    
    public static func newProductImpressionEvent(queryId: String, pid: String, imgUrl: String, pos: Int) -> VaEvent? {
        if queryId.isEmpty || pid.isEmpty || imgUrl.isEmpty{
            print("ViSenze Analytics - missing queryId or pid or imgUrl for product impression event")
            return nil
        }
        
        if pos < 1 {
            print("ViSenze Analytics - pos (product position in search results) must be at least 1")
            
            return nil
        }
        
        let productView = VaEvent(action: VaEventAction.PRODUCT_VIEW.rawValue)
        productView?.queryId = queryId
        productView?.pid = pid
        productView?.imUrl = imgUrl
        productView?.pos = pos
        return productView
    }
    
    public static func newAdd2CartEvent(queryId: String, pid: String, imgUrl: String, pos: Int) -> VaEvent? {
        if queryId.isEmpty || pid.isEmpty || imgUrl.isEmpty{
            print("ViSenze Analytics - missing queryId or pid or imgUrl for add to cart event")
            return nil
        }
        
        if pos < 1 {
            print("ViSenze Analytics - pos (product position in search results) must be at least 1")
            
            return nil
        }
        
        let add2Cart = VaEvent(action: VaEventAction.ADD_TO_CART.rawValue)
        add2Cart?.queryId = queryId
        add2Cart?.pid = pid
        add2Cart?.imUrl = imgUrl
        add2Cart?.pos = pos
        return add2Cart
    }
    
    public static func newTransactionEvent(queryId: String, transactionId: String, value: Double) -> VaEvent? {
        if queryId.isEmpty {
            print("ViSenze Analytics - queryId is missing for transaction event")
            return nil
        }
        
        if transactionId.isEmpty {
            print("ViSenze Analytics - transactionId is missing for transaction event")
            return nil
        }
        
        let transEvnt = VaEvent(action: VaEventAction.TRANSACTION.rawValue)
        transEvnt?.queryId = queryId
        transEvnt?.transId = transactionId
        transEvnt?.value = String(value)
        
        return transEvnt
    }
    
    public static func newResultLoadEvent(queryId: String, pid: String?) -> VaEvent? {
        if queryId.isEmpty {
            print("ViSenze Analytics - queryId is missing for result_load event")
            return nil
        }
        
    
        let resultLoadEvt = VaEvent(action: VaEventAction.RESULT_LOAD.rawValue)
        resultLoadEvt?.queryId = queryId
        resultLoadEvt?.pid = pid
        
        return resultLoadEvt
    }
    
    
    public static func newClickEvent() -> VaEvent? {
        return VaEvent(action: VaEventAction.CLICK.rawValue)
    }
    
    public static func newImpressionEvent() -> VaEvent? {
        return VaEvent(action: VaEventAction.VIEW.rawValue)
    }
    
    
    // MARK: param protocol
    
    public func toDict() -> [String: String] {
        var dict : [String:String] = [:]
        
        dict["action"] = action
        dict["ts"] = String(ts)
        
        if let category = self.category {
            dict["cat"] = category
        }
        
        if let name = self.name {
            dict["name"] = name
        }
        
        if let value = self.value {
            dict["value"] = value
        }
        
        if let label = self.label {
            dict["label"] = label
        }
        
        if let queryId = self.queryId {
            dict["queryId"] = queryId
        }
        
        if let fromReqId = self.fromReqId {
            dict["fromReqId"] = fromReqId
        }
        
        if let uid = self.uid {
            dict["uid"] = uid
        }
        
        if let sid = self.sid {
            dict["sid"] = sid
        }
        
        if let source = self.source {
            dict["source"] = source
        }
        
        if let pid = self.pid {
            dict["pid"] = pid
        }
        
        if let imUrl = self.imUrl {
            dict["imUrl"] = imUrl
        }
        
        if let pos = self.pos {
            dict["pos"] = String(pos)
        }
        
        if let brand = self.brand {
            dict["brand"] = brand
        }
        
        if let price = self.price {
            dict["price"] = String(price)
        }
        
        if let currency = self.currency {
            dict["currency"] = currency
        }
        
        if let productUrl = self.productUrl {
            dict["productUrl"] = productUrl
        }
        
        if let transId = self.transId {
            dict["transId"] = transId
        }
        
        if let url = self.url {
            dict["url"] = url
        }
        
        if let referrer = self.referrer {
            dict["r"] = referrer
        }
        
        if let aaid = self.aaid {
            dict["aaid"] = aaid
        }
        
        if let didmd5 = self.didmd5 {
            dict["didmd5"] = didmd5
        }
        
        if let geo = self.geo {
            dict["geo"] = geo
        }
        
        if let campaign = self.campaign {
            dict["c"] = campaign
        }
        
        if let adGroup = self.adGroup {
            dict["cag"] = adGroup
        }
        
        if let creative = self.creative {
            dict["cc"] = creative
        }
        
        if let n1 = self.n1 {
            dict["n1"] = String(n1)
        }
        
        if let n2 = self.n2 {
            dict["n2"] = String(n2)
        }
        
        if let n3 = self.n3 {
            dict["n3"] = String(n3)
        }
        
        if let n4 = self.n4 {
            dict["n4"] = String(n4)
        }
        
        if let n5 = self.n5 {
            dict["n5"] = String(n5)
        }
        
        if let s1 = self.s1 {
            dict["s1"]  = s1
        }
        
        if let s2 = self.s2 {
           dict["s2"]  = s2
        }
        
        if let s3 = self.s3 {
           dict["s3"]  = s3
        }
        
        if let s4 = self.s4 {
           dict["s4"]  = s4
        }
        
        if let s5 = self.s5 {
           dict["s5"]  = s5
        }
        
        if let json = self.json {
            dict["json"] = json
        }
        
        return dict
    }
}
