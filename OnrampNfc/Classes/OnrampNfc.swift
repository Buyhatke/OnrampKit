//
//  OnrampNfc.swift
//  OnrampNfc
//
//  Optional NFC module for OnrampKit
//

import Foundation
import OnrampKit

public class OnrampNfc {
    private static var isInitialized = false

    /// Initialize NFC functionality
    /// Call this in AppDelegate.didFinishLaunchingWithOptions or before using the SDK
    @objc public static func initialize() {
        if !isInitialized {
            NfcManager.registerHandler(OnrampNfcHandler())
            isInitialized = true
            print("OnrampNfc: NFC module initialized")
        }
    }

    /// Disable NFC functionality
    @objc public static func disable() {
        NfcManager.unregisterHandler()
        isInitialized = false
        print("OnrampNfc: NFC module disabled")
    }

    /// Check if NFC is initialized
    @objc public static func isInitialized() -> Bool {
        return isInitialized
    }
}
