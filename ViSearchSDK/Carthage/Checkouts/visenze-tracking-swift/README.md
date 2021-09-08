# visenze-tracking-swift

ViSenze Swift SDK for data tracking.

## 1. Overview

Visenze Tracking library allows you to analyse visual search solutions' performance by sending user actions such as product click, impression, add to cart, transaction.

## 2. Setup

You can use CocoaPods to install the SDK. Edit the Podfile as follows:

```
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ViSenzeAnalytics', '~>0.1.3'
end
...
```

Install the SDK

```
pod install
```

## 3. Initialization

You can initiliase ViSenze tracker with a tracking ID (code) by logging to ViSenze dashboard. There are two different endpoints for tracker (1 for China and another for the rest of the world). If the SDK is intended to be used outside of China, please set `forCn` parameter to false


```
let tracker = ViSenzeAnalytics.sharedInstance.newTracker(code: "your-code", forCn: false)
        
```

## 4. Send Event

You can send various events as follow:

```

# send product click
let productClickEvent = VaEvent.newProductClickEvent(queryId: "ViSearch reqid in API response", pid: "product ID", imgUrl: "product image URL", pos: 3)
tracker.sendEvent(productClickEvent) { (eventResponse, networkError) in
   
}

# send product impression
let impressionEvent = VaEvent.newProductImpressionEvent(queryId: "ViSearch reqid in API response", pid: "product ID", imgUrl: "product image URL", pos: 3)
tracker.sendEvent(impressionEvent)

# send Transaction event e.g order purchase of $300
let transEvent = VaEvent.newTransactionEvent(queryId: "xxx", transactionId:"your trans id", value: 300)
tracker.sendEvent(transEvent)

# send Add to Cart Event
let add2Cart = VaEvent.newAdd2CartEvent(queryId: "ViSearch reqid in API response", pid: "product ID", imgUrl: "product image URL", pos: 3)
tracker.sendEvent(add2Cart)

# send result load event
let resLoadEvent = VaEvent.newResultLoadEvent(queryId: "xxx", pid:"your query product id")
tracker.sendEvent(resLoadEvent)

```


