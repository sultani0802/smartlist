//
//  DetailViewActions.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension DetailViewController {
    
    /// Hide the quantity pop up view with animation
    ///
    /// - Parameter sender: the button clicked to trigger this action
    @objc func doneButtonTapped(_ sender: UIButton) {
        if sender == expiryDateView.saveButton {
            
            self.item!.expiryDate = expiryDateView.datePicker.date          // Set the expiration date of the Item
            
            CoreDataManager.shared.saveContext()                            // Save to core data
            
                                                                            // Update the expiry UIButton's title with the new date
            self.midContainer.expiryDate.setTitle(DateHelper.shared.getDateString(of: (self.item?.expiryDate)!), for: .normal)
            
                                                                            // Hide the pop up view
            self.expiryDateView.fadeOut()
            
            
        } else if sender == quantityView.saveButton {
            // Grab the quantity string
            let enteredQuantity : String = self.quantityView.quantityTextField.text! + " " + self.originalUnits[self.quantityView.pickerView.selectedRow(inComponent: 0)]
            // Set and save the Item's quantity
            self.item!.quantity = enteredQuantity
            CoreDataManager.shared.saveContext()
            
            // Hide the keyboard
            quantityView.quantityTextField.resignFirstResponder()
            
            // Update the view with the new quantity
            self.midContainer.quantityButton.setTitle(self.item?.quantity, for: .normal)
            
            // Hide the pop up view
            self.quantityView.fadeOut()
            
            // Change the unit of measurement to the short-hand version
            self.midContainer.quantityButton.setTitle(UnitHelper.shared.abbreviateUnit(u: ((self.item?.quantity)!)), for: .normal)
            
        }
        
    }
    
    
    /// Display the quantity pop up view with animation
    ///
    /// - Parameter sender: The button clicked to trigger this action
    @objc func quantityButtonTapped(_ sender: UIButton) {
        
        self.quantityView.quantityTextField.resignFirstResponder()      // Hide the keyboard
        self.quantityView.fadeIn()
    }
    
    
    /// Display the expiry pop up view with a fading in animation
    ///
    /// - Parameter sender: The button the user tapped to trigger this action
    @objc func expiryButtonTapped(_ sender: UIButton) {
        self.expiryDateView.fadeIn()            // Fade in the pop up view
    }
}
