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
import RxGesture
import Toast_Swift
import PhoneNumberKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var enterButton: PMSuperButton!
    @IBOutlet weak var inviteButton: PMSuperButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var qrTextLabel: UILabel!
    
    private let bag = DisposeBag()
    
    private func configureUI() {
        titleLabel.map {
            $0.font = .title
            $0.textColor = .titleBlack
            
            let text = NSLocalizedString("main_title", comment: "")
            let str = "Covi"
            let range = (text as NSString).range(of: str)
            let attributed = NSMutableAttributedString(string: text)
            attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.mainTheme, range: range)
            $0.attributedText = attributed
        }
        
        qrTextLabel.text = NSLocalizedString("bt_scan_qrcode", comment: "")
        qrTextLabel.font = UIFont(name: "SFCompactDisplay-Semibold", size: 20)
        qrTextLabel.textColor = .white
        
        enterButton.map {
            $0.setTitle(NSLocalizedString("bt_update_status", comment: ""), for: .normal)
            $0.titleLabel?.font = .button
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .mainTheme
        }
        
        inviteButton.map {
            $0.setTitle(NSLocalizedString("bt_invite_doc", comment: ""), for: .normal)
            $0.titleLabel?.font = .button
            $0.setTitleColor(.mainTheme, for: .normal)
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.mainTheme.cgColor
            $0.layer.borderWidth = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        scanView.rx.tapGesture()
        .skip(1)
        .subscribe(onNext: { [weak self] _ in
            self?.launchScanner()
        })
        .disposed(by: bag)
        
        enterButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.launchEnterPatient()
            })
            .disposed(by: bag)

        inviteButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            self?.launchContactPicker()
        })
        .disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // recalculate corner radius for buttons because
        // the size of the buttons may change for smaller screens
        let height = enterButton.bounds.height
        [enterButton, inviteButton].forEach {
            $0?.cornerRadius = height/2
        }
    }
    
    // MARK: - Scanner
    
    let scanner = Scanner()
    private func launchScanner() {
        CameraPermission.check(from: self)
            .subscribe(onSuccess: { [weak self] permissionGranted in
                if permissionGranted, let `self` = self {
                    self.scanner.present(from: self)
                }
            })
            .disposed(by: bag)
    }
    
    // MARK: - Enter manually
    
    private func launchEnterPatient() {
        let vc = UIStoryboard.getViewController(id: "EnterPatientViewController")
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
        
        guard let reAuthToken: String = Database.shared.getAccountValue(key: .reAuthToken) else {
            //TODO: handle error Errors.userNotActivated
            return
        }
        
        APIManager.api.runAuthenticated(reAuthToken: reAuthToken, apiBuilder: {
            APIManager.api.inviteDoctor(number: phoneNumber)
        })
        .timeout(.seconds(30), scheduler: MainScheduler.instance)
        .observeOn(MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] _ in
            self?.storeInvitation(name: contact.fullName, phoneNumber: phoneNumber)
            self?.view.hideToastActivity()
            self?.view.makeToast("\(NSLocalizedString("toast_num_doc_invited", comment: "")): \(contact.fullName)")
        }, onError: { [weak self] _ in
            self?.view.hideToastActivity()
            self?.view.makeToast("\(NSLocalizedString("toast_err_doc_invited", comment: "")) \(contact.fullName)")
        })
        .disposed(by: bag)
    }
    
    private func promptInvitation(contact: Contact, phoneNumber: String) {
        // phoneNumber is already validated
        let alertController = UIAlertController(title: "\(NSLocalizedString("alert_inviting_title", comment: ""))\n\(phoneNumber)", message: "\(NSLocalizedString("alert_inviting_text", comment: ""))", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)

        let okAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default) { [weak self] _ in
            self?.inviteContact(contact, phoneNumber: phoneNumber)
        }
        alertController.addAction(okAction)

        present(alertController, animated: true)
        alertController.view.tintColor = .mainTheme
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
            
            picker.dismiss(animated: true) { [weak self] in
                if let number = PhoneNumberKit().validatedPhoneNumber(string: phoneNumber.stringValue) {
                    self?.promptInvitation(contact: contact, phoneNumber: number)
                }
                else {
                    self?.view.makeToast(NSLocalizedString("toast_invalid_number", comment: ""))
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
