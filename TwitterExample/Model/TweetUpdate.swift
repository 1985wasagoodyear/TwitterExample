//
//  TweetUpdate.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/8/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

struct TweetUpdate: Encodable {
    let status: String
    
    init?(status: String) {
        if status.count > TweetInfo.characterLimit { return nil }
        self.status = status
    }
    
    func statusURLString() -> String? {
        return (TwitterURLs.Tweets.update + "?status=" + self.status).urlEncoded()
    }
}

struct TweetInfo {
    static let characterLimit = 280
}
