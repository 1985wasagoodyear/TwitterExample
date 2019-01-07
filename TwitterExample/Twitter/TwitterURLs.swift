//
//  TwitterURLs.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

extension String {
    func url() -> URL? {
        return URL(string: self)
    }
}

struct TwitterURLs {
    static let requestTokenURL = "https://api.twitter.com/oauth/request_token"
    static let bearerTokenURL = "https://api.twitter.com/oauth2/token"
}
