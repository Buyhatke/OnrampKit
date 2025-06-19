//
//  OnrampUIViewController+UIDocumentPickerDelegate.swift
//  OnrampKit
//
//  Created by PrashantDixit on 18/06/25.
//

import Foundation

@available(iOS 13.0, *)
extension OnrampUIViewController: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        fileUploadCompletionHandler?(urls)
        fileUploadCompletionHandler = nil
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        fileUploadCompletionHandler?(nil)
        fileUploadCompletionHandler = nil
    }
}
