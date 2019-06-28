//
//  SignUpViewController.swift
//  Smart List
//
//  Created by Haamed Sultani on Jun/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    //MARK: - UI Elements
    var topContainer : SignUpTopContainer = {
        var view = SignUpTopContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var bottomContainer : SignUpBottomContainer = {
        var view = SignUpBottomContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var scrollView : UIScrollView = {
        var view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    
    //MARK: - Properties
    var activeText: UIView?
    
    
    
    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        registerForKeyboardEvents()
    }
    
    deinit {
        // Unregister for the keyboard notifications. Therefore, stop listening for the events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    

    //MARK: - Initialization Methods
    private func setupView() {
        view.backgroundColor = Constants.ColorPalette.OffWhite
        
        // Adding top container and configuring
        view.addSubview(scrollView)

        
        // Constraints for scrollView
        NSLayoutConstraint.activate([
            scrollView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        scrollView.addSubview(topContainer)
        scrollView.addSubview(bottomContainer)
        
        // Constraints for topContainer
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            topContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.40),
            topContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        
        // Constraint for bottomContainer
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: bottomContainer, attribute: .top, relatedBy: .equal, toItem: topContainer, attribute: .bottom, multiplier: 1, constant: 50),
            bottomContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            bottomContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.20),
            bottomContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            bottomContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
    }
    
    private func registerForKeyboardEvents() {
        bottomContainer.nameField.delegate = self
        bottomContainer.emailField.delegate = self
        bottomContainer.passwordField.delegate = self
        
        // Listen for keyboard events that will adjust the view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Hide the keyboard if the user taps outside the keyboard
        self.hideKeyboardWhenTappedAround()
    }
}
