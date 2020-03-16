//
//  AccountObject.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 15/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import RealmSwift

class AccountObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var val: String?
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
