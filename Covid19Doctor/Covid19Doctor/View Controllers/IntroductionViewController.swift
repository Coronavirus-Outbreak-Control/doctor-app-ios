//
//  IntroductionViewController.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 11/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import PMSuperButton
import RxSwift
import RxCocoa
import FittableFontLabel

class IntroductionViewController: UIViewController {

    @IBOutlet weak var titleLabel: FittableFontLabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var continueButton: PMSuperButton!
    @IBOutlet weak var howToButton: UIButton!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.map {
            $0.font = .title
            $0.textColor = .titleBlack
            
            let text = NSLocalizedString("welcome", comment: "")
            // set inset as a workaround
            // for miscalculation of FittabbleFontLabel
            $0.leftInset = -1
            $0.rightInset = -1
            let str = "CovidCommunity"
            let range = (text as NSString).range(of: str)
            let attributed = NSMutableAttributedString(string: text)
            attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.mainTheme, range: range)
            $0.attributedText = attributed
        }
        
        subtitleLabel.map {
            $0.font = .subtitle
            $0.textColor = .textGray
            $0.text = NSLocalizedString("together_we", comment: "")
        }
        
        continueButton.map {
            $0.titleLabel?.font = .button
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .mainTheme
            $0.setTitle(NSLocalizedString("let_s_get_s", comment: ""), for: .normal)
        }
        
        howToButton.map {
            $0.setTitle(NSLocalizedString("bt_how_it_works", comment: ""), for: .normal)
            $0.titleLabel?.font = UIFont(name: "SFCompactDisplay-Semibold", size: 15)
            $0.setTitleColor(.titleBlack, for: .normal)
        }

        continueButton.rx.tap.bind {
            let vc = UIStoryboard.getViewController(id: "Activation")
            UIApplication.shared.keyWindow?.rootViewController = vc
        }.disposed(by: bag)
        
        howToButton.rx.tap.bind { [weak self] _ in
            let vc = UIStoryboard.getViewController(id: "Help")
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
