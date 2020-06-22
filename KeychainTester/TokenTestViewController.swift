//
//  TokenTestViewController.swift
//  Created 4/20/20
//  Using Swift 5.0
// 
//  Copyright © 2020 Kevin Yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit
import SharedKeychain

extension UIView {
    func fillIn(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        let constraints = [
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

class TokenTestViewController: UIViewController {
    
    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        if #available(iOS 11.0, *) {
            label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        } else {
            label.font = UIFont.systemFont(ofSize: 30.0)
        }
        label.minimumScaleFactor = 0.1
        label.adjustsFontSizeToFitWidth = true
        label.fillIn(self.view)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        setLabelText()
    }
    
    @objc func didBecomeActive() {
        setLabelText()
    }
    
    func setLabelText() {
        label.text = KeychainService.get(name: KeychainKeys.oauthToken) ?? "No Token Found"
    }

}

