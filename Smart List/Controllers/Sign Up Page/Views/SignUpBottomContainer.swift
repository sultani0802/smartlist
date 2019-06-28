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
    var nameField : UITextField = {
        var view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.font = UIFont(name: Constants.Visuals.fontName, size: 14)
        view.textColor = Constants.ColorPalette.DarkGray
        view.placeholder = "Your name"
        view.borders(for: [.all], width: 0.2, color: .black)
        
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
        
        NSLayoutConstraint.activate([
            fieldStack.topAnchor.constraint(equalTo: topAnchor),
            fieldStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldStack.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            nameField.widthAnchor.constraint(equalTo: fieldStack.widthAnchor, multiplier: 0.7),
            emailField.widthAnchor.constraint(equalTo: fieldStack.widthAnchor, multiplier: 0.7),
            passwordField.widthAnchor.constraint(equalTo: fieldStack.widthAnchor, multiplier: 0.7)
            ])
    }
}
