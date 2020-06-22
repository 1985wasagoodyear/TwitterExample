//
//  KeychainService.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/8/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

public struct KeychainKeys {
    public static let oauthToken = "oauthToken"
    public static let oauthSecret = "oauthSecret"
}

public final class KeychainService {
    
    public static func update(name: String, password: String) {
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                account: name,
                                                accessGroup: KeychainConfiguration.accessGroup)
        do {
            try passwordItem.savePassword(password)
        } catch { // unhandledError(status: -34018); osstatus "34018"
            print(error)
        }
    }
    
    public static func get(name: String) -> String? {
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                account: name,
                                                accessGroup: KeychainConfiguration.accessGroup)
        do {
            return try passwordItem.readPassword()
        } catch {
            print(error)
            return nil
        }
    }
    
    public static func delete(name: String) {
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                account: name,
                                                accessGroup: KeychainConfiguration.accessGroup)
        do {
            try passwordItem.deleteItem()
        } catch {
            print(error)
        }
    }
    
    public static func deleteAll() {
        guard let items = try? KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.serviceName) else { return }
        items.forEach { try? $0.deleteItem() }
    }
}
