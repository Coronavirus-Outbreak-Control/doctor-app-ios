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
import DropDown

class EnterPatientViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var continueButton: PMSuperButton!
    @IBOutlet weak var backButton: PMSuperButton!
    let dropDown = DropDown()
    
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
        
        dropDown.anchorView = idField
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)! * 2.3)
        dropDown.cellHeight = 56
        dropDown.textFont = UIFont(name: "SFCompactDisplay-Regular", size: 20)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.idField.text = item
            self?.dropDown.hide()
        }
        
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
        
        idField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] _ in
                self?.dropDown.show()
            })
            .disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // request suspect patients
        getPendingPatients()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] ids in
                if let `self` = self {
                    self.dropDown.dataSource = ids
                    if self.idField.isFirstResponder {
                        self.dropDown.show()
                    }
                }
            })
            .disposed(by: bag)
    }
    
    // MARK: - Get pending patients
    
    private func getPendingPatients() -> Observable<[String]> {
        guard let reAuthToken: String = Database.shared.getAccountValue(key: .reAuthToken),
            let doctorId: String = Database.shared.getAccountValue(key: .userId)
        else {
            //TODO: handle error Errors.userNotActivated
            return .just([])
        }
        
        return APIManager.api.runAuthenticated(reAuthToken: reAuthToken, apiBuilder: {
            APIManager.api.getSuspects(doctorId: doctorId)
        }).asObservable()
            .map({
                $0.data.map({ Scanner.computePublicPatientId(patientId: "\($0.patient_id)") })
            })
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
