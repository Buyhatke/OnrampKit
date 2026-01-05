//
//  NfcManager.swift
//  OnrampKit
//
//  NFC handler registry for optional NFC functionality
//

import Foundation

public class NfcManager {
    private static var nfcHandler: NfcHandler?

    /// Register an NFC handler implementation
    public static func registerHandler(_ handler: NfcHandler) {
        nfcHandler = handler
    }

    /// Unregister the current NFC handler
    public static func unregisterHandler() {
        nfcHandler = nil
    }

    /// Get the registered NFC handler
    public static func getHandler() -> NfcHandler? {
        return nfcHandler
    }

    /// Check if NFC functionality is available
    public static func isNfcEnabled() -> Bool {
        return nfcHandler != nil
    }
}
