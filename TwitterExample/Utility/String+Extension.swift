//
//  String+Extension.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/9/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

extension String {
    func url() -> URL? {
        return URL(string: self)
    }
    
    func encodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: unreserved)
        return self.addingPercentEncoding(withAllowedCharacters: allowed)
    }
}
