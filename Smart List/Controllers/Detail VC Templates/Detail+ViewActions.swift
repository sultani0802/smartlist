//
//  DetailViewActions.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension DetailVC {
    
    /// Hide the quantity pop up view with animation
    ///
    /// - Parameter sender: the button clicked to trigger this action
    @objc func doneButtonTapped(_ sender: UIButton) {
        // To be implemented by subclasses
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
