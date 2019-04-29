//
//  TwitterService.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation
import OAuthSwift

final class TwitterService {
    
    private var oauthswift: OAuth1Swift!
    
    init() {
        // create an instance and retain it
        oauthswift = OAuth1Swift(
            consumerKey:    TwitterKeys.apiKey,
            consumerSecret: TwitterKeys.apiSecret,
            requestTokenUrl: TwitterURLs.OAuth1.requestToken,
            authorizeUrl:    TwitterURLs.OAuth1.authorize,
            accessTokenUrl:  TwitterURLs.OAuth1.accessToken
        )
    }
    
    // MARK: - Authentication and SignIn
    
    func requestToken(success: @escaping ()->()?,
                      failure: @escaping (Error?)->()?) {
        // if credentials exist, immediately continue with these
        if self.savedTokenExists() == true {
            success()
            return
        }
        
        // authorize, otherwise
        _ = oauthswift.authorize(
            withCallbackURL: TwitterCallbackURLs.welcome.url()!,
            success: { credential, response, parameters in
                KeychainService.update(name: KeychainKeys.oauthToken,
                                       password: credential.oauthToken)
                KeychainService.update(name: KeychainKeys.oauthSecret,
                                       password: credential.oauthTokenSecret)
                success()
        }, failure: { error in
           // print(error.localizedDescription)
            failure(error)
        })
            
    }
    
    // handle the callback from webview
    static func handle(url: URL) {
        OAuthSwift.handle(url: url)
    }
    
    // MARK: - Saved Credentials
    
    private func savedTokenExists() -> Bool {
        guard let oauthToken = KeychainService.get(name: KeychainKeys.oauthToken) else {
            return false
        }
        guard let oauthSecret = KeychainService.get(name: KeychainKeys.oauthSecret) else {
            return false
        }
        
        oauthswift.client.credential.oauthToken = oauthToken
        oauthswift.client.credential.oauthTokenSecret = oauthSecret
        return true
    }
    
    // MARK: - Update
    
    func makeTweet(_ tweet: TweetUpdate,
                   success: @escaping ()->()?,
                   failure: @escaping (Error?)->()?) {
        
        guard let urlString = tweet.statusURLString else {
            failure(nil)
            return
        }
        
        let success: OAuthSwiftHTTPRequest.SuccessHandler =
        { (response) in
            success()
        }
        
        let failure: OAuthSwiftHTTPRequest.FailureHandler =
        { (error) in
            print(error)
            failure(error)
        }
        
        // perform the request
        let _ = oauthswift.client.post(urlString,
                                       success: success,
                                       failure: failure)
    }
}
/*
extension TwitterService {
    func createSavedCredential(_ credential: OAuthSwiftCredential) -> OAuthSwiftCredential {
        let cred = OAuthSwiftCredential(consumerKey: TwitterKeys.apiKey,
                                        consumerSecret: TwitterKeys.apiSecret)
        cred.oauthToken = credential.oauthToken
        cred.oauthRefreshToken = credential.oauthRefreshToken
        cred.oauthTokenSecret = credential.oauthTokenSecret
        cred.oauthTokenExpiresAt = credential.oauthTokenExpiresAt
        cred.version = credential.version
        cred.signatureMethod = credential.signatureMethod
        cred.headersFactory = credential.headersFactory
        return cred
    }
}
*/
