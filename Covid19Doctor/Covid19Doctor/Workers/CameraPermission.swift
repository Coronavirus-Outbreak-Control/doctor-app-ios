//
//  CameraPermission.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 06/04/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift

class CameraPermission {
    
    class func check(from: UIViewController) -> Single<Bool> {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined:
            return requestCameraPermission()
        case .restricted, .denied:
            alertCameraAccessNeeded(from: from)
            return .just(false)
        default:
            return .just(true)
        }
    }
    
    private class func requestCameraPermission() -> Single<Bool> {
        .create { observer in
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
                observer(.success(accessGranted))
            })
            return Disposables.create()
        }
    }
    
    private class func alertCameraAccessNeeded(from: UIViewController) {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
    
        let alert = UIAlertController(
            title: NSLocalizedString("camera_permission_title", comment: ""),
            message: NSLocalizedString("camera_permission_text", comment: ""),
            preferredStyle: .alert
        )
    
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("camera_permission_bt_settings", comment: ""), style: .cancel, handler: { (alert) -> Void in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(settingsAppURL)
            }
        }))
    
        from.present(alert, animated: true, completion: nil)
    }
}
