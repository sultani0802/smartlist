//
//  SignUp+Keyboard.swift
//  Smart List
//
//  Created by Haamed Sultani on Jun/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension SignUpViewController: UITextFieldDelegate {
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification
        {
            let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)

            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets

            var aRect : CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            if let activeText = self.activeText {
                if (aRect.contains(activeText.frame.origin)){
                    self.scrollView.scrollRectToVisible(activeText.frame, animated: true)
                }
            }
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            //Once keyboard disappears, restore original positions
            var info = notification.userInfo!
            let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
            let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
            self.scrollView.contentInset = UIEdgeInsets.zero
            self.scrollView.scrollIndicatorInsets = contentInsets
            self.view.endEditing(true)
        }
    }
    
    
    //
    //Mark: - TextField Delegates
    //
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeText = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeText = nil
    }
    
    /// This method is called everytime the user hits the Enter key on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == bottomContainer.nameField {
            bottomContainer.nameField.resignFirstResponder()
            bottomContainer.emailField.becomeFirstResponder()
        } else if textField == bottomContainer.emailField {
            bottomContainer.emailField.resignFirstResponder()
            bottomContainer.passwordField.becomeFirstResponder()
        } else if textField == bottomContainer.passwordField {
            signUpButtonTapped()
        }
        
        return true
    }
    
    
    /// Called everytime the user types inside one of textField on the Sign Up View
    ///
    /// - Parameter textField: Reference to the textField that is being edited
    @objc func textFieldDidChange(_ textField: UITextField) {
        toggleSignUp()
        
        if (textField == bottomContainer.emailField) {                                      // If the user is typing in the email textField
            
//            if let email = bottomContainer.emailField.text {
//                toggleEmailImage(toggle: Regex.shared.validateEmail(candidate: email))          // User regex to validate their email
//            }
        } else if (textField == bottomContainer.passwordField) {                            // If the user is typing in the password textField
            togglePasswordImage(toggle: true)
        }
    }
}
