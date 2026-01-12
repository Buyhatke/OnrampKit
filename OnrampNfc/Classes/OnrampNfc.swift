//
//  OnrampNfc.swift
//  OnrampNfc
//
//  Optional NFC module for OnrampKit
//

import Foundation
import OnrampKit

@available(iOS 13.0, *)
public class OnrampNfc {
    private static var _isInitialized = false

    /// Initialize NFC functionality
    /// Call this in AppDelegate.didFinishLaunchingWithOptions or before using the SDK
    @objc public static func setup() {
        if !_isInitialized {
            NfcManager.registerHandler(OnrampNfcHandler())
            _isInitialized = true
            print("OnrampNfc: NFC module initialized")
        }
    }

    /// Disable NFC functionality
    @objc public static func disable() {
        NfcManager.unregisterHandler()
        _isInitialized = false
        print("OnrampNfc: NFC module disabled")
    }

    /// Check if NFC is initialized
    @objc public static func isInitialized() -> Bool {
        return _isInitialized
    }
}
