//
//  LoginViewController.swift
//  Smart List
//
//  Created by Haamed Sultani on Jul/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: - PROPERTIES
    var activeText: UITextField?
    
    //MARK: - UI ELEMENTS
    var spinner = UIActivityIndicatorView()
    var spinnerContainer = UIView()
    
    var scrollView: UIScrollView = {
        var view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var applTitleLabel : UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "Smart Kitchen"
        lbl.font = UIFont(name: Constants.Visuals.fontName, size: 40)
        lbl.textColor = Constants.ColorPalette.TealBlue
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    
    var midLoginContainer : MidLoginContainer = {
        var view = MidLoginContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var bottomLoginContainer : BottomLoginContainer = {
        var view = BottomLoginContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.ColorPalette.OffWhite

        setupViews()
        registerForKeyboardEvents()
    }
    
    
    
    /// Adds all the UI Elements to the view and configures the constraints
    func setupViews() {
        // Configure scroll view
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        // Configure app title
        view.addSubview(applTitleLabel)
        NSLayoutConstraint.activate([
            applTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            applTitleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            applTitleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            applTitleLabel.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.4)
            ])
        
        
        // Configure mid container view
        scrollView.addSubview(midLoginContainer)
        NSLayoutConstraint.activate([
            midLoginContainer.topAnchor.constraint(equalTo: applTitleLabel.bottomAnchor),
            midLoginContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.25),
            midLoginContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            midLoginContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            midLoginContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
        
        // Configure bottom container view
        scrollView.addSubview(bottomLoginContainer)
        NSLayoutConstraint.activate([
            bottomLoginContainer.topAnchor.constraint(equalTo: midLoginContainer.bottomAnchor),
            bottomLoginContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            bottomLoginContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            bottomLoginContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 0.2)
            ])
    }
    
    
    private func registerForKeyboardEvents() {
        midLoginContainer.emailField.delegate = self
        midLoginContainer.passwordField.delegate = self
        
        // Listen for keyboard events that will adjust the view
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Hide the keyboard if the user taps outside the keyboard
        self.hideKeyboardWhenTappedAround()
    }
    
    
    /// Logs the user in by sendinga  request to the server and saving the auth token
    ///
    /// - Parameter sender: The button that activated this ui event
    @objc func loginButtonTapped(_ sender: UIButton) {
        
        self.view.showLargeSpinner(spinner: self.spinner, container: self.spinnerContainer)         // Show the spinner
        
        Server.shared.loginUser(email: midLoginContainer.emailField.text!, password: midLoginContainer.passwordField.text!) {
            response in
            
            self.view.hideSpinner(spinner: self.spinner, container: self.spinnerContainer)          // Hide the spinner
            
            guard let token = response["token"] else {                                              // If unsuccessful request
                let error = response["error"]
                
                print("Error when trying to login. Error: \(error!)")                                   // Print error
                
                let alertController = UIAlertController(title: "Error",                                 // Alert user of an error
                    message: "\(error ?? "Something went wrong when logging in. Try again.")",
                    preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default)
                
                alertController.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
                
                return
            }
                                                                                                    // If successful
            CoreDataManager.shared.addUser(name: response["name"]!, email: response["email"]!, token: token)    // log the user in and save the auth token
        }
    }
    
    
    /// Switches the view to the sign up view
    ///
    /// - Parameter sender: The button that triggered this UI Event
    @objc func signUpButtonTapped(_ sender: UIButton) {
        self.present(SignUpViewController(), animated: true)
    }
    
    //MARK: - UI Event Handling
    /// Skip sign up and show the Kitchen Tab
    ///
    /// - Parameter sender: The button the user tapped to trigger this action
    @objc func skipButtonTapped(_ sender: UIButton) {
        print("skip sign up")
        
        CoreDataManager.shared.setOfflineMode(offlineMode: true)        // Set offline mode to true
        
        let tabbar = TabBarController()
        self.present(tabbar, animated: true)
    }
}
