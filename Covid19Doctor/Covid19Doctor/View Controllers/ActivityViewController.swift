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
    @IBOutlet weak var invitationsButton: PMSuperButton!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            self?.launchScanner()
        })
        .disposed(by: bag)

        inviteButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            self?.launchContactPicker()
        })
        .disposed(by: bag)
        
        invitationsButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            self?.launchInvitations()
        })
        .disposed(by: bag)
    }
    
    // MARK: - Scanner
    
    private func extractPatientData(string: String) -> Single<String> {
        if true {
            // TODO: extract real data
            return .just(string)
        } else {
            return .error(Errors.patientNotRecognized)
        }
    }
    
    private func launchScanner() {
        let scanner = UIStoryboard.getViewController(id: "ScannerViewController") as! ScannerViewController
        present(scanner, animated: true, completion: nil)
        
        scanner.output
        .flatMap({ self.extractPatientData(string: $0) })
        .subscribe(onNext: { [weak self] string in
            self?.launchPatientScreen(patientId: string)
        }, onError: { error in
            // TODO: show error to user
        })
        .disposed(by: bag)
    }
    
    private func launchPatientScreen(patientId: String) {
        let vc = UIStoryboard.getViewController(id: "PatientViewController") as! PatientViewController
        vc.patientId = patientId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Invite
    
    private func launchContactPicker() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        // return only contacts with phone numbers
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        // return only phone numbers
        contactPicker.displayedPropertyKeys = ["phoneNumbers"]
        present(contactPicker, animated: true)
    }
    
    private func inviteContact(_ contact: Contact, phoneNumber: String) {
        view.makeToastActivity(.center)
        
        APIManager.api.inviteDoctor(number: phoneNumber)
        .do(onDispose: { [weak self] in
            self?.view.hideToastActivity()
        })
        .subscribe(onSuccess: { [weak self] _ in
            self?.storeInvitation(name: contact.fullName, phoneNumber: phoneNumber)
            self?.view.makeToast("Invitation sent to \(contact.fullName)", duration: 3.0, position: .center)
        }, onError: { [weak self] _ in
            self?.view.makeToast("Error inviting \(contact.fullName)", duration: 3.0, position: .center)
        })
        .disposed(by: bag)
    }
    
    private func storeInvitation(name: String, phoneNumber: String) {
        let realm = Database.shared.realm()
        let invitation = InvitationObject()
        invitation.phoneNumber = phoneNumber
        invitation.contactName = name
        try! realm.write {
            realm.add(invitation)
        }
    }
    
    // MARK: - Invitations
    
    private func launchInvitations() {
        let vc = UIStoryboard.getViewController(id: "InvitationsViewController") as! InvitationsViewController
        navigationController?.pushViewController(vc, animated: true)
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
