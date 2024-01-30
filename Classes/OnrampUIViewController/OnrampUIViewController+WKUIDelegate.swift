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
}
