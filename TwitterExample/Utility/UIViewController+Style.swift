//
//  UIViewController+Style.swift
//  TwitterExample
//
//  Created by Kevin Yu on 1/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

extension UIColor {
    class func red(_ red: Int, green: Int, blue: Int) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0,
                       green: CGFloat(green)/255.0,
                       blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    class func themeColor() -> UIColor {
        return UIColor(red: 137.0/255.0,
                       green: 207.0/255.0,
                       blue: 240.0/255.0, alpha: 1.0)
        
    }
}

extension UIViewController {
    func setupStyle() {
        self.view.backgroundColor = UIColor.themeColor()
    }
}

extension UIButton {
    func setupStyle() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.setTitleColor(UIColor.themeColor(), for: .normal)
        self.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 25.0)
    }
}

extension UITextView {
    func setupStyle() {
        self.backgroundColor = UIColor.clear
        self.font = UIFont(name: "MarkerFelt-Wide", size: 25.0)
    }
}
