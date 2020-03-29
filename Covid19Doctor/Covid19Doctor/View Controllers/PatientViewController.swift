//
//  PatientViewController.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 12/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import PMSuperButton
import RxSwift
import RxCocoa
import Toast_Swift

class PatientViewController: UIViewController {

    @IBOutlet weak var confirmButton: PMSuperButton!
    @IBOutlet weak var suspectedButton: PMSuperButton!
    @IBOutlet weak var recoveredButton: PMSuperButton!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var backButton: PMSuperButton!
    
    var patientId: String!
    
    private let bag = DisposeBag()
    
    private func configureUI() {
        confirmButton.backgroundColor = UIColor(red:0.88, green:0.24, blue:0.24, alpha:1.00)
        confirmButton.setTitle("🤒 POSITIVO AL COVID-19", for: .normal)
        
        suspectedButton.backgroundColor = UIColor(red:0.92, green:0.54, blue:0.33, alpha:1.00)
        suspectedButton.setTitle("😷 SOSPETTO DI COVID-19", for: .normal)
        
        recoveredButton.backgroundColor = UIColor(red:0.18, green:0.74, blue:0.47, alpha:1.00)
        recoveredButton.setTitle("😊 GUARITO", for: .normal)
        
        [confirmButton, suspectedButton, recoveredButton].forEach {
            $0?.titleLabel?.font = .button
            $0?.setTitleColor(.white, for: .normal)
        }
        
        textLabel.font = UIFont.title
        textLabel.textColor = .titleBlack
        textLabel.text = "Diagnosi 🔬"
        
        backButton.map {
            $0.backgroundColor = .mainTheme
            $0.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            $0.tintColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        backButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        .disposed(by: bag)

        confirmButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            self?.askConfirmation(forStatus: .infected)
        })
        .disposed(by: bag)
        
        suspectedButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            self?.askConfirmation(forStatus: .suspected)
        })
        .disposed(by: bag)
        
        recoveredButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            self?.askConfirmation(forStatus: .healed)
        })
        .disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Set status

    func setStatus(_ status: PatientStatus) {
        APIManager.api.setPatientStatus(patientId: patientId, status: status)
        .subscribe(onSuccess: { [weak self] _ in
            self?.view.makeToast("Stato di salute registrato", duration: 3.0, position: .center)
        }, onError: { [weak self] error in
            self?.view.makeToast("Errore, lo stato di salute non è stato registrato", duration: 3.0, position: .center)
        })
        .disposed(by: bag)
    }
    
    func askConfirmation(forStatus status: PatientStatus) {
        let alertController = UIAlertController(title: "\(status)", message: "Are you sure?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // nothing
        }
        alertController.addAction(cancelAction)

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.setStatus(status)
        }
        alertController.addAction(okAction)

        self.present(alertController, animated: true)
    }
}
