//
//  TextFieldFocusingExtension.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit


extension UIViewController {
    
    /// When the user taps outside of the keyboard
    /// the keyboard will be dismissed
    ///
    /// This method is to be used in the viewDidLoad() method of a view controller
    /// EXAMPLE: self.hideKeyboardWhenTappedAround()
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
