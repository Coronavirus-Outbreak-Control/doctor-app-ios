//
//  PendingViewController.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 05/04/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import PMSuperButton
import Toast_Swift

class PendingViewController: UIViewController {

    @IBOutlet weak var text1Label: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var tapToCopyLabel: UILabel!
    @IBOutlet weak var text2Label: UILabel!
    @IBOutlet weak var text3Label: UILabel!
    
    @IBOutlet weak var continueButton: PMSuperButton!
    
    @IBOutlet weak var choiceView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var yesButton: PMSuperButton!
    @IBOutlet weak var noButton: PMSuperButton!
    
    private let bag = DisposeBag()
    
    var publicPatientId: String!
    var patientId: String! {
        didSet {
            publicPatientId = Scanner.computePublicPatientId(patientId: patientId)
        }
    }
    
    private func configureUI() {
        text1Label.map {
            $0.text = NSLocalizedString("view_pending_text1", comment: "")
            $0.textColor = .titleBlack
            $0.font = UIFont(name: "SFCompactDisplay-Regular", size: 20)
        }
        
        idLabel.map {
            $0.text = publicPatientId
            $0.textColor = .black
            $0.font = UIFont(name: "SFCompactDisplay-Semibold", size: 40)
        }
        
        tapToCopyLabel.map {
            $0.text = NSLocalizedString("view_pending_tap_to_copy", comment: "")
            $0.textColor = .textGray
            $0.font = UIFont(name: "SFCompactDisplay-Light", size: 18)
        }
        
        text2Label.map {
            $0.text = NSLocalizedString("view_pending_text2", comment: "")
            $0.textColor = .titleBlack
            $0.font = UIFont(name: "SFCompactDisplay-Regular", size: 24)
        }
        
        text3Label.map {
            let suspectWord = NSLocalizedString("suspect", comment: "")
            let text = String(format: NSLocalizedString("view_pending_text3", comment: ""), suspectWord)
            let str = suspectWord
            let range = (text as NSString).range(of: str)
            let attributed = NSMutableAttributedString(string: text)
            attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.statusPending, range: range)
            
            $0.attributedText = attributed
            $0.textColor = .titleBlack
            $0.font = UIFont(name: "SFCompactDisplay-Regular", size: 30)
        }
        
        continueButton.map {
            $0.setTitle(NSLocalizedString("continue", comment: "").uppercased(), for: .normal)
            $0.setTitleColor(.mainTheme, for: .normal)
            $0.titleLabel?.font = .button
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.mainTheme.cgColor
            $0.layer.borderWidth = 1
        }
        
        questionLabel.map {
            $0.text = NSLocalizedString("view_pending_question", comment: "")
            $0.textColor = .titleBlack
            $0.font = UIFont(name: "SFCompactDisplay-Regular", size: 24)
        }
        
        yesButton.map {
            $0.setTitle(NSLocalizedString("yes", comment: "").uppercased(),
                        for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .button
            $0.backgroundColor = .mainTheme
        }
        
        noButton.map {
            $0.setTitle(NSLocalizedString("no", comment: "").uppercased(),
                        for: .normal)
            $0.setTitleColor(.mainTheme, for: .normal)
            $0.titleLabel?.font = .button
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.mainTheme.cgColor
            $0.layer.borderWidth = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        continueButton.rx.tap
            .map({ false })
            .bind(to: choiceView.rx.isHidden)
            .disposed(by: bag)
        
        noButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: false)
            })
            .disposed(by: bag)
        
        yesButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.launchStatusScreen()
            })
            .disposed(by: bag)
        
        idLabel.rx.tapGesture()
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                UIPasteboard.general.string = self?.idLabel.text
                self?.showCopied()
            })
            .disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func showCopied() {
        view.makeToast(NSLocalizedString("view_pending_copied", comment: ""))
    }
    
    private func launchStatusScreen() {
        let vc = UIStoryboard.getViewController(id: "PatientViewController") as! PatientViewController
        vc.patientId = patientId
        navigationController?.pushViewController(vc, animated: true)
    }
}
