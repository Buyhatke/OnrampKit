//
//  OnrampNfcHandler.swift
//  OnrampNfc
//
//  NFC handler implementation using Udentify frameworks
//

import UIKit
import OnrampKit
import UdentifyCommons
import UdentifyNFC

class OnrampNfcHandler: NfcHandler {
    private var nfcReader: NFCReader?

    func readNfc(
        viewController: UIViewController,
        docNo: String,
        dateOfBirth: String,
        expireDate: String,
        serverUrl: String,
        transactionId: String,
        isActiveAuthenticationEnabled: Bool,
        isPassiveAuthenticationEnabled: Bool,
        callback: NfcCallback
    ) {
        DispatchQueue.main.async {
            // Load Udentify remote language pack BEFORE NFCReader starts
            let systemLang = UdentifySettingsProvider.mapSystemLanguageToEnum() ?? .EN

            UdentifySettingsProvider.instantiateServerBasedLocalization(
                for: systemLang,
                serverUrl: serverUrl,
                transactionId: transactionId
            ) { error in
                // even if error occurs, fallback localization works automatically

                // Now start NFC reader which will show fully localized UI
                self.startNfcReader(
                    docNo: docNo,
                    dateOfBirth: dateOfBirth,
                    expireDate: expireDate,
                    serverUrl: serverUrl,
                    transactionId: transactionId,
                    isActiveAuthenticationEnabled: isActiveAuthenticationEnabled,
                    isPassiveAuthenticationEnabled: isPassiveAuthenticationEnabled,
                    callback: callback
                )
            }
        }
    }

    private func startNfcReader(
        docNo: String,
        dateOfBirth: String,
        expireDate: String,
        serverUrl: String,
        transactionId: String,
        isActiveAuthenticationEnabled: Bool,
        isPassiveAuthenticationEnabled: Bool,
        callback: NfcCallback
    ) {
        self.nfcReader = NFCReader(
            documentNumber: docNo,
            dateOfBirth: dateOfBirth,
            expiryDate: expireDate,
            transactionID: transactionId,
            serverURL: serverUrl,
            isActiveAuthenticationEnabled: isActiveAuthenticationEnabled,
            isPassiveAuthenticationEnabled: isPassiveAuthenticationEnabled
        )

        self.nfcReader?.read() { [weak self] passport, error, progress in
            guard let self = self else { return }

            if let passport = passport {
                DispatchQueue.main.async {
                    do {
                        let encodablePassport = EncodablePassport(passport: passport)
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted

                        let jsonData = try encoder.encode(encodablePassport)

                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            callback.onSuccess(cardData: jsonString)
                        } else {
                            callback.onError(error: "ENCODING_ERROR")
                        }
                    } catch {
                        callback.onError(error: "JSON encoding failed: \(error.localizedDescription)")
                    }

                    self.nfcReader = nil
                }
            } else if let progress = progress {
                callback.onProgress(progress: String(progress))

            } else if let error = error {
                callback.onError(error: error.localizedDescription)
                DispatchQueue.main.async {
                    self.nfcReader = nil
                }
            }
        }
    }
}
