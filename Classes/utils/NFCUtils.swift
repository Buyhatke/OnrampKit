//
//  NFCUtils.swift
//  OnrampKit
//
//  Created by PrashantDixit on 03/06/25.
//

import CoreNFC
import Foundation

class NFCUtils {
    
    static func isNfcSupported() -> Bool {
        if #available(iOS 11.0, *) {
            return NFCNDEFReaderSession.readingAvailable
        } else {
            return false
        }
    }
}
