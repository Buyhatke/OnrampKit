# OnrampKit

This is the iOS SDK for Onramp payment gateway.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## General Requirements

The minimum requirements for the SDK are:

* iOS 15.0 and higher

## Installation

### Via CocoaPods
OnrampKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

Add sdk source to cocoapods

```ruby
source 'https://github.com/Buyhatke/onramp-ios-podspec.git'
```

```ruby
 pod 'OnrampKit'
```

Then, run the following command:

```ruby
 pod install
```

## Initialize the SDK

* Initialize the SDK by calling the ```startOnrampSDK``` function and pass the basic config parametes to start the sdk.
```
Onramp.startOnrampSDK(
  _ viewController:UIViewController, // reference to a UIViewController where the onrampKit's user interface will be presented.
  _ target: OnrampKitDelegate, //  An object conforming to the OnrampKitDelegate protocol. The delegate will receive callback and notifications.
  appId: 1, // replace this with the appID you got during onboarding process
  walletAddress: '0x495f519017eF0368e82Af52b4B64461542a5430B', // replace with user's wallet address
  flowtype: 1 // 1 -> onramp || 2 -> offramp || 3 -> Merchant checkout
  fiatType: 1 // 1 -> INR || 2 -> TRY
  paymentMethod: 1 // 1 -> Instant transafer(UPI) || 2 -> Bank transfer(IMPS/FAST)
  // ... pass other configs here
)
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
                 Onramp.stopOnrampSDK(self)
                // handle success code here
            case "ONRAMP_WIDGET_APP_CLOSED":
                 Onramp.stopOnrampSDK(self)
                // handle failure code here  
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

## Events Docs

Here is the list of all events:

* ONRAMP_WIDGET_READY -> sent when widget is ready for user interaction
* ONRAMP_WIDGET_FAILED -> sent when widget render failed due to multiple reasons like wrong params combination or missing params etc.
* ONRAMP_WIDGET_CLOSE_REQUEST_CONFIRMED -> sent when widget is closed
* ONRAMP_WIDGET_CONTENT_COPIED -> sent when copy to clipboard event is performed in widget, sends along the content copied.

* ONRAMP_WIDGET_APP_CLOSED -> sent when user request closes the widget and cancels the transaction.

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
