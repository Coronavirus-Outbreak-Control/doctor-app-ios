//
//  ActivatedViewController.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 11/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import PMSuperButton

class ActivatedViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var button: PMSuperButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.map {
            $0.font = .title
            $0.textColor = .titleBlack
            $0.text = NSLocalizedString("all_set", comment: "")
        }
        
        textLabel.map {
            $0.font = .subtitle
            $0.textColor = .titleBlack
            $0.text = NSLocalizedString("what_to_do", comment: "")
        }
        
        button.map {
            $0.titleLabel?.font = .button
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .mainTheme
            $0.setTitle(NSLocalizedString("go", comment: ""), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        let vc = UIStoryboard.getViewController(id: "Activity")
        let nc = UINavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController = nc
    }
}
