//
//  File.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//
//

import UIKit

extension UIView {
	
	
	/**
	Fades in a UIView using an animation
	
	- Parameters:
	- duration: How long the fading animation takes. Default is 0.2 seconds
	- onCompletion: Completion handler called when animation was successful
	
	> **Example Usage**
	```
	UIVIew.fadeIn()
	```
	or
	```
	UIView.fadeIn(0.5)
	```
	*/
	func fadeIn(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
		self.alpha = 0
		self.isHidden = false
		
		UIView.animate(withDuration: duration, animations: { self.alpha = 1 }, completion: { (value: Bool) in
			if let onCompletion = onCompletion { onCompletion() }
		})
	}
	
	
	/**
	Fades in a UIView using an animation
	
	- Parameters:
	- duration: How long the fading animation takes. Default is 0.2 seconds
	- onCompletion: Completion handler called when animation was successful
	
	> **Example Usage**
	```
	UIVIew.fadeOut()
	```
	or
	```
	UIView.fadeOut(1.0)
	```
	*/
	func fadeOut(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
		
		UIView.animate(withDuration: duration, animations: { self.alpha = 0 }, completion: { (value: Bool) in
			self.isHidden = true
			if let onCompletion = onCompletion { onCompletion() }
		})
	}
	
}
