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
    
    @available(iOS 13.0, *)
    public static func startOnrampSDK(
                        _ viewController:UIViewController,
                        _ target: OnrampKitDelegate,
                        appId: Int = 0,
                        walletAddress: String? = nil,
                        flowType: Int? = 1,
                        coinCode: String? = nil,
                        network: String? = nil,
                        coinAmount: Double? = nil,
                        fiatAmount: Double? = nil,
                        merchantRecognitionId: String? = nil,
                        paymentMethod: Int? = nil,
                        authToken: String? = nil,
                        assetDescription: String? = nil,
                        assetImage: String? = nil,
                        paymentAddress: String? = nil,
                        fiatType: Int?=nil,
                        phoneNumber: String? = nil,
                        lang: String? = nil) {
                            

        let webVC = setUpOnrampUIViewController()
        webVC.url = getCustomUrlForSdkToShow(
            appId: appId,
            walletAddress: walletAddress,
            coinCode: coinCode,
            network: network,
            coinAmount: coinAmount,
            fiatAmount: fiatAmount,
            merchantRecognitionId: merchantRecognitionId,
            paymentMethod: paymentMethod,
            flowType: flowType,
            authToken: authToken,
            assetDescription: assetDescription,
            assetImage: assetImage,
            paymentAddress: paymentAddress,
            fiatType: fiatType,
            phoneNumber: phoneNumber,
            lang: lang
        )
        webVC.from = "startSdk"
        webVC.appId = appId
        webVC.delegate = target
                            
        viewController.present(webVC, animated: true, completion: nil)
    }
    
    @available(iOS 13.0, *)
    public static func startOnrampLogin(
                        _ viewController:UIViewController,
                        _ target: OnrampKitDelegate,
                        appId: Int,
                        closeAfterLogin: Bool,
                        signature: String? = nil,
                        phoneNumber: String? = nil,
                        lang: String? = nil
    ) {
        let webVC = setUpOnrampUIViewController()
        webVC.url = getCustomLoginUrlForSdkToShow(
            appId: appId,
            closeAfterLogin: closeAfterLogin,
            signature: signature,
            phoneNumber: phoneNumber,
            lang: lang
        )
        webVC.from = "loginSdk"
        webVC.appId = appId
        webVC.delegate = target
        viewController.present(webVC, animated: true, completion: nil)
    }
    
    @available(iOS 13.0, *)
    public static func initiateOnrampKyc(
                        _ viewController:UIViewController,
                        _ target: OnrampKitDelegate,
                        appId: Int,
                        payload: String,
                        signature: String,
                        customerId: String,
                        apiKey: String,
                        lang: String? = nil
                        
    ) {
        let webVC = setUpOnrampUIViewController()
        let url = getCustomKycUrlForSdkToShow(
            payload: payload, signature: signature, customerId: customerId, apiKey: apiKey, lang: lang
        )
        webVC.url = url
        webVC.from = "initiateKyc"
        webVC.appId = appId
        print("initiateOnrampKyc", url)
        webVC.delegate = target
        viewController.present(webVC, animated: true, completion: nil)
    }
    
    public static func getCustomUrlForSdkToShow(
        appId: Int = 0,
        walletAddress: String? = nil,
        coinCode: String? = nil,
        network: String? = nil,
        coinAmount: Double? = nil,
        fiatAmount: Double? = nil,
        merchantRecognitionId: String? = nil,
        paymentMethod: Int? = nil,
        flowType: Int? = 1,
        authToken: String? = nil,
        assetDescription: String? = nil,
        assetImage: String? = nil,
        paymentAddress: String? = nil,
        fiatType: Int?=nil,
        phoneNumber: String? = nil,
        lang: String? = nil
    ) -> String {
        var url = "\(Constants.APP_DOMAIN)\(Constants.PATH)"
        
        switch flowType {
        case 1:
            // onramp
            url += "/buy"
        case 2:
            // offramp
            url += "/sell"
        case 3:
            // checkout
            url += "/checkout"
        case 4:
            // swap flow
            url += "/swap"
        default:
            // onramp
            url += "/buy"
        }
        
        url += "?appId=\(appId)&mode=overlay&origin=\(Constants.MERCHANT_ORIGIN_ID)"
        
        // params only applicable for onramp / checkout flow (NFT flow)
        if ([1, 3].contains(flowType)) {
            if (walletAddress != nil) {
                url += "&walletAddress=\(walletAddress ?? "")"
            }
            if (paymentMethod != nil) {
                url += "&paymentMethod=\(paymentMethod ?? 0)"
            }
            if (fiatType != nil) {
                url += "&fiatType=\(fiatType ?? 0)"
            }
        }
        
        // params only applicable checkout flow (NFT flow)
        if (flowType == 3) {
            if (assetDescription != nil) {
                url += "&assetDescription=\(assetDescription ?? "")"
            }
            if (assetImage != nil) {
                url += "&assetImage=\(assetImage ?? "")"
            }
        }
        
        // params only applicable for offramp
        if ([2, 4].contains(flowType)) {
            if (authToken != nil) {
                url += "&authToken=\(authToken ?? "")"
            }
        }
        
        // params only applicable for swap flow
        if (flowType == 4) {
            if (paymentAddress != nil) {
                url += "&paymentAddress=\(paymentAddress ?? "")"
            }
        }
        
        // common params (onramp - offramp)
        if let coinCode = coinCode {
            url += "&coinCode=\(coinCode)"
        }
        if let network = network {
            url += "&network=\(network)"
        }
        if let coinAmount = coinAmount {
            url += "&coinAmount=\(coinAmount)"
        }
        if let fiatAmount = fiatAmount {
            url += "&fiatAmount=\(fiatAmount)"
        }
        if let merchantRecognitionId = merchantRecognitionId {
            url += "&merchantRecognitionId=\(merchantRecognitionId)"
        }
        if let phoneNumber = phoneNumber {
            url += "&phoneNumber=\(phoneNumber)"
        }
        if let lang = lang {
            url += "&lang=\(lang)"
        }
        
        return url
    }
    
    public static func getCustomLoginUrlForSdkToShow(
        appId: Int,
        closeAfterLogin: Bool,
        signature: String? = nil,
        phoneNumber: String? = nil,
        lang: String? = nil
    ) -> String {
        var url = "\(Constants.APP_DOMAIN)\(Constants.PATH)/login/?mode=overlay&origin=\(Constants.MERCHANT_ORIGIN_ID)&appId=\(appId)&closeAfterLogin=\(closeAfterLogin)"
        
        // handle optional parameters
        if let signature = signature {
            url += "&kybData=\(signature)"
        }
        if let phoneNumber = phoneNumber {
            url += "&phoneNumber=\(phoneNumber)"
        }
        if let lang = lang {
            url += "&lang=\(lang)"
        }
        
        print("onramp_login_url", url)
        return url
    }
    
    public static func getCustomKycUrlForSdkToShow(payload: String, signature: String, customerId: String, apiKey: String, lang: String? = nil) -> String {
        var url =  "\(Constants.APP_DOMAIN)\(Constants.INITIATE_KYC_PATH)?mode=overlay&origin=\(Constants.MERCHANT_ORIGIN_ID)&payload=\(payload)&signature=\(signature)&customerId=\(customerId)&apiKey=\(apiKey)"
       
        // handle optional parameters
        if let lang = lang {
            url += "&lang=\(lang)"
        }
        
        return url
    }

}

