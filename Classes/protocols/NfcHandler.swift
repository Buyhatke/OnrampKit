//
//  NfcHandler.swift
//  OnrampKit
//
//  Protocol definition for NFC functionality
//

import UIKit

public protocol NfcHandler {
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
    )
}

public protocol NfcCallback {
    func onSuccess(cardData: String)
    func onError(error: String)
    func onProgress(progress: String)
}
