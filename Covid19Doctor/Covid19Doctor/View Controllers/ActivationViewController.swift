//
//  ActivationViewController.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 11/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxGesture
import PhoneNumberKit
import PMSuperButton
import KWVerificationCodeView

class ActivationViewController: UIViewController {
    
    @IBOutlet weak var phoneField: PhoneNumberTextField!
    @IBOutlet weak var sendPhoneButton: PMSuperButton!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var digitsField: KWVerificationCodeView!
    
    private let bag = DisposeBag()
    private let viewVisibleCommand = PublishRelay<Bool>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        digitsField.delegate = self
        codeView.isHidden = true

        // dismiss keyboard on tap
        view.rx.tapGesture().subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
            self?.view.frame.origin.y = 0
        }).disposed(by: bag)
        
        // bind panel visibility
        viewVisibleCommand
            .bind(to: codeView.rx.isHidden)
            .disposed(by: bag)
        
        digitsField.rx.tapGesture()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                if !self.digitsField.isFirstResponder {
                    self.view.frame.origin.y = -140
                }
            }).disposed(by: bag)
        
        // subscribe to send verification code button
        handleSendVerificationCode()
    }
    
    private func handleSendVerificationCode() {
        sendPhoneButton.rx.tap
            .debug()
            .flatMap({ [weak self] _ -> Observable<Void> in
                guard let `self` = self, let number = self.phoneField.text
                    else { return .error(Errors.unknown) }
                self.phoneField.resignFirstResponder()
                self.sendPhoneButton.isEnabled = false
                return APIManager.api.sendPhoneVerificationCode(number).asObservable()
            })
            .flatMapLatest({ _ in
                return Observable.just(true)
            })
            .catchError({ [weak self] _ in
                // subscribe again
                defer { self?.handleSendVerificationCode() }
                self?.sendPhoneButton.isEnabled = true
                return Observable.just(false)
            })
            .map({ !$0 })
            .bind(to: viewVisibleCommand)
            .disposed(by: bag)
    }
}

extension ActivationViewController: KWVerificationCodeViewDelegate {
    func didChangeVerificationCode() {
        //TEMP
        if digitsField.getVerificationCode().count == 4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.performSegue(withIdentifier: "activate-accepted", sender: self)
            }
        }
    }
}
