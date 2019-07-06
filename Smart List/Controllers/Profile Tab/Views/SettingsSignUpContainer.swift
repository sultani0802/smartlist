//
//  SettingsSignUpContainer.swift
//  Smart List
//
//  Created by Haamed Sultani on Jul/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class SettingsSignUpContainer: UIView {

    var signUpLabel : UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "Don't have an account?"
        lbl.font = UIFont(name: Constants.Visuals.fontName, size: 20)
        lbl.textColor = Constants.ColorPalette.TealBlue
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    
    var signUpButton : UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.sizeToFit()
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
        button.addTarget(self, action: #selector(ProfileViewController.signUpButtonTapped(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.tintColor = Constants.ColorPalette.BabyBlue
        button.titleLabel?.font = UIFont(name: Constants.Visuals.fontName, size: 18)
        
        return button
    }()
    
    var loginLabel : UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "Already have an account?"
        lbl.font = UIFont(name: Constants.Visuals.fontName, size: 20)
        lbl.textColor = Constants.ColorPalette.TealBlue
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    
    var loginButton : UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: .normal)
        button.sizeToFit()
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
        button.addTarget(self, action: #selector(ProfileViewController.loginButtonTapped(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.tintColor = Constants.ColorPalette.SeaGreen
        button.titleLabel?.font = UIFont(name: Constants.Visuals.fontName, size: 18)
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .red
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func setupViews() {
        addSubview(signUpLabel)
        addSubview(signUpButton)
        addSubview(loginLabel)
        addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            signUpLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            signUpLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            signUpButton.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 20),
            
            loginLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            loginLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 50),
            
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            loginButton.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20)
            ])
    }
}
