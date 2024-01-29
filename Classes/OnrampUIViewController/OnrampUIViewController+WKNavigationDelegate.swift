//
//  OnrampUIViewController+WKNavigationDelegate.swift
//  OnrampKit
//
//  Created by PrashantDixit on 18/08/23.
//

import WebKit

@available(iOS 13.0, *)
extension OnrampUIViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.loadingSpinner.startAnimating()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingSpinner.stopAnimating()
    }
    
    public func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url,
           !url.absoluteString.hasPrefix("http://"),
            UIApplication.shared.canOpenURL(url) {
            
            if(!url.absoluteString.hasPrefix("https://") || url.absoluteString.hasPrefix("https://") && (url.absoluteString.contains(Constants.VIDEO_KYC_PATH) || url.absoluteString.contains(Constants.FRESHDESK_PATH)) ||  url.absoluteString.contains(Constants.DOCUMENTATION_PATH)
            ){
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                
            } else {
                decisionHandler(.allow)
            }

        }
        else {
            decisionHandler(.allow)
            
        }
    }
}
