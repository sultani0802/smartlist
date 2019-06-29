//
//  SignUpBottomContainer.swift
//  Smart List
//
//  Created by Haamed Sultani on Jun/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class SignUpBottomContainer : UIView {
    
    //MARK: - UI Elements
    
    //TEXTFIELDS
    var nameField : UITextField = {
        var view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.font = UIFont(name: Constants.Visuals.fontName, size: 14)
        view.textColor = Constants.ColorPalette.DarkGray
        view.placeholder = "Your name"
        view.borders(for: [.all], width: 0.22, color: .black)
        view.layer.cornerRadius = 4
        // Add some space between the text and the border
        view.setLeftPaddingPoints(5)
        view.setRightPaddingPoints(2)
        
        view.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
        
        return view
    }()
    
    var emailField : UITextField = {
        var view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.font = UIFont(name: Constants.Visuals.fontName, size: 14)
        view.textColor = Constants.ColorPalette.DarkGray
        view.placeholder = "Your email"
        view.borders(for: [.all], width: 0.2, color: .black)
        view.layer.cornerRadius = 4
        // Add some space between the text and the border
        view.setLeftPaddingPoints(5)
        view.setRightPaddingPoints(2)
        
        view.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
        
        return view
    }()
    
    var passwordField : UITextField = {
        var view = UITextField()
        view.isSecureTextEntry = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.font = UIFont(name: Constants.Visuals.fontName, size: 14)
        view.textColor = Constants.ColorPalette.DarkGray
        view.placeholder = "Your password"
        view.borders(for: [.all], width: 0.2, color: .black)
        view.layer.cornerRadius = 4
        // Add some space between the text and the border
        view.setLeftPaddingPoints(5)
        view.setRightPaddingPoints(2)
        
        view.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
        
        return view
    }()
    
    var fieldStack : UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.spacing = 20
        
        return stack
    }()
    
    //BUTTONS
    var signUpButton : UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.sizeToFit()
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
        button.addTarget(self, action: #selector(SignUpViewController.signUpButtonTapped(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.tintColor = Constants.ColorPalette.SeaGreen
        button.titleLabel?.font = UIFont(name: Constants.Visuals.fontName, size: 18)
        button.isEnabled = false
        
        return button
    }()
    
    var skipButton : UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Skip", for: .normal)
        button.sizeToFit()
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
        button.addTarget(self, action: #selector(SignUpViewController.skipButtonTapped(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.tintColor = .lightGray
        button.titleLabel?.font = UIFont(name: Constants.Visuals.fontName, size: 14)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        fieldStack.addArrangedSubview(nameField)
        fieldStack.addArrangedSubview(emailField)
        fieldStack.addArrangedSubview(passwordField)
        
        addSubview(fieldStack)
        addSubview(signUpButton)
        addSubview(skipButton)
        
        // Textfields StackView
        NSLayoutConstraint.activate([
            fieldStack.topAnchor.constraint(equalTo: topAnchor),
            fieldStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.70)
            ])
        
        // Textfields
        NSLayoutConstraint.activate([
            nameField.widthAnchor.constraint(equalTo: fieldStack.widthAnchor, multiplier: 0.7),
            emailField.widthAnchor.constraint(equalTo: fieldStack.widthAnchor, multiplier: 0.7),
            passwordField.widthAnchor.constraint(equalTo: fieldStack.widthAnchor, multiplier: 0.7)
            ])
        
        // Buttons
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: signUpButton, attribute: .top, relatedBy: .equal, toItem: passwordField, attribute: .bottom, multiplier: 1, constant: 10),
            signUpButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.10),
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            
            NSLayoutConstraint(item: skipButton, attribute: .top, relatedBy: .equal, toItem: signUpButton, attribute: .bottom, multiplier: 1, constant: 10),
            skipButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.10),
            skipButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            skipButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            ])
    }
}
