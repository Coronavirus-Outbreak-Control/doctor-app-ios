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
    @IBOutlet weak var recoveredButton: PMSuperButton!
    @IBOutlet weak var moreButton: PMSuperButton!
    
    var patientId: String!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            self?.setStatus(.infected)
        })
        .disposed(by: bag)
        
        recoveredButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            self?.setStatus(.healed)
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
}
