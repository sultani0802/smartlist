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
        self.layer.cornerRadius = 10
        self.backgroundColor = Constants.ColorPalette.BabyBlue.withAlphaComponent(0.95)
        
        // Apply Gaussian blur to view
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = layer.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(blurEffectView)
        
    }
    
    // Method to be overidden by the inheriting view
    func setupUIComponents() { }
}
