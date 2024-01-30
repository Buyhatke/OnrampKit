//
//  OnrampUIViewController.swift
//  OnrampKit
//
//  Created by PrashantDixit on 18/08/23.
//

import UIKit
import WebKit

public protocol OnrampKitDelegate: AnyObject {
    func onDataChanged(_ data: OnrampEventResponse)
}

@available(iOS 13.0, *)
public class OnrampUIViewController: UIViewController {
    
    public var webView: WKWebView!
    public var loadingSpinner: UIActivityIndicatorView!
    public weak var delegate: OnrampKitDelegate?
    public var url: String?
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    public override func viewDidLoad() {
        super.viewDidLoad()

        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        let wkPreferences = WKPreferences()
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        
        navigationItem.hidesBackButton = true

        userContentController.add(self, name: "iosNativeEvent")
        
        config.userContentController = userContentController
        config.preferences = wkPreferences

        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorView.Style.large)
        loadingSpinner.color = UIColor(hex: "#2c5bffff")

        view.addSubview(webView)
        
        
        view.addSubview(loadingSpinner)

        let layoutGuide = view.safeAreaLayoutGuide

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor, constant: 0.0).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor, constant: 0.0).isActive = true
        
        guard let url = URL(string: url ?? "https://test.bitbns.com/onramp/main/buy/?appId=1&mode=overlay&origin=OnrampSdkIos") else {return}
        
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

