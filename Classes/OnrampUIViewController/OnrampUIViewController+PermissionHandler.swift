//
//  OnrampUIViewController+PermissionHandler.swift
//  OnrampKit
//
//  Created by PrashantDixit on 03/06/25.
//

import Foundation
import AVFoundation

@available(iOS 13.0, *)
extension OnrampUIViewController {
    
     func showPermissionAlert(title: String, message: String, onAllow: @escaping () -> Void, onDeny: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Allow", style: .default) { _ in
            onAllow()
        })
        
        alert.addAction(UIAlertAction(title: "Don't Allow", style: .cancel) { _ in
            onDeny()
        })
        
        present(alert, animated: true)
    }
    
    @available(iOS 16.0, *)
    func showPermissionDeniedAlert(for permission: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "\(permission) Access Denied",
            message: "Please enable \(permission) access in Settings to use this feature.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openNotificationSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
            completion()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion()
        })
        
        present(alert, animated: true)
    }
    
    @available(iOS 16.0, *)
    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
            
        case .denied, .restricted:
            showPermissionDeniedAlert(for: "Camera") {
                completion(false)
            }
            
        @unknown default:
            completion(false)
        }
    }
    
    @available(iOS 16.0, *)
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            completion(true)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                completion(granted)
            }
            
        case .denied, .restricted:
            showPermissionDeniedAlert(for: "Microphone") {
                completion(false)
            }
            
        @unknown default:
            completion(false)
        }
    }
    
    @available(iOS 16.0, *)
    func requestCameraAndMicrophonePermission(completion: @escaping (Bool) -> Void) {
        requestCameraPermission { [weak self] cameraGranted in
            if cameraGranted {
                self?.requestMicrophonePermission { micGranted in
                    completion(micGranted)
                }
            } else {
                completion(false)
            }
        }
    }
}
