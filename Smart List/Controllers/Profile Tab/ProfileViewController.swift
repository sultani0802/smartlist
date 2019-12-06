//
//  ProfileViewController.swift
//  Smart List
//
//  Created by Haamed Sultani on Jun/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {
    ///
    //MARK: - Properties
    var viewModel : ProfileViewModel!
    
    
    
    ///
    ///MARK: - UI Elements
    ///
    var tableView: UITableView!                         // The tableview that will contain the different settings options
    var spinner = UIActivityIndicatorView()             // Create spinner for this view
    var spinnerContainer : UIView = UIView()            // Container for the spinner
    var signUpContainer : SettingsSignUpContainer = {
        var view = SettingsSignUpContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var logoutBarButtonItem : UIBarButtonItem?
    
    
    //
    //MARK - Initialization
    //
	init(coreDataManager : CoreDataManager, userDefaults: SmartListUserDefaults) {
		self.viewModel = ProfileViewModel(coreDataManager: coreDataManager, userDefaults: userDefaults)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deinitializing ProfileViewController")
    }
    
    
    ///
    //MARK - View Methods
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        setupVisualSettings()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.loadSettings()
        setupTableView()
    }
    
    
    //
    //MARK - Initialization Methods
    //
    
    /// Sets up any visual settings for the profile view
    func setupVisualSettings() {
        self.view.backgroundColor = .white                                      // Set background color to white
        self.navigationItem.title = viewModel.navTitle                          // Set view's title
        self.navigationController?.navigationBar.prefersLargeTitles = true      // Make title big
        
        logoutBarButtonItem = UIBarButtonItem(title: "Logout",                  // Instantiate logout button
                                              style: .done,
                                              target: self,
                                              action: #selector(self.logoutButtonTapped))
       
        navigationItem.rightBarButtonItem = logoutBarButtonItem                 // Set it to the right
		navigationItem.rightBarButtonItem?.tintColor = Constants.Visuals.ColorPalette.Crimson
    }
    
    
    /// Initializes and configures the tableView
    private func setupTableView() {
        if (tableView != nil) {
            self.tableView.removeFromSuperview()
        }
        
		if !self.viewModel.defaults.loggedInStatus {
            tableView = UITableView(frame: CGRect(x: 0,                                                     // Instantiate tableView
                y: UIApplication.shared.statusBarFrame.size.height,
                width: self.view.frame.width,
                height: self.view.frame.height * 0.4))

            toggleLogoutButton(toggle: false)                                                           // Disable the logout button
            showSignUpContainer()                                                                       // Show the log in/sign up container

        } else {
            tableView = UITableView(frame: CGRect(x: 0,                                                     // Instantiate tableView
                y: UIApplication.shared.statusBarFrame.size.height,
                width: self.view.frame.width,
                height: self.view.frame.height))
            
            toggleLogoutButton(toggle: true)                                                            // Enable the logout button
            hideSignUpContainer()                                                                       // Hide the log in/sign up container
        }
        
        tableView.dataSource = self                                                                     // Datasource to self
        tableView.delegate = self                                                                       // Delegate to self (extension)
        tableView.translatesAutoresizingMaskIntoConstraints = false                                     // Use auto-layout
        
		tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: self.viewModel.tableViewCellId)   // Register cells
        tableView.backgroundColor = .white
        tableView.rowHeight = 65                                                                   // Set height of the cell
        tableView.keyboardDismissMode = .onDrag                                                         // Dismiss keyboard when user drags on tableview
        tableView.separatorStyle = .none                                                                // Remove cell separators
        
        self.view.addSubview(tableView)                                                                 // Add tableview to view
    }
    
    
    
    //MARK: - My Methods
    @objc func logoutButtonTapped() {
        self.tableView.showLargeSpinner(spinner: self.spinner,
                                        container: spinnerContainer)        // Show spinner when user clicks logout button
        viewModel.logoutRequest()                                           // Send logout request to the server
    }

    
    func toggleLogoutButton(toggle: Bool) {
        if !toggle {
            logoutBarButtonItem?.isEnabled = false
        } else {
            logoutBarButtonItem?.isEnabled = true
        }
    }
    
    
    /// Show the sign up/login container instead of the tableView
    /// This method is only called if the user is not logged in
    func showSignUpContainer() {
        view.addSubview(signUpContainer)
        
        // sign up container constraints
        NSLayoutConstraint.activate([
            signUpContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            signUpContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpContainer.bottomAnchor.constraint(equalTo: (tabBarController?.tabBar.topAnchor)!),
            signUpContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    func hideSignUpContainer() {
        signUpContainer.removeFromSuperview()
    }
    
    
    func showLogoutAlert(message: String) {
        let alertController = UIAlertController(title: "Logging out", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true)
    }
    
    
    /// Shows an alert that allows the user to edit the setting
    ///
    /// - Parameter message: The message to be displayed appropriate to the setting being changed
    func willShowAlert(message: String, section: Int, row: Int) {
        let alertController = UIAlertController(title: "Change Setting",                // Alert controller
            message: message,
            preferredStyle: .alert)
        
        alertController.addTextField{(textField) in                                     // Adding textfield to alert controller
            textField.placeholder = "Type here"
            textField.autocapitalizationType = .words
            textField.returnKeyType = .done
            textField.keyboardType = .emailAddress
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {                // Save action
            UIAlertAction in
            
            let textField = alertController.textFields![0]                              // Get the alert's textfield object
            let updatedValue = textField.text!.capitalized                              // Get the text the user entered
            
            let settingBeingUpdate : String = self.viewModel.settings[section][row].lowercased()    // Get the setting the user wanted to udpate
            
            self.viewModel.sendEditRequest(settingToBeUpdated: settingBeingUpdate, updatedValue) {
                (message) -> () in
                
                let alertController = UIAlertController(title: "Updated Setting", message: message, preferredStyle: .alert)
                let okAction = UIKit.UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(okAction)

                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                    self.tableView.reloadData()
                }
                
            }    // Send server request to update setting
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {             // Cancel action
            UIAlertAction in
            print("cancelled changes")
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)                  // Show alert
    }
    
    
    
    /// Redirects the user to the app in their Settings to allow notifications
    ///
    /// - Parameter row: Used to determine which cell the user tapped
    func goToSettings(row : Int) {
        let alertController = UIAlertController (title: "Enable Notifications",
                                                 message: "In order to receive notifications when your food expires, you'll have to allow notifications from this app.",
                                                 preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go to settings", style: .default) {
            (_) -> Void in
            
            // Get the settings url so we can redirect the user
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            // If redirection is successful
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: {                     // Redirect the User
                    (success) in
                })
            }
        }
        
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)                           // Present the alert
    }
    
     
    @objc func signUpButtonTapped(_ button: UIButton) {
		let signUpVC = SignUpViewController(coreDataManager: self.viewModel.coreData, userDefaults: self.viewModel.defaults, initializedBeforeTabBar : true)
		
		self.present(signUpVC, animated: true)
    }
    
    @objc func loginButtonTapped(_ button: UIButton) {
		let loginVC = LoginViewController(coreDataManager: self.viewModel.coreData, userDefaults: self.viewModel.defaults)
//        loginVC.isPoppedUp = true
        let notificationName = Notification.Name(Constants.NotificationKey.LoginViewPoppedUpNotificationKey)
        NotificationCenter.default.post(name: notificationName, object: nil)
        
		self.present(loginVC, animated: true)
    }
}


/**
 *
 *  This extension has methods that will be called after a server request
 *
 */

extension ProfileViewController : ProfileViewModelDelegate {
    
    /// This method is called from the viewModel when the user tries to logout and the logout is successful. Make UI changes based on REST request
    ///
    /// - Parameter message: The success response from the server
    func didFinishLoggingOutSuccess(message: String) {
        tableView.hideSpinner(spinner: spinner, container: spinnerContainer)        // Hide the spinner
        toggleLogoutButton(toggle: false)                                           // Disable the logout button
        
        viewModel.loadSettings()                                                    // Reload settings
        setupTableView()                                                            // Setup tableView again
        showLogoutAlert(message: message)                                           // Show successful logout alert
    }
    
    
    /// This method is called from the viewModel when the user tries to logout and the logout fails. Make UI changes based on REST request
    ///
    /// - Parameter error: The error response from the server
    func didFinishLoggingOutFailure(error: String) {
        tableView.hideSpinner(spinner: spinner, container: spinnerContainer)        // Hide the spinner
        showLogoutAlert(message: error)                                             // Show the unsuccessful logout alert
    }
}
