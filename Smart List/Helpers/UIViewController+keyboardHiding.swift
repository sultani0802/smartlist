//
//  TextFieldFocusingExtension.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit


extension UIViewController {

	/**
	When the user taps outside of the keyboard when it is visible, it will hide the keyboard.
	
	> Call this method on a UIViewController to enable this method.
	
	**Example Usage**
	```
	self.hideKeyboardWhenTappedAround()
	```
	*/
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
