//
//  Scanner.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 04/04/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import RxSwift
import Toast_Swift

class Scanner {
    
    private let bag = DisposeBag()
    
    func present(from: UIViewController) {
        let scannerVC = UIStoryboard.getViewController(id: "ScannerViewController") as! ScannerViewController
        let scannerNC = UINavigationController(rootViewController: scannerVC)
        from.present(scannerNC, animated: true, completion: nil)
        
        scannerVC.output
        .flatMap({ Self.extractPatientId(string: $0) })
        /*.flatMapLatest({ [weak from] patientId -> Single<String> in
            from?.view.makeToastActivity(.center)
            
            guard let reAuthToken: String =
                Database.shared.getAccountValue(key: .reAuthToken) else {
                //TODO: handle error
                return .error(Errors.userNotActivated)
            }
            
            return APIManager.api.runAuthenticated(reAuthToken: reAuthToken, apiBuilder: {
                APIManager.api.setPatientStatus(patientId: patientId, status: .pending)
            }).flatMap({ _ in .just(patientId) })
        })*/
        .subscribe({ [weak self, weak from] event in
            guard let from = from else { return }
            
            switch event {
            case .next(let patientId):
                // 'pending' state has been set on server
                self?.launchPendingViewController(patientId: patientId, from: from)
            case .error(_):
                // TODO: show error (no error actually)
                break
            default:
                break
            }
        })
        .disposed(by: bag)
    }
    
    func launchPendingViewController(patientId: String, from: UIViewController) {
        let vc = UIStoryboard.getViewController(id: "PendingViewController") as! PendingViewController
        vc.patientId = patientId
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Parse id
    
    /// Parse the qr code string and extract the raw id.
    /// - Parameter string: the string in the qr code
    /// - Returns: the patient id
    class func extractPatientId(string: String) -> Single<String> {
        if let id = string.deletingPrefix("covid-outbreak-control:") {
            return .just(id)
        } else {
            return .error(Errors.invalidPatientId)
        }
    }
    
    class func computeChecksum(patientId: String) -> String {
        let zero: Unicode.Scalar = "0"
        let nine: Unicode.Scalar = "9"
        
        let sum = patientId.unicodeScalars.reduce(0) { (result, letter) -> Int in
            let val = letter.value
            switch val {
            case zero.value...nine.value:
                return result + Int(val) - 48
            default:
                return result
            }
        }
        
        if let lastChar = "\(sum)".last {
            return String(lastChar)
        } else {
            return ""
        }
    }
    
    class func validateChecksum(publicPatientId: String) -> Bool {
        if let lastChar = publicPatientId.last {
            let patientId = String(publicPatientId.dropLast())
            return computeChecksum(patientId: patientId) == "\(lastChar)"
        } else {
            return false
        }
    }
    
    /// Append checksum at the end of the patient id.
    /// The result must be the only one to show to the user.
    /// - Parameter patientId: the patient id
    /// - Returns: the patient id + checksum
    class func computePublicPatientId(patientId: String) -> String {
        "\(patientId)\(computeChecksum(patientId: patientId))"
    }
    
    /// Remove checksum from safe patient id.
    /// The result is to be used internally and with the backend.
    /// - Parameter publicPatientId: the patient id with checksum
    /// - Returns: the patient id
    class func computePatientId(publicPatientId: String) -> String {
        String(publicPatientId.dropLast())
    }
}
