//
//  UITextfieldExtension.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension UITextField {
    
    
    /****************************************/
    /****************************************/
    //MARK: - Toolbar
    /****************************************/
    /****************************************/

    
    /// Adds a "Done" button above the keyboard
    ///
    /// - Parameter onDone: Takes a target and selector function for customized functionality. Otherwise, it performs the default.
    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil) {
        // If no custom functionality is provided then perform the default
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        // Create the toolbar
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        // Finally add the toolbar above the keyboard
        self.inputAccessoryView = toolbar
    }
    
    // Default actions: Hides the keyboard
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
    
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - Padding
    /****************************************/
    /****************************************/
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}



extension UITextView {
    /// Adds a "Done" button above the keyboard
    ///
    /// - Parameter onDone: Takes a target and selector function for customized functionality. Otherwise, it performs the default.
    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil) {
        // If no custom functionality is provided then perform the default
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        // Create the toolbar
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        // Finally add the toolbar above the keyboard
        self.inputAccessoryView = toolbar
    }
    
    
    
    // Default actions: Hides the keyboard
    @objc func doneButtonTapped() { self.resignFirstResponder() }
}
