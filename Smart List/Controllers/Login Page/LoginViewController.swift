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
    private var viewModel : LoginViewModel
    
    //MARK: - UI ELEMENTS
    var activeText: UITextField?        // Keeps track of which textfield is currently being edited
	lazy var spinner : UIActivityIndicatorView = {
		return UIActivityIndicatorView()
	}()
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
		lbl.textColor = Constants.Visuals.ColorPalette.TealBlue
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
    
    // MARK: - Initializers
	init(coreDataManager : CoreDataManager, userDefaults: SmartListUserDefaults) {
        viewModel = LoginViewModel(coreDataManager: coreDataManager, userDefaults: userDefaults)
        super.init(nibName: nil, bundle: nil)
        
		// Observe notification of LoginViewController popping up
		observePopUpNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deinitializing LoginViewController")
		// Remove notificaton observers
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
		view.backgroundColor = Constants.Visuals.ColorPalette.OffWhite
        // Conform to view model protocol
		viewModel.loginViewModelDelegate = self
        
        setupViews()
        registerForKeyboardEvents()
    }
    
    
    // MARK: - UI Setup Methods
    
    /// Add all the UI Elements to the view and configure the constraints
    private func setupViews() {
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
    
	
	/// Sets the delegates of the textfields to this class and registers for keyboard events
    private func registerForKeyboardEvents() {
        midLoginContainer.emailField.delegate = self
        midLoginContainer.passwordField.delegate = self
        
        // Hide the keyboard if the user taps outside the keyboard
        self.hideKeyboardWhenTappedAround()
        
        // Listen for keyboard events that will adjust the view
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
	
	/// Observes the notification that is sent when the LoginViewController is popped up
    private func observePopUpNotification() {
		let notificationName = Notification.Name(Constants.NotificationKey.LoginViewPoppedUpNotificationKey)
        NotificationCenter.default.addObserver(self, selector: #selector(setPoppedUpToTrue), name: notificationName, object: nil)
    }
    
	
	/// Sets the isPoppedUp flag to true
    @objc private func setPoppedUpToTrue() {
        self.viewModel.isPoppedUp = true
    }
    
    /// Logs the user in by sending a request to the server and saving the user's session into user defaults
    ///
    /// - Parameter sender: The button that activated this ui event
    @objc func loginButtonTapped(_ sender: UIButton = UIButton()) {
        viewModel.loginUser(email: midLoginContainer.emailField.text!, password: midLoginContainer.passwordField.text!)
    }
    
    
    /// Switches the view to the sign up view
    ///
    /// - Parameter sender: The button that triggered this UI Event
    @objc func signUpButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                // Get the top most view
                var topController : UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                while(topController.presentedViewController != nil) {
                    topController = topController.presentedViewController!
                }
                
                // Present the Sign Up Page
				topController.present(SignUpViewController(coreDataManager: self.viewModel.coreData, userDefaults: self.viewModel.defaults), animated: true)
            }
        }
    }
    
    //MARK: - UI Event Handling
    /// Skip sign up and show the Kitchen Tab
    ///
    /// - Parameter sender: The button the user tapped to trigger this action
    @objc func skipButtonTapped(_ sender: UIButton) {
		// Save offline mode to User Defaults
		self.viewModel.defaults.offlineMode = true
        
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
				
                if (!self.viewModel.isPoppedUp) {
                    // Get the top most view
                    var topController : UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                    while(topController.presentedViewController != nil) {
                        topController = topController.presentedViewController!
                    }
                    
                    // Init the Tab Bar and present it
					topController.present(TabBarController(coreDataManager: self.viewModel.coreData, userDefaults: self.viewModel.defaults), animated: true)
                }
            }
        }
    }
}


extension LoginViewController : LoginViewModelDelegate {
    
    /// Displays a large spinner view
    /// Called from LoginViewModel
    func showSpinner() {
		DispatchQueue.main.async {
			self.view.showLargeSpinner(spinner: self.spinner, container: self.spinnerContainer)
		}
    }
    
    /// Hides the spinner currently in view
    /// Called from LoginViewModel
    func hideSpinner() {
		DispatchQueue.main.async {
			self.view.hideSpinner(spinner: self.spinner, container: self.spinnerContainer)
		}
    }
    
    /// Displays an alert; called from LoginViewModel
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - message: Message of the alert
    func showAlert(title: String, message: String) {
        
		let alertController = UIAlertController(title: title,
            message: message,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    /// Dismisses the LoginViewController
    /// Will initialize the TabBar if it hasn't already been initialized
    func dismissLoginView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {                                                      // Hide the login view
                // If the login view was not instantiated from the profile tab
                // then, create the TabBar (we are assuming the tabbar hasn't been created yet)
                if (!self.viewModel.isPoppedUp) {
                    // Get the top most view
                    var topController : UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                    while(topController.presentedViewController != nil) {
                        topController = topController.presentedViewController!
                    }
                    
                    // Init the Tab Bar and present it
					topController.present(TabBarController(coreDataManager: self.viewModel.coreData, userDefaults: self.viewModel.defaults), animated: true)
                }
            }
        }
    }
}
