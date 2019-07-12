//
//  Login+Keyboard.swift
//  Smart List
//
//  Created by Haamed Sultani on Jul/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension LoginViewController : UITextFieldDelegate{
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
        if textField == midLoginContainer.emailField {
            textField.resignFirstResponder()
            midLoginContainer.passwordField.becomeFirstResponder()
        } else if textField == midLoginContainer.passwordField {
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        
        return true
    }
    
}
