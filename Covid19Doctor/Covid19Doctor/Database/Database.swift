//
//  Database.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 15/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import RealmSwift

class Database {
    
    static let shared = Database()
    
    private init() {
        
    }
    
    let configuration = Realm.Configuration()
    
    func realm() -> Realm {
        return try! Realm(configuration: configuration)
    }
}

// MARK: - Account
extension Database {
    enum AccountKey: String {
        case phoneNumber
        case activated
    }
    
    private func write(_ val: String?, forKey key: AccountKey) {
        let realm = self.realm()
        let object = AccountObject()
        object.name = key.rawValue
        object.val = val
        try! realm.write {
            realm.add(object, update: .all)
        }
    }
    
    private func read(_ key: AccountKey) -> AccountObject? {
        let realm = self.realm()
        return realm.object(ofType: AccountObject.self, forPrimaryKey: key.rawValue)
    }
    
    func setAccountPhoneNumber(_ val: String) {
        write(val, forKey: .phoneNumber)
    }
    
    func getAccountPhoneNumber() -> String? {
        return read(.phoneNumber)?.val
    }
    
    func setAccountActivated(_ val: Bool) {
        write("\(val)", forKey: .activated)
    }
    
    func isAccountActivated() -> Bool {
        let o = read(.activated)
        if let val = o?.val {
            return Bool(val) ?? false
        }
        return false
    }
}
