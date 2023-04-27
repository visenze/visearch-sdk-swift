# visenze-tracking-swift

ViSenze Swift SDK for data tracking.

## 1. Overview

Visenze Tracking library allows you to analyse visual search solutions' performance by sending user actions such as product click, impression, add to cart, transaction.

## 2. Setup

You can use CocoaPods to install the SDK. Edit the Podfile as follows:

```
platform :ios, '12.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ViSenzeAnalytics', '~>0.2.0'
end
...
```

Install the SDK

```
pod install
```

## 3. Initialization

You can initiliase ViSenze tracker with a tracking ID (code) by logging to ViSenze dashboard. 

```
let tracker = ViSenzeAnalytics.sharedInstance.newTracker(code: "your-code")
        
```

## 4. Send Event

You can send various events as follow. Note that it is optional to send transaction ID, product image URL and product position. You can create the event using the corresponding methods such as `VaEvent. VaEvent.newProductClickEvent (queryId: "", pid: "")` if you do not have other data.

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

User action(s) can also be sent through an batch event handler.

A common use case for this batch event method is to group up all transactions by sending it in a batch. This SDK will automatically generate a transaction ID to group transactions as an order.

```
tracker.sendEvents(eventList)
```


