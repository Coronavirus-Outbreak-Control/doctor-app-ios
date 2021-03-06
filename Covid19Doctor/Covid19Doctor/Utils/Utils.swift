//
//  Utils.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 12/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import PhoneNumberKit
import RxSwift

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

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

extension PhoneNumberTextField {
    func getPhoneNumber() -> Single<String> {
        guard let text = text else {
            return .error(Errors.invalidPhoneNumber)
        }
        
        let kit = self.phoneNumberKit
        do {
            let phoneNumber = try kit.parse(text, withRegion: currentRegion, ignoreType: false)
            let string = "+\(phoneNumber.countryCode)\(phoneNumber.nationalNumber)"
            return .just(string)
        }
        catch {
            return .error(Errors.invalidPhoneNumber)
        }
    }
}

extension PhoneNumberKit {
    func validatedPhoneNumber(string: String) -> String? {
        do {
            let phoneNumber = try parse(string)
            return "+\(phoneNumber.countryCode)\(phoneNumber.nationalNumber)"
        }
        catch {
            return nil
        }
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String? {
        guard self.hasPrefix(prefix) else { return nil }
        return String(self.dropFirst(prefix.count))
    }
}
