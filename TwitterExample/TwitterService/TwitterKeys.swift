//
//  TwitterKeys.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

struct TwitterKeys {
    static let apiKey = "v4r1zdwqVfPH1euxul8zszm5Y"
    static let apiSecret = "tAoqDO5HIQjhGJuPSWasgEDMwJ85yr9cUKMFiZeodgswsbUa4P"
    
    static func basicAuthentication() -> String {
        
        let utf8str = (TwitterKeys.apiKey + ":" +  TwitterKeys.apiSecret).data(using: .utf8)!
        
        let base64Encoded = utf8str.base64EncodedString(options: [])
        
        return base64Encoded
    }
}
