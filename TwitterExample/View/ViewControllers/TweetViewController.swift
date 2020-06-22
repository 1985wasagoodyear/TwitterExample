//
//  TweetViewController.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

final class TweetViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var tweetButton: UIButton!
    
    lazy var signOutTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(signOutAction))
        gesture.numberOfTapsRequired = 2
        view.isUserInteractionEnabled = true
        return gesture
    }()
    
    var service: TwitterService!
    weak var navigationDelegate: NavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        tweetButton.setupStyle()
        textView.setupStyle()
        textView.text = "I am Spider-man!"
        view.addGestureRecognizer(signOutTapGesture)
    }
    
    @IBAction func tweetButtonAction(_ sender: Any) {
        guard let text = textView.text else { return }
        let success: ()->() = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(text: "Tweet Successful!")
            }
        }
        let failure: (Error?)->() = { [weak self] (error) in
            DispatchQueue.main.async {
                self?.showAlert(text: "Tweet Failed!")
            }
        }
        guard let tweet = TweetUpdate(status: text) else {
            return
        }
        service.makeTweet(tweet,
                          success: success,
                          failure: failure)
    }

    @objc func signOutAction() {
        service.signOut {
            self.navigationDelegate?.willReturn()
            self.dismiss(animated: true)
        }
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
        present(alert, animated: true, completion: nil)
    }
}
