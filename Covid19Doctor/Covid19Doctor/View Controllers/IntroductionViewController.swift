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

    @IBOutlet weak var continueButton: PMSuperButton!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.rx.tap.bind {
            let vc = UIStoryboard.getViewController(id: "Activation")
            UIApplication.shared.keyWindow?.rootViewController = vc
        }.disposed(by: bag)
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
