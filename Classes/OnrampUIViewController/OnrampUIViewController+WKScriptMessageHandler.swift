//
//  OnrampUIViewController+WKScriptMessageHandler.swift
//  OnrampKit
//
//  Created by PrashantDixit on 18/08/23.
//

import WebKit

@available(iOS 13.0, *)
extension OnrampUIViewController: WKScriptMessageHandler {
    
    func showCancelTransactionAlert() {
        let alertController = UIAlertController(title: "Close Widget?", message: "Are you sure you want to leave & close the widget?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.delegate?.onDataChanged(OnrampEventResponse(type: "ONRAMP_WIDGET_CLOSE_REQUEST_CANCELLED", data: EventData(msg: "Close widget request cancelled by the user.", fiatAmount: nil, cryptoAmount: nil, coinRate: nil, paymentMethod: nil), isOnramp: true))
        }
        
        let okAction = UIAlertAction(title: "Yes, Close", style: .destructive) { _ in
            self.dismiss(animated: true)
            self.delegate?.onDataChanged(OnrampEventResponse(type: "ONRAMP_WIDGET_CLOSE_REQUEST_CONFIRMED", data: EventData(msg: "Widget closed", fiatAmount: nil, cryptoAmount: nil, coinRate: nil, paymentMethod: nil), isOnramp: true))
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }

    public func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {

        if message.name == "iosNativeEvent" {
            if let jsonData = (message.body as? String)?.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(OnrampEventResponse.self, from: jsonData)
                    if(decodedResponse.type == "ONRAMP_WIDGET_CLOSE_REQUEST" ){
                        showCancelTransactionAlert()
                    }
                    // in case any of these events occur, close the widget automatically
                    if(decodedResponse.type == "ONRAMP_WIDGET_TX_COMPLETED" || decodedResponse.type == "ONRAMP_WIDGET_TX_SENDING_FAILED" || decodedResponse.type == "ONRAMP_WIDGET_TX_PURCHASING_FAILED" || decodedResponse.type == "ONRAMP_WIDGET_TX_FINDING_FAILED" ||
                       decodedResponse.type == "ONRAMP_WIDGET_FAILED" || decodedResponse.type == "ONRAMP_WIDGET_TX_FAILED"
                    ) {
                        Onramp.stopOnrampSDK(self)
                    }
                    delegate?.onDataChanged(decodedResponse)
                } catch {
                    print("Error decoding JSON:", error)
                }
            }
        }
    }
}

