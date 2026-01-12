//
//  ViewController.swift
//  OnrampKit
//
//  Created by 32432618 on 08/18/2023.
//  Copyright (c) 2023 32432618. All rights reserved.
//

import UIKit
import OnrampKit

@available(iOS 13.0, *)
class ViewController: UIViewController, OnrampKitDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

                let buyButton: UIButton = {
                    let button = UIButton(type: .system)
                    button.setTitle("Buy Flow", for: .normal)
                    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    button.setTitleColor(.white, for: .normal)
                    button.layer.cornerRadius = 8
                    button.backgroundColor = .blue
                    button.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    return button
                }()

                let sellButton: UIButton = {
                    let button = UIButton(type: .system)
                    button.setTitle("Sell Flow", for: .normal)
                    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    button.setTitleColor(.white, for: .normal)
                    button.layer.cornerRadius = 8
                    button.backgroundColor = .systemGreen
                    button.addTarget(self, action: #selector(sellButtonTapped), for: .touchUpInside)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    return button
                }()

                let checkoutButton: UIButton = {
                    let button = UIButton(type: .system)
                    button.setTitle("Checkout Flow", for: .normal)
                    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    button.setTitleColor(.white, for: .normal)
                    button.layer.cornerRadius = 8
                    button.backgroundColor = .systemOrange
                    button.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    return button
                }()

                let swapButton: UIButton = {
                    let button = UIButton(type: .system)
                    button.setTitle("Swap Flow", for: .normal)
                    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    button.setTitleColor(.white, for: .normal)
                    button.layer.cornerRadius = 8
                    button.backgroundColor = .systemPurple
                    button.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    return button
                }()

                // Add the buttons to the view hierarchy
                view.addSubview(buyButton)
                view.addSubview(sellButton)
                view.addSubview(checkoutButton)
                view.addSubview(swapButton)

                // Set button constraints
                NSLayoutConstraint.activate([
                    buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    buyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
                    buyButton.widthAnchor.constraint(equalToConstant: 250),
                    buyButton.heightAnchor.constraint(equalToConstant: 48),

                    sellButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    sellButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
                    sellButton.widthAnchor.constraint(equalToConstant: 250),
                    sellButton.heightAnchor.constraint(equalToConstant: 48),

                    checkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    checkoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
                    checkoutButton.widthAnchor.constraint(equalToConstant: 250),
                    checkoutButton.heightAnchor.constraint(equalToConstant: 48),

                    swapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    swapButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 120),
                    swapButton.widthAnchor.constraint(equalToConstant: 250),
                    swapButton.heightAnchor.constraint(equalToConstant: 48)
                ])
            }
        
            @objc func buyButtonTapped() {
                // Buy flow
                Onramp.startOnrampSDK(
                    self,
                    self,
                    params: [
                        "appId": 360602,
                        "fiatType":2,
                        "isRestricted":false,
                    ]
                )
            }

            @objc func sellButtonTapped() {
                // Sell flow
                Onramp.startOnrampSDK(
                    self,
                    self,
                    params: [
                        "appId": 1,
                        "flowType": 2,
                        "coinCode": "sol",
                        "network": "spl",
                        "coinAmount": 6
                    ]
                )
            }

            @objc func checkoutButtonTapped() {
                // Checkout flow
                Onramp.initiateOnrampKyc(
                    self,
                    self,
                    params: [
                        "appId":360602,
                        "sandbox": true,
                        "payload" : "eyJib2R5Ijp7ImN1c3RvbWVySWQiOiJhZjFwYzJCaGg3XzQ5MDEifSwidGltZXN0YW1wIjoiMTc2Nzk0NjI1NTkxNyJ9",
                        "signature" : "616cd88ff5366b2344b91e6d5484d5c261e2039b02993e1dd5dcd0a09adadc51444a4aa9348dc4c2c1740c41474c002f5b73b799501c02e4540be7e73e4d685b",
                        "customerId" : "af1pc2Bhh7_4901",
                        "apiKey" : "IzCsDU4TwXskSMdJEGBvkp8fB5fFgJ"
                    ]
                )
            }

            @objc func swapButtonTapped() {
                // Swap flow
                Onramp.startOnrampLogin(
                    self,
                    self,
                    params: [
                        "appId": 1,
                        "closeAfterLogin": true,
                        "phoneNumber": "+90-999999999",
                        "lang":"en"
                    ]
                )
            }
        
            // retrieve to the latest onramp transaction state
             func onDataChanged(_ data: OnrampEventResponse) {
                 print("data: ",data)
                showEvent(type: data.type, data: data.data, isOnramp: data.isOnramp)
            }
        
        
            private func showEvent(type: Any,data: EventData, isOnramp: Any) {

                var userDescription = "From Event Listener: \n\(type) \n\(isOnramp)"
                if(data.msg != nil){
                    userDescription = userDescription + " " + data.msg!
                }
                if(data.coinRate != nil){
                    userDescription = userDescription + " " + String(data.coinRate!)
                }
                if(data.cryptoAmount != nil){
                    userDescription = userDescription + " " + String(data.cryptoAmount!)
                }
                if(data.fiatAmount != nil){
                    userDescription = userDescription + " " + String(data.fiatAmount!)
                }
                if(data.paymentMethod != nil ){
                    userDescription = userDescription + " " + String(data.paymentMethod!)
                }

                let alertController = UIAlertController(title: "OnrampEvent", message: userDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true)
            }
    }
    


