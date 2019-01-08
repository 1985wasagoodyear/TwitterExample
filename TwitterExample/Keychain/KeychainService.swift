//
//  KeychainService.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/8/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

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
}
