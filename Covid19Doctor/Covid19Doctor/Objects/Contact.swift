//
//  Contact.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 14/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import Contacts

typealias PhoneNumber = (number: String, label: String?)

struct Contact {
    let fullName: String
    let phoneNumbers: [PhoneNumber]
    
    init?(contact: CNContact) {
        guard let fullName = CNContactFormatter.string(from: contact, style: .fullName)
        else {
            return nil
        }
        
        let phones = contact.phoneNumbers.map { ($0.value.stringValue, $0.label) }
        if phones.count == 0 {
            return nil
        }
        
        self.fullName = fullName
        self.phoneNumbers = phones
    }
}
