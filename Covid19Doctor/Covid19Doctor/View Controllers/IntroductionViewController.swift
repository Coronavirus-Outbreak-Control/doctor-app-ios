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

class IntroductionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var continueButton: PMSuperButton!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.map {
            $0.font = .title
            $0.textColor = .titleBlack
            
            let text = "Welcome to\nanonymous\nCoronavirus\nalert"
            let str = "Coronavirus"
            let range = (text as NSString).range(of: str)
            let attributed = NSMutableAttributedString(string: text)
            attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.mainTheme, range: range)
            $0.attributedText = attributed
        }
        
        subtitleLabel.map {
            $0.font = .subtitle
            $0.textColor = .textGray
        }
        
        continueButton.map {
            $0.titleLabel?.font = .button
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .mainTheme
            $0.setTitle("LET'S GET STARTED", for: .normal)
        }

        continueButton.rx.tap.bind {
            let vc = UIStoryboard.getViewController(id: "Activation")
            UIApplication.shared.keyWindow?.rootViewController = vc
        }.disposed(by: bag)
    }
}
