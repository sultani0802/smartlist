//
//  UIButton+Extensions.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//
// Special thanks to winterized for this code
// https://stackoverflow.com/questions/26600980/how-do-i-set-uibutton-background-color-forstate-uicontrolstate-highlighted-in-s/30604658#30604658


import UIKit

extension UIButton {
    
    
    /// Sets the background color
    ///
    /// - Parameters:
    ///   - color: The color you want the button to be
    ///   - forState: The state (UIButton.State.*)
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {

        self.clipsToBounds = true                                               // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))                // Start making the graphic
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)                                 // Set the color
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))               // Fill the graphic with a CGRect
            
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()                                         // End making the graphic
            
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
