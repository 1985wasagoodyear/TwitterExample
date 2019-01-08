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
        self.textView.text = "I am not afraid about sleeping with the lights off"
    }
    @IBAction func tweetButtonAction(_ sender: Any) {
        guard let text = self.textView.text else { return }
        let success: ()->() = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(text: "Tweet Successful!")
            }
        }
        let failure: (Error)->() = { [weak self] (error) in
            DispatchQueue.main.async {
                self?.showAlert(text: "Tweet Failed!")
            }
        }
        guard let tweet = TweetUpdate(status: text) else {
            return
        }
        self.service.makeTweet(tweet,
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
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
