//
//  ActivityViewController.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 11/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import PMSuperButton
import ContactsUI
import RxSwift
import RxCocoa
import Toast_Swift

class ActivityViewController: UIViewController {

    @IBOutlet weak var scanButton: PMSuperButton!
    @IBOutlet weak var inviteButton: PMSuperButton!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inviteButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            // return only contacts with phone numbers
            contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
            // return only phone numbers
            contactPicker.displayedPropertyKeys = ["phoneNumbers"]
            self.present(contactPicker, animated: true)
        })
        .disposed(by: bag)
    }
    
    private func inviteContact(_ contact: Contact, phoneNumber: String) {
        view.makeToastActivity(.center)
        
        APIManager.api.sendInvitation(toNumber: phoneNumber)
        .do(onDispose: { [weak self] in
            self?.view.hideToastActivity()
        })
        .subscribe(onSuccess: { [weak self] _ in
            self?.view.makeToast("Invitation sent to \(contact.fullName)", duration: 3.0, position: .center)
        }, onError: { [weak self] _ in
            self?.view.makeToast("Error inviting \(contact.fullName)", duration: 3.0, position: .center)
        })
        .disposed(by: bag)
    }
}

extension ActivityViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        if let phoneNumber = contactProperty.value as? CNPhoneNumber,
            let contact = Contact(contact: contactProperty.contact) {
            inviteContact(contact, phoneNumber: phoneNumber.stringValue)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
