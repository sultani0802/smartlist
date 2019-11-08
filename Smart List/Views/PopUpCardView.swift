//
//  PopUpCardView.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//
//
//  This class is to be subclassed to create popup views

import UIKit

class PopUpCardView: UIView {
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupUIComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK - Setup Methods
    func setupView() {
        // Rounded borders around the pop up
        self.layer.cornerRadius = 10
		self.backgroundColor = Constants.Visuals.ColorPalette.DarkGray.withAlphaComponent(0.95)
    }
    
    // Method to be overidden by the inheriting view
    func setupUIComponents() { }
}
