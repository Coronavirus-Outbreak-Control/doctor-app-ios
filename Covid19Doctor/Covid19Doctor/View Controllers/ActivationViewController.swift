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
    
    let api: API! = NetworkAPI()
    
    let bag = DisposeBag()
    
    let viewVisibleCommand = PublishRelay<Bool>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        digitsField.delegate = self
        codeView.isHidden = true

        view.rx.tapGesture().subscribe(onNext: { [weak self] _ in
            self?.phoneField.resignFirstResponder()
            self?.digitsField.resignFirstResponder()
        }).disposed(by: bag)
        
        sendPhoneButton.rx.tap
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
            guard let `self` = self, let number = self.phoneField.text
                else { return .just(false) }
                self.phoneField.resignFirstResponder()
            return self.api.checkPhoneNumber(number).asObservable()
        }
            .map({!$0})
            .bind(to: viewVisibleCommand)
            .disposed(by: bag)
        
        viewVisibleCommand
            .bind(to: codeView.rx.isHidden)
            .disposed(by: bag)
        
        digitsField.rx.tapGesture()
            .subscribe(onNext: { [weak self] _ in
                self?.view.frame.origin.y -= 210
            }).disposed(by: bag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
