//
//  OneTimePasswordStore.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 11.07.25.
//

import Foundation
import LocalAuthentication

enum ApplicationError: Error {
    case notFound
    case notImplemented
    case invalidateUri(reason: String)
    case unsupportedOption(reason: String)
    case internalError(reason: String)
}

class SecretStore {
    let context: LAContext
    
    init(context: LAContext) {
        self.context = context
    }
    
    func retrieve(forIdentifier: String) throws -> Data {
        let query: [String:Any] = [
            kSecClass as String: kSecClassKey,
            kSecUseAuthenticationContext as String: context,
            kSecAttrApplicationLabel as String: forIdentifier.data(using: .utf8)!,
            kSecReturnData as String: true,
        ]
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status != errSecItemNotFound else {
            throw ApplicationError.notFound
        }
        guard status == errSecSuccess else {
            throw ApplicationError.internalError(reason: status.description)
        }
        guard let data = result as? Data else {
            throw ApplicationError.internalError(reason: "could not retrieve data")
        }
        
        return data
    }
    
    func save(forIdentifier identifier: String, _ secret: Data) throws {
        let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .userPresence, nil)
        guard let access else {
            throw ApplicationError.internalError(reason: "could not create access control")
        }
        
        let query: [String:Any] = [
            kSecClass as String: kSecClassKey,
            kSecUseAuthenticationContext as String: context,
            kSecAttrApplicationLabel as String: identifier.data(using: .utf8)!,
            kSecValueData as String: secret,
            kSecAttrAccessControl as String: access,
        ]
        
        let deleteStatus = SecItemDelete(query as CFDictionary)
//        guard deleteStatus == secErr else {
//            throw ApplicationError.internalError(reason: "could not delete item")
//        }
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            fatalError("could not add item")
        }
    }
    
    func delete(forIdentifier identifier: String) throws {
        let query: [String:Any] = [
            kSecClass as String: kSecClassKey,
            kSecUseAuthenticationContext as String: context,
            kSecAttrApplicationLabel as String: identifier.data(using: .utf8)!,
        ]
        
        let deleteStatus = SecItemDelete(query as CFDictionary)
        
        guard deleteStatus == errSecSuccess else {
            throw ApplicationError.internalError(reason: "could not delete item")
        }
    }
}
