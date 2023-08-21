//
//  OnrampUIViewController+WKNavigationDelegate.swift
//  OnrampKit
//
//  Created by PrashantDixit on 18/08/23.
//

import WebKit

extension OnrampUIViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.loadingSpinner.startAnimating()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingSpinner.stopAnimating()
    }
}
