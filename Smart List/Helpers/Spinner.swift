//
//  Spinner.swift
//  Smart List
//
//  Created by Haamed Sultani on Jul/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit


extension UIView {
    
    
    /// Takes a spinner that is passed to this method and configures it to be a large spinner
    /// > A rounded gray box is displayed behind the spinner, centered in the view, and half the size
    ///
    /// - Parameter spinner: A barebones spinner that will be passed into this method
    func showLargeSpinner(spinner : UIActivityIndicatorView, container: UIView) {
        // Configure the container view
		container.frame = CGRect(x: self.frame.width/4, y: self.frame.height*0.25, width: self.frame.width/2, height: self.frame.width/2)
        container.center = self.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.3)
        container.layer.cornerRadius = 10
        
		// Configure activity indicator
        spinner.frame = CGRect(x: 0,y: 0,width: 40.0,height: 40.0)          // Set dimensions
        spinner.center = self.center                                        // Put the center in the middle
        spinner.hidesWhenStopped = true                                     // Hides when there is nothing to load
		spinner.style = .large
        spinner.center = CGPoint(x: container.frame.size.width / 2,
                                 y: container.frame.size.height / 2)
        
		// Add subviews and start spinning the activity indicator
        container.addSubview(spinner)                                       // Add spinner to container view
        self.addSubview(container)                                          // Add container to UIView
        spinner.startAnimating()                                            // Start spinning
    }
    
    /// Takes a spinner that is passed to this method and configures it to be a regular sized spinner
    ///
    /// - Parameter spinner: A barebones spinner that will be passed into this method
    func showSmallSpinner(spinner : UIActivityIndicatorView) {
        // Initialize a container view
		let container : UIView = UIView()
        container.frame = self.frame
        container.center = self.center
        
		// Configure the activity indicator
        spinner.frame = CGRect(x: 0,y: 0,width: 40.0,height: 40.0)          // Set dimensions
        spinner.center = self.center                                        // Put the center in the middle
        spinner.hidesWhenStopped = true                                     // Hides when there is nothing to load
		spinner.style = .large
        spinner.center = CGPoint(x: container.frame.size.width / 2,
                                 y: container.frame.size.height / 2)
        
		// Add the subviews
        container.addSubview(spinner)                                       // Add spinner to container view
        self.addSubview(container)                                          // Add container to UIView
        spinner.startAnimating()                                            // Start spinning
    }
    
	
	/// Removes container view and stops the activity indicator from spinning
	/// - Parameters:
	///   - spinner: The activity indicator that should stop spinning
	///   - container: The container that the activity indicator is in
    func hideSpinner(spinner : UIActivityIndicatorView, container: UIView) {
        container.removeFromSuperview()
        spinner.stopAnimating()
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
