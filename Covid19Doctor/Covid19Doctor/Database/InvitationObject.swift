//
//  InvitationObject.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 21/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import RealmSwift

class InvitationObject: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var contactName: String = ""
    @objc dynamic var date: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
