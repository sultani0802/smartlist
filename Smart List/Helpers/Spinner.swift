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
    /// A rounded gray box is displayed behind the spinner, centered in the view and half the size
    ///
    /// - Parameter spinner: A barebones spinner that will be passed into this method
    func showLargeSpinner(spinner : UIActivityIndicatorView, container: UIView) {
        container.frame = CGRect(x: self.frame.width/4, y: self.frame.height*0.25, width: self.frame.width/2, height: self.frame.width/2)
        container.center = self.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.3)
        container.layer.cornerRadius = 10
        
        spinner.frame = CGRect(x: 0,y: 0,width: 40.0,height: 40.0)          // Set dimensions
        spinner.center = self.center                                        // Put the center in the middle
        spinner.hidesWhenStopped = true                                     // Hides when there is nothing to load
        spinner.style = .whiteLarge                                         // Set the style
        spinner.center = CGPoint(x: container.frame.size.width / 2,
                                 y: container.frame.size.height / 2)
        
        container.addSubview(spinner)                                       // Add spinner to container view
        self.addSubview(container)                                          // Add container to UIView
        spinner.startAnimating()                                            // Animated
    }
    
    /// Takes a spinner that is passed to this method and configures it to be a regular sized spinner
    ///
    /// - Parameter spinner: A barebones spinner that will be passed into this method
    func showSmallSpinner(spinner : UIActivityIndicatorView) {
        let container : UIView = UIView()
        container.frame = self.frame
        container.center = self.center
        
        spinner.frame = CGRect(x: 0,y: 0,width: 40.0,height: 40.0)          // Set dimensions
        spinner.center = self.center                                        // Put the center in the middle
        spinner.hidesWhenStopped = true                                     // Hides when there is nothing to load
        spinner.style = .whiteLarge                                         // Set the style
        spinner.center = CGPoint(x: container.frame.size.width / 2,
                                 y: container.frame.size.height / 2)
        
        container.addSubview(spinner)                                       // Add spinner to container view
        self.addSubview(container)                                          // Add container to UIView
        spinner.startAnimating()                                            // Animated
    }
    
    func hideSpinner(spinner : UIActivityIndicatorView, container: UIView) {
        container.removeFromSuperview()
        spinner.stopAnimating()
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}


class Spinner {
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    /*
     Show customized activity indicator,
     actually add activity indicator to passing view
     
     @param uiView - add activity indicator to this view
     */
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
