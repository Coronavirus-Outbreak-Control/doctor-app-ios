//
//  Utils.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 12/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func getViewController(id: String) -> UIViewController {
        let s = UIStoryboard(name: "Main", bundle: nil)
        return s.instantiateViewController(withIdentifier: id)
    }
}
