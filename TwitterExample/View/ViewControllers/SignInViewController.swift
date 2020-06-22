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

protocol NavigationDelegate: AnyObject {
    func willReturn()
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
        setupService()
        signInButton.setupStyle()
        setupStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustUIForState()
    }
    
    func setupService() {
        service = TwitterService()
    }
    
    // MARK: - UIControl Setup and Appearance
    
    func adjustUIForState() {
        if state == .signin {
            showSignIn()
        }
        else {
            showLoading()
        }
    }
    
    func showSignIn() {
        hideLoadingUI()
        showSignInUI()
    }
    
    func showLoading() {
        hideSignInUI { [weak self] in
            self?.showLoadingUI()
        }
    }
    
    // MARK: - UI Animations
    
    func showLoadingUI() {
        activitySpinner.startAnimating()
    }
    func hideLoadingUI() {
        activitySpinner.stopAnimating()
    }
    func showSignInUI() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { [weak self] in
            guard let self = self else { return }
            self.signInButtonBottomAlignConstraint.constant = self.signInButtonShownHeight
            self.view.layoutIfNeeded()
        })
    }
    func hideSignInUI(_ completion: @escaping ()->()) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration,
                       animations: { [weak self] in
            guard let self = self else { return }
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
            self?.goToSignedIn()
        }
        let failure: (Error?)->() = { [weak self] (error) in
            self?.showError(error)
        }
        service.requestToken(success: success,
                                  failure: failure)
        state = .loading
    }
    
    // MARK: - Navigation
    
    func goToSignedIn() {
        let vc = TweetViewController.initWithService(service)
        vc.navigationDelegate = self
        let deadline: DispatchTime = .now() + animationDuration
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    func showError(_ error: Error?) {
        let title = error?.localizedDescription ?? "An Error Occurred"
        let alert = UIAlertController(title: title,
                                      message: "",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK",
                               style: .default,
                               handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

extension SignInViewController: NavigationDelegate {
    func willReturn() {
        state = .signin
        adjustUIForState()
    }
}
