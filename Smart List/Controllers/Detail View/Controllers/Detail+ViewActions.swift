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
        print("Done button tapped. (Inside Detail View)")
        
        // Grab the quantity
        let enteredQuantity : String = self.quantityView.quantityTextField.text! + " " + self.units[self.quantityView.pickerView.selectedRow(inComponent: 0)]
        // Set and save the Item's quantity
        self.item!.quantity = enteredQuantity
        CoreDataManager.shared.saveContext()
        
        // Hide the keyboard
        quantityView.quantityTextField.resignFirstResponder()
        
        // Update the view with the new quantity
        self.midContainer.quantityButton.setTitle(self.item?.quantity, for: .normal)
        
        // Hide the pop up view
        self.quantityView.fadeOut()
    }
    
    
    /// Display the quantity pop up view with animation
    ///
    /// - Parameter sender: The button clicked to trigger this action
    @objc func quantityButtonTapped(_ sender: UIButton) {
        print("Quantity button tapped. (Inside Detail View)")
        self.quantityView.quantityTextField.resignFirstResponder() // Hide the keyboard
        self.quantityView.fadeIn()
    }
}
