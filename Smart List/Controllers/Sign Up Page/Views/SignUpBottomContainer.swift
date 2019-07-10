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
        view.autocorrectionType = .no
        view.autocapitalizationType = .words
        view.borders(for: [.all], width: 0.22, color: .black)
        view.layer.cornerRadius = 4
        // Add some space between the text and the border
        view.setLeftPaddingPoints(5)
        view.setRightPaddingPoints(20)
        
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
        view.keyboardType = .emailAddress
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.borders(for: [.all], width: 0.2, color: .black)
        view.layer.cornerRadius = 4
        // Add some space between the text and the border
        view.setLeftPaddingPoints(5)
        view.setRightPaddingPoints(20)
        
        view.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
        
        return view
    }()
    
    
    /// Image being used to display whether the email format is valid or not
    var emailImage : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    
    
    var passwordField : UITextField = {
        var view = UITextField()
        view.isSecureTextEntry = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.font = UIFont(name: Constants.Visuals.fontName, size: 14)
        view.textColor = Constants.ColorPalette.DarkGray
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.placeholder = "Your password"
        view.borders(for: [.all], width: 0.2, color: .black)
        view.layer.cornerRadius = 4
        
        // Add some space between the text and the border
        view.setLeftPaddingPoints(5)
        view.setRightPaddingPoints(20)
        
        // Adding password rules
        if #available(iOS 12.0, *) {
            view.passwordRules = UITextInputPasswordRules(descriptor: "minlength: 6;")
        } else {
            // Fallback on earlier versions
        }
        
        view.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
        
        return view
    }()
    
    
    /// Image being used to display whether the password meets the minimum requirements or not
    var passwordImage : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        return imageView
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
    
    var loginButton : UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.sizeToFit()
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
        button.addTarget(self, action: #selector(SignUpViewController.loginButtonTapped(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.tintColor = Constants.ColorPalette.SeaGreen
        button.titleLabel?.font = UIFont(name: Constants.Visuals.fontName, size: 18)
        
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
        addSubview(loginButton)
        addSubview(skipButton)
        
        // Textfields StackView
        NSLayoutConstraint.activate([
            fieldStack.topAnchor.constraint(equalTo: topAnchor),
            fieldStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.60)
            ])
        
        // Textfields
        NSLayoutConstraint.activate([
            nameField.widthAnchor.constraint(equalTo: fieldStack.widthAnchor, multiplier: 0.7),
            emailField.widthAnchor.constraint(equalTo: fieldStack.widthAnchor, multiplier: 0.7),
            passwordField.widthAnchor.constraint(equalTo: fieldStack.widthAnchor, multiplier: 0.7)
            ])
        
        // Buttons
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            signUpButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.10),
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            
            loginButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 10),
            loginButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.10),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            
            skipButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            skipButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.10),
            skipButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            skipButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            ])
        
        
        // Adding checkmark/invalid images
        emailField.addSubview(emailImage)
        passwordField.addSubview(passwordImage)
        
        NSLayoutConstraint.activate([
            emailImage.rightAnchor.constraint(equalTo: emailField.rightAnchor, constant: -8),
            emailImage.centerYAnchor.constraint(equalTo: emailField.centerYAnchor),
            emailImage.widthAnchor.constraint(equalToConstant: 18),
            emailImage.heightAnchor.constraint(equalToConstant: 18),
            
            passwordImage.rightAnchor.constraint(equalTo: passwordField.rightAnchor, constant: -8),
            passwordImage.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
            passwordImage.widthAnchor.constraint(equalToConstant: 18),
            passwordImage.heightAnchor.constraint(equalToConstant: 18)
            ])
    }
}
