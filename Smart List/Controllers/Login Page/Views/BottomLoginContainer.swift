//
//  TopLoginContainer.swift
//  Smart List
//
//  Created by Haamed Sultani on Jul/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class BottomLoginContainer: UIView{
    
    //BUTTONS
    var loginButton : UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.sizeToFit()
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
        button.addTarget(self, action: #selector(LoginViewController.loginButtonTapped(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
		button.tintColor = Constants.Visuals.ColorPalette.SeaGreen
        button.titleLabel?.font = UIFont(name: Constants.Visuals.fontName, size: 18)
        
        return button
    }()
    
    var signUpLabel : UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Don't have an account?"
        lbl.sizeToFit()
        lbl.textAlignment = .right
        lbl.font = UIFont(name: Constants.Visuals.fontName, size: 12)
        
        return lbl
    }()
    
    var signUpButton : UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.sizeToFit()
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
        button.addTarget(self, action: #selector(LoginViewController.signUpButtonTapped(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
		button.tintColor = Constants.Visuals.ColorPalette.BabyBlue
        button.titleLabel?.font = UIFont(name: Constants.Visuals.fontName, size: 18)
        
        return button
    }()
    
    var signUpStack : UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = UIStackView.Distribution.fillProportionally
        
        return view
    }()
    
    var skipButton : UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Skip", for: .normal)
        button.sizeToFit()
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
        button.addTarget(self, action: #selector(LoginViewController.skipButtonTapped(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.tintColor = .lightGray
        button.titleLabel?.font = UIFont(name: Constants.Visuals.fontName, size: 14)
        
        return button
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
    func setupViews() {
        addSubview(loginButton)
        addSubview(signUpStack)
        signUpStack.addArrangedSubview(signUpLabel)
        signUpStack.addArrangedSubview(signUpButton)
        addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
			
            signUpStack.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: 8),
            signUpStack.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25),
            
            
            skipButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            skipButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 25)
            ])
    }
}
