# OnrampKit

This is the iOS SDK for Onramp payment gateway.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## General Requirements

The minimum requirements for the SDK are:

* iOS 12.0 and higher

## Installation

### Via CocoaPods
OnrampKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
 pod 'OnrampKit'
```

Then, run the following command:

```ruby
 pod install
```

## Add LSApplicationQueriesSchemes 

* To allow your application to support UPI intent for Onramp, add the following code to enable UPI intents to the LSApplicationQueriesSchemes in the info.plist file of your project.

```ruby
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>paytmmp</string>
        <string>gpay</string>
        <string>bhim</string>
        <string>upi</string>
        <string>phonepe</string>
        ...
    </array>
```

* To allow your application to support Wallet Connect intent for Offramp, add the following code to enable WC intents to the LSApplicationQueriesSchemes in the info.plist file of your project.

```ruby
    <key>LSApplicationQueriesSchemes</key>
    <array>
        ...
        <string>wc</string>
        <string>metamask</string>
        <string>trust</string>
        <string>safe</string>
        <string>rainbow</string>
        <string>uniswap</string>
        <string>zerion</string>
        <string>imtokenv2</string>
    </array>
```



## Initialize the SDK

* Initialize the SDK by calling the ```startOnrampSDK``` function and pass the basic config parametes to start the sdk.
```
Onramp.startOnrampSDK(
  _ viewController:UIViewController, // reference to a UIViewController where the onrampKit's user interface will be presented.
  _ target: OnrampKitDelegate, //  An object conforming to the OnrampKitDelegate protocol. The delegate will receive callback and notifications.
  appId: 1, // replace this with the appID you got during onboarding process
  walletAddress: '0x49...430B', // replace with user's wallet address
  flowType: 1 // 1 -> onramp || 2 -> offramp || 3 -> Merchant checkout
  fiatType: 1 // 1 -> INR || 2 -> TRY
  paymentMethod: 1 // 1 -> Instant transafer(UPI) || 2 -> Bank transfer(IMPS/FAST)
  // ... pass other configs here
)
```

* Add the following line to check for ios availability check at the top of your View Controller class or where you will call the ```startOnrampSDK``` function
```
@available(iOS 13.0, *) // add this line
class ViewController: UIViewController {
...
}
```

## Listening to Custom Events
* Add ```OnrampKitDelegate``` interface to the declaration of your ViewController class in your project.

```
class ViewController: UIViewController, OnrampKitDelegate // add this to appropriate activity based on your business logic {
  ...
} 
```

* Implement the ```onDataChanged(_ data: OnrampEventResponse)``` method in your activity class.

```
     func onDataChanged(_ data: OnrampEventResponse) {
            // handle various sdk events based on type of event here

            //Example events usage:
        switch data.type {
            case "ONRAMP_WIDGET_TX_COMPLETED":
                // handle success code here
            case "ONRAMP_WIDGET_TX_FAILED":
                // handle failure code here 
            case "ONRAMP_WIDGET_CLOSE_REQUEST_CONFIRMED":
                // handle failure code here when user cancels the transaction  
             default:
                 return 
         }
    }
```

## About OnrampKit Lifecycle
At any time, you can disable the OnrampKit with the following code:

```
Onramp.stopOnrampSDK(
 _ viewController:UIViewController // reference to a UIViewController where the onrampKit's user interface will be presented.
)
```

## Initiate KYC SDK
To use the kyc widget in OnrampKit, initialize the ```initiateOnrampKyc``` function and pass the kyc config parametes (mandatory) to start the sdk.

```
Onramp.initiateOnrampKyc(
    _ viewController:UIViewController, // reference to a UIViewController where the onrampKit's user interface will be presented.
    _ target: OnrampKitDelegate, //  An object conforming to the OnrampKitDelegate protocol. The delegate will receive callback and notifications.
    appId: 1, // replace this with the appID you got during onboarding process
    payload:"enter payload string here",
    signature:"enter signature string here",
    customerId:"enter customerId here",
    apiKey:"enter apiKey here",
    lang:"en" // optional parameter, replace with desired language code
  
```

## Initiate Login SDK
* To use the login widget in OnrampKit, initialize the ```startOnrampLogin``` function and pass the config parametes to start the sdk.

```
Onramp.startOnrampLogin(
    _ viewController:UIViewController, // reference to a UIViewController where the onrampKit's user interface will be presented.
    _ target: OnrampKitDelegate, //  An object conforming to the OnrampKitDelegate protocol. The delegate will receive callback and notifications.
    appId: 1, // replace this with the appID you got during onboarding process
    closeAfterLogin: true/false, // toggle this value based on if you want to close widget after login or not
    lang:"en" // optional parameter, replace with desired language code
)
```

## Events Docs

Here is the list of all events:

* ONRAMP_WIDGET_READY -> sent when widget is ready for user interaction
* ONRAMP_WIDGET_FAILED -> sent when widget render failed due to multiple reasons like wrong params combination or missing params etc.
* ONRAMP_WIDGET_CONTENT_COPIED -> sent when copy to clipboard event is performed in widget, sends along the content copied.
* ONRAMP_WIDGET_CLOSE_REQUEST_CONFIRMED -> sent when widget is closed
* ONRAMP_WIDGET_CLOSE_REQUEST_CANCELLED -> sent when user dismisses close widget request modal.

* ONRAMP_WIDGET_TX_INIT -> when user sees the payment details on screen
* ONRAMP_WIDGET_TX_FINDING -> when user submits the reference number for INR deposit
* ONRAMP_WIDGET_TX_PURCHASING -> when system finds the deposit against reference / UTR submitted by user
* ONRAMP_WIDGET_TX_SENDING -> when system is done purchasing the crypto & starts withdrawal
* ONRAMP_WIDGET_TX_COMPLETED -> when system gets the tx hash for the deposit
* ONRAMP_WIDGET_TX_SENDING_FAILED -> if Failed before getting the tx hash
* ONRAMP_WIDGET_TX_PURCHASING_FAILED -> if failed while making the crypto purchase
* ONRAMP_WIDGET_TX_FINDING_FAILED -> if system failed at finding the deposit against the reference / UTR

## License

OnrampKit is available under the MIT license. See the LICENSE file for more info.

