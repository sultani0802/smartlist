//
//  HomeGetStartedView.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class HomeGetStartedView: UIView {
    
    //MARK: -
    var instructionText: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false // Conform to auto-layout
        textView.text = "Tap the + button up above to get started!" // The instructions being displayed to the user
        textView.font = .systemFont(ofSize: 32) // Set the font size
        textView.textColor = Constants.ColorPalette.TealBlue // Set the font color
        textView.backgroundColor = UIColor(white: 1, alpha: 0)
        textView.textAlignment = .center
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        
        return textView
    }()
    
    //MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Initializers
    private func setupViews() {
        // Rounded borders for the view
        self.layer.cornerRadius = 30
        self.backgroundColor = .red
        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(instructionText)
        
        NSLayoutConstraint.activate([
            instructionText.widthAnchor.constraint(equalTo: self.widthAnchor),
//            instructionText.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 0.7),
//            instructionText.heightAnchor.constraint(equalTo: self.heightAnchor),
            instructionText.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            instructionText.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
}
