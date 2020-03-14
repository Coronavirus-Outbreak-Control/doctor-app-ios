//
//  Utils.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 12/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit

extension DispatchQueue {
    func delay(_ delay: Double, closure: @escaping () -> ()) {
        let when = DispatchTime.now() + delay
        self.asyncAfter(deadline: when, execute: closure)
    }
}

extension UIStoryboard {
    static func getViewController(id: String) -> UIViewController {
        let s = UIStoryboard(name: "Main", bundle: nil)
        return s.instantiateViewController(withIdentifier: id)
    }
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
