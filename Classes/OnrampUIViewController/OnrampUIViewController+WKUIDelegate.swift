//
//  OnrampUIViewController+WKUIDelegate.swift
//  OnrampKit
//
//  Created by PrashantDixit on 30/01/24.
//

import Foundation
import WebKit

@available(iOS 13.0, *)
extension OnrampUIViewController: WKUIDelegate {
   public func webView(_ webView: WKWebView,
       createWebViewWith configuration: WKWebViewConfiguration,
       for navigationAction: WKNavigationAction,
       windowFeatures: WKWindowFeatures) -> WKWebView? {
      if navigationAction.targetFrame == nil, let url = navigationAction.request.url, let scheme = url.scheme {
        if ["http", "https", "mailto"].contains(where: { $0.caseInsensitiveCompare(scheme) == .orderedSame }) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
      return nil
    }
    
    @available(iOS 15.0, *)
      public func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
            
        switch type {
        case .camera:
            if #available(iOS 16.0, *) {
                requestCameraPermission { granted in
                    DispatchQueue.main.async {
                        decisionHandler(granted ? .grant : .deny)
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            
        case .microphone:
            if #available(iOS 16.0, *) {
                requestMicrophonePermission { granted in
                    DispatchQueue.main.async {
                        decisionHandler(granted ? .grant : .deny)
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            
        case .cameraAndMicrophone:
            if #available(iOS 16.0, *) {
                requestCameraAndMicrophonePermission { granted in
                    DispatchQueue.main.async {
                        decisionHandler(granted ? .grant : .deny)
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            
        @unknown default:
            decisionHandler(.deny)
        }
    }
    
    @available(iOS 14.0, *)
    public func webView(_ webView: WKWebView, runOpenPanelWith parameters: Any, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [
            .pdf,
            .image,
            .movie,
            .data
        ])
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        self.fileUploadCompletionHandler = completionHandler
        
        present(documentPicker, animated: true)
    }
}
