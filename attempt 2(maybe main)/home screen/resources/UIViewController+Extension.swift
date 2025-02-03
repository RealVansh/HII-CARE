//
//  UIViewController+Extension.swift
//  OnboardingScreens
//
//  Created by admin100 on 25/12/24.
//
import UIKit
extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier) as! Self
    }
}

