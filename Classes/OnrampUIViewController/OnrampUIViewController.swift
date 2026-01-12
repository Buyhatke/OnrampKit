//
//  OnrampUIViewController.swift
//  OnrampKit
//
//  Created by PrashantDixit on 18/08/23.
//

import UIKit
import WebKit
import AVFoundation
import CoreLocation

public protocol OnrampKitDelegate: AnyObject {
    func onDataChanged(_ data: OnrampEventResponse)
}

@available(iOS 13.0, *)
public class OnrampUIViewController: UIViewController {
    
    public var webView: WKWebView!
    public var loadingSpinner: UIActivityIndicatorView!
    public weak var delegate: OnrampKitDelegate?
    public var fileUploadCompletionHandler: (([URL]?) -> Void)?
    public var url: String?
    public var from: String?
    public var appId: Int = 0
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Set white background for loading state
        view.backgroundColor = .white

        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        let wkPreferences = WKPreferences()
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true

        navigationItem.hidesBackButton = true

        userContentController.add(self, name: "iosNativeEvent")
        let injectedJS = """
        window.initiateNfc = function(action, transactionId, documentNo, dob, expiryDate) {
          window.webkit.messageHandlers.iosNativeEvent.postMessage(JSON.stringify({
            action: action,
            payload: {
              transactionId: transactionId,
              documentNo: documentNo,
              dob: dob,
              expiryDate: expiryDate
            }
          }));
        };
        true;
        """
        let userScript = WKUserScript(source: injectedJS, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        userContentController.addUserScript(userScript)

        // Add console logging
        setupConsoleLogging(userContentController: userContentController)

        config.userContentController = userContentController
        config.preferences = wkPreferences
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self

        // Set white background for WebView
        webView.backgroundColor = .white
        webView.scrollView.backgroundColor = .white

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

        guard let urlString = url, let url = URL(string: urlString) else {
            return
        }

        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }

    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent // Dark icons on light background
        } else {
            return .default
        }
    }

    private func setupConsoleLogging(userContentController: WKUserContentController) {
        let script = """
        (function() {
            const originalLog = console.log;
            const originalWarn = console.warn;
            const originalError = console.error;

            console.log = function() {
                window.webkit.messageHandlers.consoleLog.postMessage({level: 'LOG', message: Array.from(arguments).join(' ')});
                originalLog.apply(console, arguments);
            };

            console.warn = function() {
                window.webkit.messageHandlers.consoleLog.postMessage({level: 'WARN', message: Array.from(arguments).join(' ')});
                originalWarn.apply(console, arguments);
            };

            console.error = function() {
                window.webkit.messageHandlers.consoleLog.postMessage({level: 'ERROR', message: Array.from(arguments).join(' ')});
                originalError.apply(console, arguments);
            };
        })();
        """

        let consoleScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(consoleScript)
        userContentController.add(self, name: "consoleLog")
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

