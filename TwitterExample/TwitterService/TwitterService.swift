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
    private var oauthToken: String!
    
    // MARK: - Authentication and SignIn
    
    func requestToken(success: @escaping ()->()?,
                      failure: @escaping (Error)->()?) {
        // create an instance and retain it
        
        oauthswift = OAuth1Swift(
            consumerKey:    TwitterKeys.apiKey,
            consumerSecret: TwitterKeys.apiSecret,
            requestTokenUrl: TwitterURLs.OAuth1.requestToken,
            authorizeUrl:    TwitterURLs.OAuth1.authorize,
            accessTokenUrl:  TwitterURLs.OAuth1.accessToken
        )
        // authorize
        _ = oauthswift.authorize(
            withCallbackURL: TwitterCallbackURLs.welcome.url()!,
            success: { [weak self] credential, response, parameters in
                print(credential.oauthToken)
                print(credential.oauthTokenSecret)
                print(parameters["user_id"] ?? "")
                self?.oauthToken = credential.oauthToken
                KeychainService.update(name: "oauthToken",
                                       password: credential.oauthToken)
                // handle your stuff here
                success()
        }, failure: { error in
            print(error.localizedDescription)
            failure(error)
        })
    }
    
    static func handle(url: URL) {
        OAuthSwift.handle(url: url)
    }
    
    // MARK: - Saved Credentials
    
    func savedTokenExists() -> Bool {
        if let oauthToken = KeychainService.get(name: "oauthToken") {
            self.oauthToken = oauthToken
            
            return true
        }
        return false
    }
    
    // MARK: - Update
    
    func makeTweet(_ tweet: TweetUpdate,
                   success: @escaping ()->()?,
                   failure: @escaping (Error)->()?) {
        /*
        var urlRequest = URLRequest(url:
            TwitterURLs.Tweets.update.url()!)
        
        // populate the request's data
        urlRequest.httpMethod = "POST"
        */
        
        let httpData = try! JSONEncoder().encode(tweet)
        
        let plainString = (TwitterURLs.Tweets.update + "?status=" + tweet.status)
        
        guard let urlString = plainString.urlEncoded() else {
            //failure()
            return
        }
        let _ = oauthswift.client.post(urlString,
                                       success:
            { (response) in
                print(response.data)
        }) { (error) in
          //  if let errorString = (error as NSError).userInfo as? OAuthSwiftError {
           //    print(errorString["error"])
          //  }
        }
        
        /*
        oauthswift.client.post(<#T##urlString: String##String#>, success: <#T##OAuthSwiftHTTPRequest.SuccessHandler?##OAuthSwiftHTTPRequest.SuccessHandler?##(OAuthSwiftResponse) -> Void#>, failure: <#T##OAuthSwiftHTTPRequest.Obj_FailureHandler?##OAuthSwiftHTTPRequest.Obj_FailureHandler?##(Error) -> Void#>)
        */
        
        /*
        URLSession.shared.dataTask(with: urlRequest)
        { (data, response, error) in
            guard let safeData = data else { return }
            
            let json = try! JSONSerialization.jsonObject(with: safeData, options: .mutableLeaves) as! [String:Any]
            print(json)
            }.resume()
        */
        
    }
    
    // MARK: - Attempt at Native Solution
    
    private static func old_requestBearerToken() {

        var urlRequest = URLRequest(url: TwitterURLs.OAuth2.getBearerToken.url()!)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue(TwitterKeys.basicAuthentication(),
                            forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/x-www-form-urlencoded;charset=UTF-8",
                            forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("iOS-TwitterExample", forHTTPHeaderField: "User-Agent")
        let bodyDict = ["grant_type" : "client_credentials"]
        let bodyData = try! JSONSerialization.data(withJSONObject: bodyDict,
                                                   options: .prettyPrinted)
        urlRequest.httpBody = bodyData
        
        URLSession.shared.dataTask(with: urlRequest)
        { (data, response, error) in
            guard let safeData = data else { return }
            
            let json = try! JSONSerialization.jsonObject(with: safeData, options: .mutableLeaves) as! [String:Any]
            print(json)
            }.resume()
    }
    
    private static func old_requestToken() {
        let urlRequest = URLRequest(url:
            TwitterURLs.OAuth1.requestToken.url()!)
        URLSession.shared.dataTask(with: urlRequest)
        { (data, response, error) in
            guard let safeData = data else { return }
            
            let json = try! JSONSerialization.jsonObject(with: safeData, options: .mutableLeaves) as! [String:Any]
            print(json)
        }.resume()
    }
    
}
