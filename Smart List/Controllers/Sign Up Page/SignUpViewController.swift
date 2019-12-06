//
//  SignUpViewController.swift
//  Smart List
//
//  Created by Haamed Sultani on Jun/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //MARK: - Properties
//    var activeText : UITextField?
//    var isPoppedUp : Bool = false
//    private var coreData : CoreDataManager
//	private var defaults : SmartListUserDefaults!
	private var viewModel : SignUpViewModel!
    
    //MARK: - UI Elements
    var spinner = UIActivityIndicatorView()
    var spinnerContainer = UIView()
    
    
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

    
	init(coreDataManager: CoreDataManager, userDefaults: SmartListUserDefaults, initializedBeforeTabBar: Bool = false) {
		self.viewModel = SignUpViewModel(coreData: coreDataManager, defaults: userDefaults, initBeforeTabBar: initializedBeforeTabBar)
		
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
        
        print("Deinitializing Sign Up View Controller")
    }
    
    
    
    //MARK: - Initialization Methods
    private func setupView() {
		view.backgroundColor = Constants.Visuals.ColorPalette.OffWhite
        
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
            bottomContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.4),
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
    /// Send server request to create a new user, upon success, save the user name and email in User Defaults
    ///
    /// - Parameter sender: The button the user tapped to trigger this action
    @objc func signUpButtonTapped(_ sender: UIButton = UIButton()) {
        if (bottomContainer.nameField.text != nil &&
            bottomContainer.emailField.text != nil &&
            bottomContainer.passwordField.text != nil) {
            
			// Show spinner
            self.view.showLargeSpinner(spinner: self.spinner, container: self.spinnerContainer)
            
            
            // Make a request to Smartlist API to create a new User in the DB
            Server.shared.signUpNewUser(name: bottomContainer.nameField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                        email: bottomContainer.emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                        password: bottomContainer.passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) {
                [weak self] newUser in
				guard let self = self else { return }
											
                self.view.hideSpinner(spinner: self.spinner, container: self.spinnerContainer)                                  // Hide the spinner
                                            
                if let error = newUser["error"] {                                                                               // Server responded with error
                    
                    let alertController = UIAlertController(title: "Error signing up",                                              // Alert user of an error
                        message: error,
                        preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    alertController.addAction(okAction)
                    
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true)                                                               // Show alert
                    }
                }
                else if (newUser["name"] != "" && newUser["email"] != "" && newUser["token"] != "") {                           // If the server response contains valid User information
//                    self.coreData.addUser(name: newUser["name"]!, email: newUser["email"]!, token: newUser["token"]!)      // Save the user's information in Core Data
					self.viewModel.defaults.saveUserSession(name: newUser["name"]!, email: newUser["email"]!, token: newUser["token"]!)
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {                                                                               // Hide the Sign Up View
                            // If the sign up view wasn't created from the profile tab
                            // then, create the TabBar (we are assuming the tabbar hasn't been created yet)
							if (!self.viewModel.initializedBeforeTabBar) {
								self.present(TabBarController(coreDataManager: self.viewModel.coreData, userDefaults: self.viewModel.defaults), animated: true)                                                        // Create and show the tabbar
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    /// Displays the login page
    @objc func loginButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
			self.present(LoginViewController(coreDataManager: self.viewModel.coreData, userDefaults: self.viewModel.defaults), animated: true)
        }
    }
    
    //MARK: - UI Event Handling
    /// Skip sign up and show the Kitchen Tab
    ///
    /// - Parameter sender: The button the user tapped to trigger this action
    @objc func skipButtonTapped(_ sender: UIButton) {		
		print("skip sign up")
		// Save offline mode to user defaults
		self.viewModel.defaults.offlineMode = true
        
        self.dismiss(animated: true) {
			if (!self.viewModel.initializedBeforeTabBar) {
				self.present(TabBarController(coreDataManager: self.viewModel.coreData, userDefaults: self.viewModel.defaults), animated: true)
            }
        }
    }
}





//
// MARK: - TextField Delegates
//
extension SignUpViewController: UITextFieldDelegate {
	
	@objc func keyboardWillChange(notification: Notification) {
		guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
			return
		}
		
		if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification
		{
			let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
			
			self.scrollView.contentInset = contentInsets
			self.scrollView.scrollIndicatorInsets = contentInsets
			
			var aRect : CGRect = self.view.frame
			aRect.size.height -= keyboardSize.height
			if let activeText = self.viewModel.activeText {
				if (aRect.contains(activeText.frame.origin)){
					self.scrollView.scrollRectToVisible(activeText.frame, animated: true)
				}
			}
		} else if notification.name == UIResponder.keyboardWillHideNotification {
			//Once keyboard disappears, restore original positions
			let info = notification.userInfo!
			let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
			let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
			self.scrollView.contentInset = UIEdgeInsets.zero
			self.scrollView.scrollIndicatorInsets = contentInsets
			self.view.endEditing(true)
		}
	}
	
	
	//
	//Mark: - TextField Delegates
	//
	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.viewModel.activeText = textField
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		self.viewModel.activeText = nil
	}
	
	/// This method is called everytime the user hits the Enter key on the keyboard
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == bottomContainer.nameField {
			bottomContainer.nameField.resignFirstResponder()
			bottomContainer.emailField.becomeFirstResponder()
		} else if textField == bottomContainer.emailField {
			bottomContainer.emailField.resignFirstResponder()
			bottomContainer.passwordField.becomeFirstResponder()
		} else if textField == bottomContainer.passwordField {
			signUpButtonTapped()
		}
		
		return true
	}
	
	
	/// Called everytime the user types inside one of textField on the Sign Up View
	///
	/// - Parameter textField: Reference to the textField that is being edited
	@objc func textFieldDidChange(_ textField: UITextField) {
		toggleSignUp()
		
		if (textField == bottomContainer.emailField) {                                      // If the user is typing in the email textField
			
			//            if let email = bottomContainer.emailField.text {
			//                toggleEmailImage(toggle: Regex.shared.validateEmail(candidate: email))          // User regex to validate their email
			//            }
		} else if (textField == bottomContainer.passwordField) {                            // If the user is typing in the password textField
			togglePasswordImage(toggle: true)
		}
	}
}
