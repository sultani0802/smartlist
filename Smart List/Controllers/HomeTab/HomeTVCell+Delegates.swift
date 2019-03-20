//
//  HomeCell+Delegate.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension HomeTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.accessoryType = .detailDisclosureButton
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.accessoryType = self.completed ? .checkmark : .none
        
        // Call the delegate to save changes made to the name
        textDelegate?.didEndEditing(onCell: self)
    }
    
    // This delegate method is called when the user hits 'Enter' when they're done typing in the item
    // Once they are done adding an item to the list it creates a new empty cell below it
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameText.resignFirstResponder()             // Hide the keyboard
//        addNewCell?(nameText.text!)               // Call the callback
        
        return true
    }
    
    /// Limits the number of characters the user can type (24)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        
        return newLength <= 25
    }
}
