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

class PatientViewController: UIViewController {

    @IBOutlet weak var confirmButton: PMSuperButton!
    @IBOutlet weak var suspectedButton: PMSuperButton!
    @IBOutlet weak var recoveredButton: PMSuperButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var patientId: String! = "sddsds"
    
    private let bag = DisposeBag()
    
    private func configureUI() {
        confirmButton.backgroundColor = UIColor(red:0.85, green:0.00, blue:0.11, alpha:1.00)
        confirmButton.setTitle("COVID-19 POSITIVE", for: .normal)
        
        suspectedButton.backgroundColor = UIColor(red:0.96, green:0.60, blue:0.14, alpha:1.00)
        suspectedButton.setTitle("SUSPECTED COVID-19", for: .normal)
        
        recoveredButton.backgroundColor = UIColor(red:1.00, green:0.82, blue:0.15, alpha:1.00)
        recoveredButton.setTitle("HEALED/NEGATIVE", for: .normal)
        
        [confirmButton, suspectedButton, recoveredButton].forEach {
            $0?.titleLabel?.font = .button
            $0?.setTitleColor(.white, for: .normal)
        }
        
        textLabel.font = UIFont.title
        textLabel.textColor = .titleBlack
        textLabel.text = "Diagnosis"
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

    func setStatus(_ status: PatientStatus) {
        APIManager.api.setPatientStatus(patientId: patientId, status: status)
        .subscribe(onSuccess: { _ in
            // TODO
        }, onError: { error in
            // TODO
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
