//
//  LoginContainer.swift
//  Smart List
//
//  Created by Haamed Sultani on Jul/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class MidLoginContainer: UIView {
    
    var emailField : UITextField = {
        var view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.font = UIFont(name: Constants.Visuals.fontName, size: 14)
        view.textColor = Constants.ColorPalette.DarkGray
        view.returnKeyType = .next
        view.placeholder = "Your email"
        view.keyboardType = .emailAddress
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.borders(for: [.all], width: 0.2, color: .black)
        view.layer.cornerRadius = 4
        // Add some space between the text and the border
        view.setLeftPaddingPoints(5)
        view.setRightPaddingPoints(5)
        
        return view
    }()
    
    var passwordField : UITextField = {
        var view = UITextField()
        view.isSecureTextEntry = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.font = UIFont(name: Constants.Visuals.fontName, size: 14)
        view.textColor = Constants.ColorPalette.DarkGray
        view.returnKeyType = .go
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.placeholder = "Your password"
        view.borders(for: [.all], width: 0.2, color: .black)
        view.layer.cornerRadius = 4
        
        // Add some space between the text and the border
        view.setLeftPaddingPoints(5)
        view.setRightPaddingPoints(5)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Constants.ColorPalette.OffWhite

        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Adds UI Elements to the view and set their constraints
    func setupViews() {
        addSubview(emailField)
        addSubview(passwordField)
        
        NSLayoutConstraint.activate([
            emailField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            emailField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            emailField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            
            passwordField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            passwordField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)
            ])
    }
}
