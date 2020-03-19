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
        #if DEBUG
        print("\n\n\n-> database <-\n\(String(describing: configuration.fileURL!.path))\n\n\n")
        #endif
    }
    
    let configuration = Realm.Configuration()
    
    func realm() -> Realm {
        return try! Realm(configuration: configuration)
    }
    
    func isActivated() -> Bool {
        let userId: String? = getAccountValue(key: .userId)
        let authToken: String? = getAccountValue(key: .authToken)
        return userId != nil && authToken != nil
    }
}

// MARK: - Account
extension Database {
    enum AccountKey: String {
        case userId
        case authToken
        case phoneNumber
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
    
    func setAccountValue<T: CustomStringConvertible>(_ val: T, key: AccountKey) {
        write("\(val)", forKey: key)
    }
    
    func getAccountValue<T: CustomStringConvertible>(key: AccountKey) -> T? {
        return read(key)?.val as? T
    }
}
