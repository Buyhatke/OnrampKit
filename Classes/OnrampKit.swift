//
//  OnrampKit.swift
//  OnrampKit
//
//  Created by PrashantDixit on 18/08/23.
//

import UIKit
import WebKit


public class Onramp {
    weak public static var navigationController: UINavigationController?
    weak public var webView: WKWebView!

    public static func stopOnrampSDK(_ viewController:UIViewController) {
        viewController.dismiss(animated: true)
    }

    @available(iOS 13.0, *)
    public static func setUpOnrampUIViewController() -> OnrampUIViewController {
        let podBundle = Bundle(for: OnrampUIViewController.self)
        let frameworkBundle = podBundle.url(forResource: "OnrampKit", withExtension: "bundle")
        let storyboard = UIStoryboard(name: "OnrampStoryboard", bundle: Bundle(url: frameworkBundle!))
        let webVC = storyboard.instantiateViewController(identifier: "OnrampUIViewController") as OnrampUIViewController

        return webVC
    }

    /// Start Onramp SDK with server-side URL generation
    /// - Parameters:
    ///   - viewController: The presenting view controller
    ///   - target: Delegate to receive SDK events
    ///   - params: Dictionary of parameters (appId, flowType, walletAddress, etc.)
    @available(iOS 13.0, *)
    public static func startOnrampSDK(
        _ viewController: UIViewController,
        _ target: OnrampKitDelegate,
        params: [String: Any]
    ) {
        let appId = params["appId"] as? Int ?? 0

        // Calculate client height (usable screen height in points, excluding safe areas)
        let window = UIApplication.shared.windows.first
        let safeAreaInsets = window?.safeAreaInsets ?? .zero
        let screenHeight = UIScreen.main.bounds.height
        let usableHeight = Int(screenHeight - safeAreaInsets.top - safeAreaInsets.bottom)

        // Add automatic parameters
        var paramsWithExtras = params
        paramsWithExtras["origin"] = Constants.MERCHANT_ORIGIN_ID
        paramsWithExtras["clientHeight"] = usableHeight

        // Filter out nil values
        let nonNullParams = paramsWithExtras.compactMapValues { $0 }

        // Call API to generate URL
        OnrampApiService.generateUrl(params: nonNullParams, sdkFlow: "TRANSACTION") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    print("OnrampSDK - Generated URL: \(url)")
                    print("OnrampSDK - Screen height: \(usableHeight)")

                    // Open WebView with generated URL
                    let webVC = setUpOnrampUIViewController()
                    webVC.url = url
                    webVC.from = "startSdk"
                    webVC.appId = appId
                    webVC.delegate = target
                    viewController.present(webVC, animated: true, completion: nil)

                case .failure(let error):
                    print("OnrampSDK - Failed to generate URL: \(error.localizedDescription)")
                    // Show error alert to user
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Failed to start Onramp: \(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    viewController.present(alert, animated: true)
                }
            }
        }
    }

    /// Start Onramp Login flow with server-side URL generation
    /// - Parameters:
    ///   - viewController: The presenting view controller
    ///   - target: Delegate to receive SDK events
    ///   - params: Dictionary of parameters (appId, closeAfterLogin, signature, phoneNumber, lang)
    @available(iOS 13.0, *)
    public static func startOnrampLogin(
        _ viewController: UIViewController,
        _ target: OnrampKitDelegate,
        params: [String: Any]
    ) {
        let appId = params["appId"] as? Int ?? 0

        // Add automatic parameters
        var paramsWithExtras = params
        paramsWithExtras["origin"] = Constants.MERCHANT_ORIGIN_ID
        paramsWithExtras["mode"] = "overlay"

        // Filter out nil values
        let nonNullParams = paramsWithExtras.compactMapValues { $0 }

        // Call API to generate URL
        OnrampApiService.generateUrl(params: nonNullParams, sdkFlow: "LOGIN") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    print("OnrampSDK - Generated Login URL: \(url)")

                    // Open WebView with generated URL
                    let webVC = setUpOnrampUIViewController()
                    webVC.url = url
                    webVC.from = "loginSdk"
                    webVC.appId = appId
                    webVC.delegate = target
                    viewController.present(webVC, animated: true, completion: nil)

                case .failure(let error):
                    print("OnrampSDK - Failed to generate login URL: \(error.localizedDescription)")
                    // Show error alert to user
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Failed to start Onramp Login: \(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    viewController.present(alert, animated: true)
                }
            }
        }
    }

    /// Initiate Onramp KYC flow with server-side URL generation
    /// - Parameters:
    ///   - viewController: The presenting view controller
    ///   - target: Delegate to receive SDK events
    ///   - params: Dictionary of parameters (appId, payload, signature, customerId, apiKey, lang)
    @available(iOS 13.0, *)
    public static func initiateOnrampKyc(
        _ viewController: UIViewController,
        _ target: OnrampKitDelegate,
        params: [String: Any]
    ) {
        let appId = params["appId"] as? Int ?? 0

        // Add automatic parameters
        var paramsWithExtras = params
        paramsWithExtras["origin"] = Constants.MERCHANT_ORIGIN_ID
        paramsWithExtras["mode"] = "overlay"

        // Filter out nil values
        let nonNullParams = paramsWithExtras.compactMapValues { $0 }

        // Call API to generate URL
        OnrampApiService.generateUrl(params: nonNullParams, sdkFlow: "KYC") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    print("OnrampSDK - Generated KYC URL: \(url)")

                    // Open WebView with generated URL
                    let webVC = setUpOnrampUIViewController()
                    webVC.url = url
                    webVC.from = "initiateKyc"
                    webVC.appId = appId
                    webVC.delegate = target
                    viewController.present(webVC, animated: true, completion: nil)

                case .failure(let error):
                    print("OnrampSDK - Failed to generate KYC URL: \(error.localizedDescription)")
                    // Show error alert to user
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Failed to initiate KYC: \(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    viewController.present(alert, animated: true)
                }
            }
        }
    }
}
