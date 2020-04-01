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
    
    let configuration = Realm.Configuration(encryptionKey: Database.getKey() as Data)
    
    func realm() -> Realm {
        return try! Realm(configuration: configuration)
    }
    
    func isActivated() -> Bool {
        let userId: String? = getAccountValue(key: .userId)
        let authToken: String? = getAccountValue(key: .reAuthToken)
        return userId != nil && authToken != nil
    }
    
    
    /// Generate a key associated with this app or get
    /// the key from keychain if already exists
    /// - Returns: the key
    private static func getKey() -> NSData {
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier = "\(Bundle.main.bundleIdentifier!)-db"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!

        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]

        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! NSData
        }

        // No pre-existing key from this application, so generate a new one
        let keyData = NSMutableData(length: 64)!
        let result = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64))
        assert(result == 0, "Failed to get random bytes")

        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData
        ]

        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        
        return keyData
    }
}

// MARK: - Account
extension Database {
    enum AccountKey: String {
        case userId
        case reAuthToken
        case phoneNumber
        case jwt
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
