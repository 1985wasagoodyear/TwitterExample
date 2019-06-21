//
//  SignInViewController.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit
import LocalAuthentication

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
    
    // MARK: - LAContext Properties
    
    let context = LAContext()
    let policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
    
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
        // do additional setup here, if necessary
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
        hideSignInUI { [unowned self] in
            self.showLoadingUI()
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
                       animations: { [unowned self] in
            self.signInButtonBottomAlignConstraint.constant = self.signInButtonShownHeight
            self.view.layoutIfNeeded()
        })
    }
    func hideSignInUI(_ completion: @escaping ()->()) {
        view.layoutIfNeeded()
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
            guard let sSelf = self else { return }
            let hasBiometrics = sSelf.context.canEvaluatePolicy(sSelf.policy,
                                                                error: nil)
            if hasBiometrics {
                sSelf.biometricsPrompt()
            }
            else {
                sSelf.goToSignedIn()
            }
        }
        let failure: (Error?)->() = { [weak self] (error) in
            self?.showError(error)
        }
        service.requestToken(success: success,
                                  failure: failure)
        state = .loading
    }
    
    func biometricsPrompt() {
        let success: ()->() = { [weak self] in
            self?.goToSignedIn()
        }
        let failure: (Error?)->() = { [weak self] (error) in
            self?.showError(error)
        }
        
        var biometricType: String!
        
        if #available(iOS 11.0, *) {
            biometricType = (context.biometryType == .touchID) ? "Touch" : "Face"
        } else {
            biometricType = "Touch"
        }
        let localReason = "Please sign in with \(biometricType!) ID"
        
        context.evaluatePolicy(policy,
                               localizedReason: localReason)
        { (biometricsSuccessful, error) in
            if biometricsSuccessful == true {
                success()
            }
            else {
                failure(error)
            }
        }
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
        state = .signin
    }
    
}

