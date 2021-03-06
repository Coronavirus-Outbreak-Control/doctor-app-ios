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
import RxKeyboard
import PhoneNumberKit
import PMSuperButton
import KWVerificationCodeView
import Toast_Swift

class ActivationViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var phoneField: PhoneNumberTextField!
    @IBOutlet weak var sendPhoneButton: PMSuperButton!
    @IBOutlet weak var retryLabel: UILabel!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var digitsField: KWVerificationCodeView!
    @IBOutlet weak var codeTextLabel: UILabel!
    
    private let bag = DisposeBag()
    private let viewVisibleCommand = PublishRelay<Bool>()
    private let verificationCode = PublishRelay<String>()
    private let keyboardTop = BehaviorRelay<CGFloat>(value: 100000)
    
    private func configureUI() {
        phoneField.placeholder = NSLocalizedString("phone_number", comment: "")
        phoneField.withFlag = true
        phoneField.withPrefix = true
        if #available(iOS 11.0, *) {
            phoneField.withDefaultPickerUI = true
        }
        
        titleLabel.font = .title
        titleLabel.textColor = .titleBlack
        titleLabel.text = NSLocalizedString("verify_number", comment: "")
        
        textLabel.font = .caption
        textLabel.textColor = .textGray
        
        retryLabel.font = UIFont(name: "SFCompactDisplay-Regular", size: 15)
        retryLabel.textColor = .textGray
        
        codeTextLabel.text = NSLocalizedString("tv_code", comment: "")
        
        lineView.backgroundColor = .mainTheme
        
        phoneField.tintColor = .mainTheme
        
        sendPhoneButton.titleLabel?.font = .button
        sendPhoneButton.setTitleColor(.white, for: .normal)
        sendPhoneButton.backgroundColor = .mainTheme
        sendPhoneButton.setTitle(NSLocalizedString("bt_send_number", comment: ""), for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        digitsField.delegate = self
        codeView.isHidden = true
        textLabel.text = NSLocalizedString("insert_num", comment: "")

        // dismiss keyboard on tap
        view.rx.tapGesture().subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
            self?.resetViewPosition()
        }).disposed(by: bag)
        
        // bind panel visibility
        viewVisibleCommand
            .bind(to: codeView.rx.isHidden)
            .disposed(by: bag)
        
        digitsField.rx.tapGesture()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                if !self.digitsField.isFirstResponder {
                    // move after because we have to wait the change of keyboard frame
                    DispatchQueue.main.async {
                        self.handleKeyboardForView(self.digitsField, keyboardTop: self.keyboardTop.value)
                    }
                }
            }).disposed(by: bag)
        
        RxKeyboard.instance.frame
            .asObservable()
            .map({ $0.origin.y })
            .bind(to: keyboardTop)
            .disposed(by: bag)
        
        // action when send verification code button is tapped
        handleSendVerificationCode()
        
        // action when verfication code button is tapped
        handleCodeVerification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Handle text fields with keyboard
    
    private func handleKeyboardForView(_ target: UIView, keyboardTop: CGFloat) {
        let targetBottom = target.convert(CGPoint(x: 0, y: target.bounds.size.height), to: view).y
        let diff = targetBottom - keyboardTop
        if diff > 0 {
            UIView.animate(withDuration: 0.2) {
                self.view.frame.origin.y = -diff
            }
        }
    }
    
    private func resetViewPosition() {
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: -
    
    private var phoneNumber: String?
    
    private func handleSendVerificationCode() {
        sendPhoneButton.rx.tap
            .flatMap({ [weak self] _ -> Single<String> in
                guard let `self` = self else { return .error(Errors.unknown) }
                return self.phoneField.getPhoneNumber()
            })
            .flatMap({ [weak self] number -> Observable<Empty> in
                self?.didGetPhoneNumber(number)
                self?.setSendButtonEnabled(false)
                return APIManager.api.sendPhoneVerificationCode(number).asObservable()
                    .timeout(.seconds(30), scheduler: MainScheduler.instance)
            })
            .flatMap({ [weak self] response -> Observable<Bool> in
                self?.runTimerForResend()
                return Observable.just(true)
            })
            .catchError({ [weak self] error in
                // subscribe again
                defer { self?.handleSendVerificationCode() }
                self?.setSendButtonEnabled(true)
                self?.stopTimerForResend()
                return .just(false)
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
            .distinctUntilChanged()
            .flatMapLatest({ code -> Single<VerifyPhoneCodeResponse> in
                return APIManager.api.verifyPhoneCode(code)
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                self?.didActivate(response: response)
                DispatchQueue.main.delay(1) {
                    self?.performSegue(withIdentifier: "activate-accepted", sender: self)
                }
            }, onError: { [weak self] error in
                self?.didReceiveError(error)
                self?.handleCodeVerification()
            })
            .disposed(by: bag)
    }
    
    var timerBag = DisposeBag()
    private func runTimerForResend() {
        timerBag = DisposeBag()
        
        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        let counter = timer
            .scan(45, accumulator: { count, c in
                count - 1
            })
            .share()
        
        counter
            .filter({ $0 == 0 })
            .subscribe(onNext: { [weak self] _ in
                self?.setSendButtonEnabled(true)
                self?.timerBag = DisposeBag()
            }, onDisposed: { [weak self] in
                self?.retryLabel.text = " "
            })
            .disposed(by: timerBag)
        
        counter
            .map({ String(format: NSLocalizedString("retry_time", comment: ""), $0) })
            .bind(to: retryLabel.rx.text)
            .disposed(by: timerBag)
    }
    
    private func stopTimerForResend() {
        timerBag = DisposeBag()
    }
    
    private func didActivate(response: VerifyPhoneCodeResponse) {
        if let phoneNumber = phoneNumber {
            Database.shared.setAccountValue(response.id, key: .userId)
            Database.shared.setAccountValue(response.token, key: .reAuthToken)
            Database.shared.setAccountValue(phoneNumber, key: .phoneNumber)
        }
        
        phoneNumber = nil
    }
    
    private func didReceiveError(_ error: Error) {
        let text: String
        if let error = error as? Errors {
            switch error {
                //TODO: show errors
            default:
                text = NSLocalizedString("err_code", comment: "")
            }
        } else {
            text = NSLocalizedString("err_code", comment: "")
        }
        
        view.makeToast(text)
    }
    
    // MARK: -
    
    private func didGetPhoneNumber(_ number: String) {
        self.phoneField.resignFirstResponder()
        self.phoneNumber = number
    }
    
    private func setSendButtonEnabled(_ val: Bool) {
        DispatchQueue.main.async {
            self.sendPhoneButton.isEnabled = val
            self.sendPhoneButton.alpha = val ? 1 : 0.4
        }
    }
}

extension ActivationViewController: KWVerificationCodeViewDelegate {
    func didChangeVerificationCode() {
        verificationCode.accept(digitsField.getVerificationCode())
    }
}
