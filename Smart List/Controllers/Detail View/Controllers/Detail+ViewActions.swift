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
        
        self.quantityView.fadeOut()
    }
    
    
    /// Display the quantity pop up view with animation
    ///
    /// - Parameter sender: The button clicked to trigger this action
    @objc func quantityButtonTapped(_ sender: UIButton) {
        print("Quantity button tapped. (Inside Detail View)")
        
        self.quantityView.fadeIn()
    }
}
