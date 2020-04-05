//
//  EnterPatientViewController.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 05/04/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PMSuperButton

class EnterPatientViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var continueButton: PMSuperButton!
    @IBOutlet weak var backButton: PMSuperButton!
    
    private let bag = DisposeBag()
    
    private func configureUI() {
        titleLabel.map {
            $0.text = NSLocalizedString("enter_patient_title", comment: "")
            $0.textColor = .titleBlack
            $0.font = .title
        }
        
        idField.map {
            $0.placeholder = NSLocalizedString("patient_id", comment: "")
            $0.textColor = .titleBlack
            $0.font = UIFont(name: "SFCompactDisplay-Regular", size: 26)
        }
        
        continueButton.map {
            $0.setTitle(NSLocalizedString("continue", comment: "").uppercased(),
                        for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .button
            $0.backgroundColor = .mainTheme
        }
        
        backButton.map {
            $0.backgroundColor = .mainTheme
            $0.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            $0.tintColor = .white
        }
        
        lineView.backgroundColor = .mainTheme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        continueButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.proceed()
            })
            .disposed(by: bag)
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: bag)
        
        view.rx.tapGesture()
            .subscribe(onNext: { [weak self] _ in
                self?.idField.resignFirstResponder()
            })
            .disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: -
    
    private func proceed() {
        validatedId()
            .subscribe(onSuccess: launchStatusScreen, onError: processError)
            .disposed(by: bag)
    }
    
    private func validatedId() -> Single<String> {
        let enteredId = idField.text ?? " "
        if Scanner.validateChecksum(publicPatientId: enteredId) {
            return .just(Scanner.computePatientId(publicPatientId: enteredId))
        } else {
            return .error(Errors.invalidPatientId)
        }
    }
    
    private func launchStatusScreen(patientId: String) {
        let vc = UIStoryboard.getViewController(id: "PatientViewController")
            as! PatientViewController
        vc.patientId = patientId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func processError(_ error: Error) {
        if let e = error as? Errors {
            let title: String?
            let text: String?
            switch e {
            case .invalidPatientId:
                title = NSLocalizedString("enter_patient_invalid_title", comment: "")
                text = NSLocalizedString("enter_patient_invalid_text", comment: "")
            default:
                title = nil
                text = nil
            }
            
            if let title = title, let text = text {
                showError(title: title, text: text)
            }
        }
    }
    
    private func showError(title: String, text: String) {
        let alertController = UIAlertController(title: title, message: text,
                                                preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel) { _ in
            // nothing
        }
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
        alertController.view.tintColor = .mainTheme
    }
}
