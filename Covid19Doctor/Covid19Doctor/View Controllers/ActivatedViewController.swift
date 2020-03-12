//
//  ActivatedViewController.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 11/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit

class ActivatedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.getViewController(id: "Activity")
        }
    }
}
