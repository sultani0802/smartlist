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
    
    /// Adds a "Cancel" and "Done" button above the keyboard
    ///
    /// - Parameters:
    ///   - onDone: Takes a target and selector function for customized functionality. Otherwise, it uses the default.
    ///   - onCancel: Takes a target and selector function for customized functionality. Otherwise, it uses the defualt.
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        
        // If there is no custom functionality then it uses the default methods which just hide the keyboard
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        // Create the toolbar and its buttons
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    
    
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
