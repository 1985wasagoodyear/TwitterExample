//
//  TwitterService.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

final class TwitterService {
    
    static func requestBearerToken() {

        var urlRequest = URLRequest(url: TwitterURLs.requestTokenURL.url()!)
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
    
    static func requestToken() {
        let urlRequest = URLRequest(url:
            TwitterURLs.requestTokenURL.url()!)
        URLSession.shared.dataTask(with: urlRequest)
        { (data, response, error) in
            guard let safeData = data else { return }
            
            let json = try! JSONSerialization.jsonObject(with: safeData, options: .mutableLeaves) as! [String:Any]
            print(json)
        }.resume()
    }
    
}
