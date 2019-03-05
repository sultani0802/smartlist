//
//  Detail+PickerDelegates.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// The number of different units
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workingUnits.count
    }
    
    /// Populate the pickerview with the different units of measurement
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = self.workingUnits[row]
        
        return title
    }
    
    /// Set the height of the pickerview rows
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}





extension DetailViewController: UITextFieldDelegate, UITextViewDelegate {
    
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
                if (!aRect.contains(activeText.frame.origin)){
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
    //Mark: - TextView Delegates
    //
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.activeText = textView
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.activeText = nil
        
        if textView == midContainer.noteTextView {
            print("save notes to DB")
        }
    }
    
    
    
    //
    //Mark: - TextField Delegates
    //
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeText = textField
        
        // When the user selects the quantity textfield it will clear the text if it's a 0
        if textField == quantityView.quantityTextField {
            
            if textField.text == "0" {
                textField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeText = nil
    }
    
    /// Everytime the user types in the numpad, this will check if it is a decimal
    /// If it is a decimal then it won't allow more than 1 decimal
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // This was added to force the centering of the textfield when the user begins editing the quantity in the pop up
        if textField == quantityView.quantityTextField {
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: quantityView.quantityTextField, attribute: .top, relatedBy: .equal, toItem: quantityView.titleStackView, attribute: .bottom, multiplier: 1.0, constant: 0),
                quantityView.quantityTextField.leadingAnchor.constraint(equalTo: quantityView.leadingAnchor),
                quantityView.quantityTextField.bottomAnchor.constraint(equalTo: quantityView.bottomAnchor),
                quantityView.quantityTextField.widthAnchor.constraint(equalTo: quantityView.widthAnchor, multiplier: 0.4)
                ])
        }
        
        guard let text = textField.text else { return true }
        let dotCount: Int = (textField.text?.components(separatedBy: ".").count)! - 1
        let newLength = text.count + string.count - range.length
        
        if dotCount > 0 && string == "."
        {
            return false
        } else if newLength > 7 {
            return false
        }
        
        return true
    }
    
    /// This method is called everytime the user hits the Enter key on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    /// This method is called everytime the user types or deletes in the quantity textfield
    @objc func textFieldDidChange(textField: UITextField) {
        self.updateUnitDataSource()
    }
}
