//
//  TwitterURLs.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

struct TwitterURLs {
    struct OAuth1 {
        static let requestToken = "https://api.twitter.com/oauth/request_token"
        static let authorize = "https://api.twitter.com/oauth/authorize"
        static let authenticate = "https://api.twitter.com/oauth/authenticate"
        static let accessToken = "https://api.twitter.com/oauth/access_token"
        static let invalidate = "https://api.twitter.com/oauth/invalidate_token"
    }
    struct OAuth2 {
        static let getBearerToken = "https://api.twitter.com/oauth2/token"
        static let invalidateBearerToken = "https://api.twitter.com/oauth2/invalidate_token"
    }
    struct Tweets {
        static let update = "https://api.twitter.com/1.1/statuses/update.json"
    }
}

struct TwitterCallbackURLs {
    static let base = "TwEx://"
    static let welcome = base + "welcome"
}
