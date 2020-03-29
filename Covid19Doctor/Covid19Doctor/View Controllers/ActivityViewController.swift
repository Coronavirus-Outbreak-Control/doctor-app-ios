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
    @IBOutlet weak var inviteButton: PMSuperButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var qrTextLabel: UILabel!
    
    private let bag = DisposeBag()
    
    private func configureUI() {
        titleLabel.map {
            $0.font = .title
            $0.textColor = .titleBlack
            
            let text = "Welcome to\nCoviDoc"
            let str = "Covi"
            let range = (text as NSString).range(of: str)
            let attributed = NSMutableAttributedString(string: text)
            attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.mainTheme, range: range)
            $0.attributedText = attributed
        }
        
        qrTextLabel.text = "CLICCA QUI PER SCANSIONARE IL\nCODICE QR" //"CLICK HERE TO\nSCAN QR CODE"
        qrTextLabel.font = UIFont(name: "SFCompactDisplay-Semibold", size: 20)
        qrTextLabel.textColor = .white
        
        inviteButton.titleLabel?.font = .button
        inviteButton.setTitleColor(.white, for: .normal)
        inviteButton.backgroundColor = .mainTheme
//        inviteButton.setTitle("INVITE OTHER DOCTORS", for: .normal)
        inviteButton.setTitle("INVITA ALTRI DOTTORI", for: .normal)
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
    
    // MARK: - Scanner
    
    private func extractPatientData(string: String) -> Single<String> {
        if let id = string.deletingPrefix("covid-outbreak-control:") {
            return .just(id)
        } else {
            return .error(Errors.patientNotRecognized)
        }
    }
    
    private func launchScanner() {
        let scanner = UIStoryboard.getViewController(id: "ScannerViewController") as! ScannerViewController
        let scannerNC = UINavigationController(rootViewController: scanner)
        present(scannerNC, animated: true, completion: nil)
        
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
        
        guard let reAuthToken: String = Database.shared.getAccountValue(key: .reAuthToken) else {
            //TODO: handle error
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
            self?.view.makeToast("Dottore invitato: \(contact.fullName)", duration: 3.0, position: .center)
        }, onError: { [weak self] _ in
            self?.view.hideToastActivity()
            self?.view.makeToast("Error durante l'invito di \(contact.fullName)", duration: 3.0, position: .center)
        })
        .disposed(by: bag)
    }
    
    private func promptInvitation(contact: Contact, phoneNumber: String) {
        // phoneNumber is already validated
        let alertController = UIAlertController(title: "Stai invitando\n\(phoneNumber)", message: "Confermi l'invito?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "No", style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)

        let okAction = UIAlertAction(title: "Sì", style: .default) { [weak self] _ in
            self?.inviteContact(contact, phoneNumber: phoneNumber)
        }
        alertController.addAction(okAction)

        present(alertController, animated: true)
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
                    self?.view.makeToast("Il numero selezionato non è valido", duration: 3.0, position: .center)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
