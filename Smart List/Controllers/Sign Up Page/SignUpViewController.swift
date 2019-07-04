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
    var activeText : UITextField?
    
    
    
    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        registerForKeyboardEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
//        view.backgroundColor = .white
        
        // Adding top container and configuring
        view.addSubview(scrollView)
        
        // Constraints for scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        scrollView.addSubview(topContainer)
        scrollView.addSubview(bottomContainer)
        
        // Constraints for topContainer
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            topContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.40),
            topContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        
        
        // Constraint for bottomContainer
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: bottomContainer, attribute: .top, relatedBy: .equal, toItem: topContainer, attribute: .bottom, multiplier: 1, constant: 50),
            bottomContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            bottomContainer.heightAnchor.constraint(lessThanOrEqualTo: scrollView.heightAnchor, multiplier: 0.60),
            bottomContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
    }
    
    private func registerForKeyboardEvents() {
        bottomContainer.nameField.delegate = self
        bottomContainer.emailField.delegate = self
        bottomContainer.passwordField.delegate = self
        
        // Listen for keyboard events that will adjust the view
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Hide the keyboard if the user taps outside the keyboard
        self.hideKeyboardWhenTappedAround()
    }
    
    
    /// This method enables the Sign Up button iff all textFields are filled
    func toggleSignUp() {
        if (bottomContainer.nameField.text != "" && bottomContainer.emailField.text != "" && bottomContainer.passwordField.text != "") {
            bottomContainer.signUpButton.isEnabled = true
        } else {
            bottomContainer.signUpButton.isEnabled = false
        }
    }
    
    
    func toggleEmailImage(toggle : Bool) {
        if (toggle) {
            bottomContainer.emailImage.isHidden = false
            bottomContainer.emailImage.image = UIImage(named: "check")
        } else {
            bottomContainer.emailImage.isHidden = false
            bottomContainer.emailImage.image = UIImage(named: "warning")
            
        }
    }
    
    func togglePasswordImage(toggle : Bool) {
        if (toggle) {
            bottomContainer.passwordImage.isHidden = false
            bottomContainer.passwordImage.image = UIImage(named: "check")
        } else {
            bottomContainer.passwordImage.isHidden = false
            bottomContainer.passwordImage.image = UIImage(named: "warning")
            
        }
    }
    
    //MARK: - UI Event Handling
    /// Send server request to create a new user, upon success, save the user name and email in Core Data
    ///
    /// - Parameter sender: The button the user tapped to trigger this action
    @objc func signUpButtonTapped(_ sender: UIButton) {
        if (bottomContainer.nameField.text != nil &&
            bottomContainer.emailField.text != nil &&
            bottomContainer.passwordField.text != nil) {
            
            // Make a request to Smartlist API to create a new User in the DB
            Server.shared.signUpNewUser(name: bottomContainer.nameField.text!, email: bottomContainer.emailField.text!, password: bottomContainer.passwordField.text!) {
                newUser in
                
                if (newUser["name"] != "" && newUser["email"] != "") {                                  // If the server response contains valid User information
                    CoreDataManager.shared.addUser(name: newUser["name"]!, email: newUser["email"]!)        // Save the user's information in Core Data
                    
                    DispatchQueue.main.async {
                        let tabbar = TabBarController()
                        self.present(tabbar, animated: true)                                                // Switch view to the tabbar
                    }
                    
                } else if (newUser["error"] != nil ){
                    print("Server responded with invalid User data during sign up")                     // Otherwise, an error occurred
                    
                    let error = newUser["error"]                                                            // Get error message
                    
                    let alertController = UIAlertController(title: "Error",                                 // Alert user of an error
                        message: "There was an error sign up. Please try again.\nError:\(error ?? "unexpected error")",
                                                            preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true)                                           // Show alert
                }
            }
        }
    }
    
    
    //MARK: - UI Event Handling
    /// Skip sign up and show the Kitchen Tab
    ///
    /// - Parameter sender: The button the user tapped to trigger this action
    @objc func skipButtonTapped(_ sender: UIButton) {
        print("skip sign up!")
    }
}
