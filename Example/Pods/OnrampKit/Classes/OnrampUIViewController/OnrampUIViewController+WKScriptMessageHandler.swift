//
//  OnrampUIViewController+WKScriptMessageHandler.swift
//  OnrampKit
//
//  Created by PrashantDixit on 18/08/23.
//

import WebKit

extension OnrampUIViewController: WKScriptMessageHandler {
    
    func showCancelTransactionAlert() {
        let alertController = UIAlertController(title: "Cancel Transaction? ", message: "Are you sure you want to cancel & exit the transaction?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        let okAction = UIAlertAction(title: "Yes, Cancel", style: .destructive) { _ in
            self.dismiss(animated: true)
            self.delegate?.onDataChanged(OnrampEventResponse(type: "ONRAMP_WIDGET_APP_CLOSED", data: EventData(msg: "Transaction Cancelled!", fiatAmount: nil, cryptoAmount: nil, coinRate: nil, paymentMethod: nil), isOnramp: true))
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
                    delegate?.onDataChanged(decodedResponse)
                } catch {
                    print("Error decoding JSON:", error)
                }
            }
        }
    }
}

