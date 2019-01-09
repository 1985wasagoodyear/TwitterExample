//
//  SignInViewController.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

enum SignInVCState {
    case loading
    case signin
}

final class SignInViewController: UIViewController {

    // MARK: - Storyboard Outlets
    
    @IBOutlet var activitySpinner: UIActivityIndicatorView!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signInButtonBottomAlignConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    let signInButtonHiddenHeight: CGFloat = -100.0
    let signInButtonShownHeight: CGFloat = 20.0
    let animationDuration: TimeInterval = 0.30
    
    var state: SignInVCState = .signin {
        didSet {
            self.adjustUIForState()
        }
    }
    
    var service: TwitterService!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupService()
        self.signInButton.setupStyle()
        self.setupStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.adjustUIForState()
    }
    
    func setupService() {
        self.service = TwitterService()
    }
    
    // MARK: - UIControl Setup and Appearance
    
    func adjustUIForState() {
        if self.state == .signin {
            self.showSignIn()
        }
        else {
            self.showLoading()
        }
    }
    
    func showSignIn() {
        self.hideLoadingUI()
        self.showSignInUI()
    }
    
    func showLoading() {
        self.hideSignInUI { [unowned self] in
            self.showLoadingUI()
        }
    }
    
    // MARK: - UI Animations
    
    func showLoadingUI() {
        self.activitySpinner.startAnimating()
    }
    func hideLoadingUI() {
        self.activitySpinner.stopAnimating()
    }
    func showSignInUI() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { [unowned self] in
            self.signInButtonBottomAlignConstraint.constant = self.signInButtonShownHeight
            self.view.layoutIfNeeded()
        })
    }
    func hideSignInUI(_ completion: @escaping ()->()) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration,
                       animations: { [unowned self] in
            self.signInButtonBottomAlignConstraint.constant = self.signInButtonHiddenHeight
            self.view.layoutIfNeeded()
        }) { (finished) in
            if finished == true {
                completion()
            }
        }
    }
    
    // MARK: - Sign In Actions

    @IBAction func signInAction(_ sender: Any) {
        let success: ()->() = { [weak self] in
            if self != nil {
                self!.goToSignedIn()
            }
        }
        let failure: (Error?)->() = { [weak self] (error) in
            if self != nil { self!.showError(error) }
        }
        self.service.requestToken(success: success,
                                  failure: failure)
        
        self.state = .loading
    }
    
    // MARK: - Navigation
    
    func goToSignedIn() {
        let vc = TweetViewController.initWithService(service)
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration)
        { [unowned self] in
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showError(_ error: Error?) {
        let alert = UIAlertController(title: error?.localizedDescription ?? "An Error Occurred",
                                      message: "",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK",
                               style: .default,
                               handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
}
