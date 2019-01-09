//
//  KeychainService.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/8/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

struct KeychainKeys {
    static let oauthToken = "oauthToken"
    static let oauthSecret = "oauthSecret"
}

final class KeychainService {
    
    static func update(name: String, password: String) {
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                account: name,
                                                accessGroup: nil)
        try? passwordItem.savePassword(password)
    }
    
    static func get(name: String) -> String? {
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                account: name,
                                                accessGroup: nil)
        return try? passwordItem.readPassword()
        
    }
    
    static func deleteAll() {
        if let items = try? KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.serviceName) {
            for item in items {
                try? item.deleteItem()
            }
        }
    }
}
