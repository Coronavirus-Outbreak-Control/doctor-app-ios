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
            $0.font = UIFont.title
            $0.textColor = UIColor.titleBlack
            $0.text = "Welcome to\nanonymous\nCoronavirus\ncheck"
        }
        
        subtitleLabel.map {
            $0.font = UIFont.subtitle
            $0.textColor = UIColor.textGray
        }
        
        continueButton.map {
            $0.titleLabel?.font = UIFont.button
            $0.setTitleColor(UIColor.titleBlack, for: .normal)
            $0.backgroundColor = UIColor.mainTheme
            $0.setTitle("CONTINUE", for: .normal)
        }

        continueButton.rx.tap.bind {
            let vc = UIStoryboard.getViewController(id: "Activation")
            UIApplication.shared.keyWindow?.rootViewController = vc
        }.disposed(by: bag)
    }
}
