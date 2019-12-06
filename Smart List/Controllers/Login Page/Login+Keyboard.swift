//
//  Login+Keyboard.swift
//  Smart List
//
//  Created by Haamed Sultani on Jul/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension LoginViewController : UITextFieldDelegate{
	
	
	/// Adjusts the view's frame and insets when a textfield is being edited in order to scroll the textfield into view (and not behind the keyboard)
	/// - Parameter notification: The notification sent by the keyboard
	@objc func keyboardWillChange(notification: Notification) {
		
		// Get the size of the keyboard on the screen
		guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
			return
		}
		
		if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification
		{
			// Get the Edge Insets of the keyboard
			let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
			
			// Set the scrollview insets to the keyboard
			self.scrollView.contentInset = contentInsets
			self.scrollView.scrollIndicatorInsets = contentInsets
			
			// Get the view's frame and decrease its height by the keyboard height
			var aRect : CGRect = self.view.frame
			aRect.size.height -= keyboardSize.height
			
			// Get reference to the textfield that is being edited
			if let activeText = self.activeText {
				// If the modified view contains the textfield
				if (aRect.contains(activeText.frame.origin)){
					DispatchQueue.main.async {
						// Scroll the textfield into view
						self.scrollView.scrollRectToVisible(activeText.frame, animated: true)
					}
				}
			}
		} else if notification.name == UIResponder.keyboardWillHideNotification {
			//Once keyboard disappears, restore original positions
			let info = notification.userInfo!
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
		// Keep track of which textfield is being edited
		self.activeText = textField
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		// User stopped typing in a textfield, stop tracking which keyboard they're editing
		self.activeText = nil
	}
	
	/// This method is called everytime the user hits the Enter key on the keyboard
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == midLoginContainer.emailField {
			// Switch focus to password textfield when editing email
			textField.resignFirstResponder()
			midLoginContainer.passwordField.becomeFirstResponder()
		} else if textField == midLoginContainer.passwordField {
			// Hide keyboard and attempt to login user
			textField.resignFirstResponder()
			loginButtonTapped()
		}
		
		return true
	}
}
