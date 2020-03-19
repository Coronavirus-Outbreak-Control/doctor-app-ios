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
import Toast_Swift

class ActivationViewController: UIViewController {
    
    @IBOutlet weak var phoneField: PhoneNumberTextField!
    @IBOutlet weak var sendPhoneButton: PMSuperButton!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var digitsField: KWVerificationCodeView!
    
    private let bag = DisposeBag()
    private let viewVisibleCommand = PublishRelay<Bool>()
    private let verificationCode = PublishRelay<String>()

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
        
        // action when send verification code button is tapped
        handleSendVerificationCode()
        
        // action when verfication code button is tapped
        handleCodeVerification()
    }
    
    // MARK: -
    
    private var jwtToken: String?
    
    private func handleSendVerificationCode() {
        sendPhoneButton.rx.tap
            .flatMap({ [weak self] _ -> Observable<SendPhoneVerificationCodeResponse> in
                guard let `self` = self, let number = self.phoneField.text
                    else { return .error(Errors.unknown) }
                self.phoneField.resignFirstResponder()
                self.sendPhoneButton.isEnabled = false
                return APIManager.api.sendPhoneVerificationCode(number).asObservable()
            })
            .flatMapLatest({ [weak self] response -> Observable<Bool> in
                self?.jwtToken = response.data
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
    
    private func handleCodeVerification() {
        verificationCode
            .skip(1)    // skip on subscription
            .map({ $0.digits })
            .filter({ $0.count == self.digitsField.digits })
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest({ [weak self] code -> Single<VerifyPhoneCodeResponse> in
                guard let `self` = self,
                    let token = self.jwtToken
                    else { return .error(Errors.missingActivationToken) }
                return APIManager.api.verifyPhoneCode(code, token: token)
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.delay(1) {
                    self?.performSegue(withIdentifier: "activate-accepted", sender: self)
                }
            }, onError: { [weak self] _ in
                self?.view.makeToast("Invalid code", duration: 3.0, position: .top)
                self?.handleCodeVerification()
            })
            .disposed(by: bag)
    }
}

extension ActivationViewController: KWVerificationCodeViewDelegate {
    func didChangeVerificationCode() {
        verificationCode.accept(digitsField.getVerificationCode())
    }
}
