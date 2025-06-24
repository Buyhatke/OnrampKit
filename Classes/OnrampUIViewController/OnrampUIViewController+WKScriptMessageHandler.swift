//
//  OnrampUIViewController+WKScriptMessageHandler.swift
//  OnrampKit
//
//  Created by PrashantDixit on 18/08/23.
//

import WebKit
import UdentifyCommons
import UdentifyNFC

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
        guard message.name == "iosNativeEvent" else { return }
        
        if let jsonString = message.body as? String,
           let jsonData = jsonString.data(using: .utf8) {
            if let decodedResponse = try? JSONDecoder().decode(OnrampEventResponse.self, from: jsonData) {
                if decodedResponse.type == "ONRAMP_WIDGET_CLOSE_REQUEST" {
                    if Constants.hideCloseSDKModelAppIdList.contains(appId) {
                        Onramp.stopOnrampSDK(self)
                        self.delegate?.onDataChanged(OnrampEventResponse(
                            type: "ONRAMP_WIDGET_CLOSE_REQUEST_CONFIRMED",
                            data: EventData(msg: "Widget closed", fiatAmount: nil, cryptoAmount: nil, coinRate: nil, paymentMethod: nil),
                            isOnramp: true
                        ))
                    } else {
                        showCancelTransactionAlert()
                    }
                }

                // Auto-close on transaction events
                if [
                    "ONRAMP_WIDGET_TX_COMPLETED",
                    "ONRAMP_WIDGET_TX_SENDING_FAILED",
                    "ONRAMP_WIDGET_TX_PURCHASING_FAILED",
                    "ONRAMP_WIDGET_TX_FINDING_FAILED",
                    "ONRAMP_WIDGET_FAILED",
                    "ONRAMP_WIDGET_TX_FAILED",
                    "ONRAMP_WIDGET_CLOSE_REQUEST_CONFIRMED"
                ].contains(decodedResponse.type) {
                    Onramp.stopOnrampSDK(self)
                }

                delegate?.onDataChanged(decodedResponse)
                return
            }

            if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
               let json = jsonObject as? [String: Any],
               let action = json["action"] as? String,
               let payload = json["payload"] as? [String: Any] {

                switch action {
                case "startNfc":
                    DispatchQueue.main.async {
                        self.handleFetchNfcData(payload: payload)
                    }
                default:
                    print("Unhandled action: \(action)")
                }
                return
            }

            print("Unhandled message format or failed decoding both types.")
        }
    }
    
    func handleFetchNfcData(payload: [String: Any]) {
        let transactionId = payload["transactionId"] as? String
        let documentNo = payload["documentNo"] as? String
        let dob = payload["dob"] as? String
        let expiryDate = payload["expiryDate"] as? String

        guard let txnId = transactionId, !txnId.isEmpty else {
            sendEventsToWeb(type: Constants.TYPE_NFC_RESPONSE, status: Constants.ERROR, message: "Transaction Id not found")
            return
        }

        guard
            let docNo = documentNo, !docNo.isEmpty,
            let birthDate = dob, !birthDate.isEmpty,
            let expDate = expiryDate, !expDate.isEmpty
        else {
            sendEventsToWeb(type: Constants.TYPE_NFC_RESPONSE, status: Constants.ERROR, message: "Please fill all the fields")
            return
        }

        print("Initiating NFC with:")
        print("Transaction ID: \(txnId)")
        print("Document No: \(docNo)")
        print("DOB: \(birthDate)")
        print("Expiry Date: \(expDate)")

        DispatchQueue.main.async {
            let nfcReader = NFCReader(
                documentNumber: docNo,
                dateOfBirth: birthDate,
                expiryDate: expDate,
                transactionID: txnId,
                serverURL: Constants.UDENTIFY_SERVER_URL,
                isActiveAuthenticationEnabled: true,
                isPassiveAuthenticationEnabled: false
            )
            
            nfcReader.read() { passport, error, progress in
                if let passport = passport {
                    DispatchQueue.main.async {
                        let encodablePassport = EncodablePassport(passport: passport)
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted

                        if let jsonData = try? encoder.encode(encodablePassport),
                           let jsonString = String(data: jsonData, encoding: .utf8) {

                            self.sendEventsToWeb(
                                type: Constants.TYPE_NFC_RESPONSE,
                                status: Constants.SUCCESS,
                                message: jsonString
                            )
                        } else {
                            self.sendEventsToWeb(
                                type: Constants.TYPE_NFC_RESPONSE,
                                status: Constants.ERROR,
                                message: "Failed to encode NFC Response"
                            )
                        }
                    }
                } else if let progress = progress {
                    print("*********** \(progress)% ***********")
                    self.sendEventsToWeb(type: Constants.TYPE_NFC_PROGRESS, progress: String(progress))
                } else if let error = error {
                    print("Passport reading failed: \(error)")
                    self.sendEventsToWeb(type: Constants.TYPE_NFC_RESPONSE, status: Constants.ERROR, message: error.localizedDescription)
                }
            }
        }
    }

    
    func sendEventsToWeb(type: String, status: String? = nil, message: String? = nil, progress: String? = nil) {
        var messageData: [String: Any] = ["type": type]

        if let status = status, !status.isEmpty {
            messageData["status"] = status
        }
        if let message = message, !message.isEmpty {
            messageData["message"] = message
        }
        if let progress = progress, !progress.isEmpty {
            messageData["progress"] = progress
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: messageData, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("Failed to serialize message data")
            return
        }

        let escapedJsonString = jsonString.replacingOccurrences(of: "\\", with: "\\\\")
                                         .replacingOccurrences(of: "\"", with: "\\\"")
                                         .replacingOccurrences(of: "\n", with: "\\n")
                                         .replacingOccurrences(of: "\r", with: "\\r")
        let jsCode = "window.postMessage('\(escapedJsonString)', '*'); true;"
        DispatchQueue.main.async { [weak self] in
            self?.webView.evaluateJavaScript(jsCode) { _, error in
                if let error = error {
                    print("Error injecting JS: \(error.localizedDescription)")
                }
            }
        }
    }
}

