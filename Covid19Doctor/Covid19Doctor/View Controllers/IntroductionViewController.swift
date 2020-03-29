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
    @IBOutlet weak var howToButton: UIButton!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.map {
            $0.font = .title
            $0.textColor = .titleBlack
            
            let text = "Hey Doctor,\n\nWelcome to\nanonymous\nCovidCommunity\nAlert 👋"
            let str = "CovidCommunity"
            let range = (text as NSString).range(of: str)
            let attributed = NSMutableAttributedString(string: text)
            attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.mainTheme, range: range)
            $0.attributedText = attributed
        }
        
        subtitleLabel.map {
            $0.font = .subtitle
            $0.textColor = .textGray
            $0.text = "Insieme possiamo salvare vite!"
        }
        
        continueButton.map {
            $0.titleLabel?.font = .button
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .mainTheme
//            $0.setTitle("LET'S GET STARTED", for: .normal)
            $0.setTitle("INIZIAMO", for: .normal)
        }
        
        howToButton.map {
            $0.setTitle("COME FUNZIONA 🤔", for: .normal)
            $0.titleLabel?.font = UIFont(name: "SFCompactDisplay-Semibold", size: 15)
            $0.setTitleColor(.titleBlack, for: .normal)
        }

        continueButton.rx.tap.bind {
            let vc = UIStoryboard.getViewController(id: "Activation")
            UIApplication.shared.keyWindow?.rootViewController = vc
        }.disposed(by: bag)
        
        howToButton.rx.tap.bind { [weak self] _ in
            let vc = UIStoryboard.getViewController(id: "HowItWorksViewController")
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
