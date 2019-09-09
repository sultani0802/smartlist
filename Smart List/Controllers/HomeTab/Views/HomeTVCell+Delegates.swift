//
//  HomeCell+Delegate.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension HomeTableViewCell: UITextFieldDelegate {
    /// This delegate method is called when the user taps on the cell
    /// it displays the cell's accessory button
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.accessoryType = .detailDisclosureButton            // Set the accessory button
    }
    
    /// This delegate method is called when the user is done editing the
    /// item's name. This can be triggered by hitting 'Enter' or tapping
    /// outside of the cell
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.accessoryType = self.completed ? .checkmark : .none    // If the Item has been added to the cart, show the checkmark accessory, otherwise hide the accessory button
        
        // Call the delegate to save changes made to the cell
        textDelegate?.didEndEditing(onCell: self)
    }
    
    /// This delegate method is called when the user hits 'Enter'
    /// when editing an Item's name in the tableView
    /// It will hide the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameText.resignFirstResponder()             // Hide the keyboard
        
        return true
    }
    
    /// Limits the number of characters the user can type (24)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        
        return newLength <= 25
    }
}
