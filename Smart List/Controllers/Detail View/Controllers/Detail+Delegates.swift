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
        return units.count
    }
    
    /// Populate the pickerview with the different units of measurement
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = self.units[row]
        
        return title
    }
    
    /// Set the height of the pickerview rows
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}

extension DetailViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // When the user selects the quantity textfield it will clear the text if it's a 0
        if textField == quantityView.quantityTextField {
            if textField.text == "0" {
                textField.text = ""
            }
        }
    }
    
    /// Everytime the user types in the numpad, this will check if it is a decimal
    /// If it is a decimal then it won't allow more than 1 decimal
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
