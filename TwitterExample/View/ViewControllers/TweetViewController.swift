//
//  TweetViewController.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

final class TweetViewController: UIViewController {
    
    var service: TwitterService!
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var tweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupStyle()
        self.tweetButton.setupStyle()
        self.textView.setupStyle()
    }
    @IBAction func tweetButtonAction(_ sender: Any) {
        guard let text = self.textView.text else { return }
        let success: ()->() = { [weak self] in
        }
        let failure: (Error)->() = { [weak self] (error) in
        }
        self.service.makeTweet(text,
                               success: success,
                               failure: failure)
    }
}

extension TweetViewController {
    class func initWithService(_ service: TwitterService) -> TweetViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TweetViewController") as! TweetViewController
        vc.service = service
        return vc
    }
}
