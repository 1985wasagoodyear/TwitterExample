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
    
    var statusURLString: String? {
        guard let suffix = self.status.encodingForRFC3986() else {
            return nil
        }
        return TwitterURLs.Tweets.update + "?status=" + suffix
    }
}

struct TweetInfo {
    static let characterLimit = 280
}
