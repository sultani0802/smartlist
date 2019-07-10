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
    ///
    let coreDataManager = CoreDataManager.shared    // Reference to Core Data Manager
    let profileViewCellId : String = "profileViewCell"
    var settings : [String] = [
        "Name",
        "Email",
        "Notifications"
    ]
    var isLoggedIn : Bool = false
    var values : [String:String?]?
    
    var tableView: UITableView!                     // The tableview that will contain the different settings options
    var spinner = UIActivityIndicatorView()         // Create spinner for this view
    var spinnerContainer : UIView = UIView()        // Container for the spinner
    
    
    ///
    ///MARK: - UI Elements
    ///
    var signUpContainer : SettingsSignUpContainer = {
        var view = SettingsSignUpContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var logoutBarButtonItem : UIBarButtonItem?
    
    
    
    ///
    //MARK - View Methods
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVisualSettings()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadSettings()
        setupTableView()
    }
    
    //
    //MARK - Initialization Methods
    //
    
    
    /// Sets up any visual settings for the profile view
    func setupVisualSettings() {
        self.view.backgroundColor = .white                                      // Set background color to white
        self.navigationItem.title = "Settings"                                  // Set view's title
        self.navigationController?.navigationBar.prefersLargeTitles = true      // Make title big
        
        logoutBarButtonItem = UIBarButtonItem(title: "Logout",                  // Instantiate logout button
                                              style: .done,
                                              target: self,
                                              action: #selector(self.logoutButtonTapped))
        navigationItem.rightBarButtonItem = logoutBarButtonItem                 // Set it to the right
        navigationItem.rightBarButtonItem?.tintColor = Constants.ColorPalette.Crimson
    }
    
    
    /// Initializes and configures the tableView
    private func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0,                                                     // Instantiate tableView
            y: UIApplication.shared.statusBarFrame.size.height,
            width: self.view.frame.width,
            height: self.view.frame.height))
        
        
        if !isLoggedIn {
            showSignUpContainer()                                                                       // Show the log in/sign up container
            toggleLogoutButton(toggle: false)                                                           // Disable the logout button
        } else {
            toggleLogoutButton(toggle: true)                                                                // Enable the logout button
            
            tableView.dataSource = self                                                                     // Datasource to self
            tableView.delegate = self                                                                       // Delegate to self (extension)
            tableView.translatesAutoresizingMaskIntoConstraints = false                                     // Use auto-layout
            
            tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: self.profileViewCellId)
            
            // Constraints applied so that the tableView isn't displayed behind the tab bar
            let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
            tableView.contentInset = adjustForTabbarInsets
            tableView.scrollIndicatorInsets = adjustForTabbarInsets
            
            self.tableView.rowHeight = 65                                                                   // Set height of the cell
            tableView.keyboardDismissMode = .onDrag                                                         // Dismiss keyboard when user drags on tableview
            tableView.separatorStyle = .none                                                                // Remove cell separators
            
            
            self.view.addSubview(tableView)                                                                 // Add tableview to view
        }
    }
    
    
    
    //MARK: - My Methods
    @objc func logoutButtonTapped() {
        
        self.tableView.showLargeSpinner(spinner: self.spinner, container: spinnerContainer) // Show spinner when user clicks logout button
        
        Server.shared.logout() {
            response in
                                                                                    // Hide the spinner
            self.tableView.hideSpinner(spinner: self.spinner, container: self.spinnerContainer)
            
            if let success = response["success"] {
                CoreDataManager.shared.setOfflineMode(offlineMode: true)       // Set offline mode in Core Data
                self.isLoggedIn = false                                      // Set offline mode in this class
                self.toggleLogoutButton(toggle: false)
                self.showSignUpContainer()                                   // Hide tableview, show sign up/log in container
                
                DispatchQueue.main.async {
                    self.showLogoutAlert(message: success)
                }
            } else {
                let error = response["error"]
                print(error)
                
                DispatchQueue.main.async {
                    self.showLogoutAlert(message: error!)
                }
            }
        }
    }
    
    func toggleLogoutButton(toggle: Bool) {
        if !toggle {
            logoutBarButtonItem?.isEnabled = false
        } else {
            logoutBarButtonItem?.isEnabled = true
        }
    }
    
    func editSetting(setting: Int) {
        switch setting {
        case Constants.Settings.Name:
            showAlert(message: "Enter your name.", setting: setting)
        case Constants.Settings.Email:
            showAlert(message: "Enter your email.", setting: setting)
        case Constants.Settings.Notifications:
            showAlert(message: "Change your notification settings in the settings app.", setting: setting)
        default:
            print("Cancel setting modification")
        }
    }
    
    
    /// Loads the Settings Model from Core Data
    func loadSettings() {
        let settings = CoreDataManager.shared.loadSettings()
        
        if (settings.name != "" && settings.email != ""){       // Set email and name values
            let name = settings.name
            let email = settings.email
            
            isLoggedIn = settings.isLoggedIn                    // Set logged in status
            
            values = ["name":name, "email":email]
        }
    }
    
    
    /// Show the sign up/login container instead of the tableView
    /// This method is only called if the user is not logged in
    func showSignUpContainer() {
        self.tableView.isHidden = true
        
        view.addSubview(signUpContainer)
        
        NSLayoutConstraint.activate([
            signUpContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signUpContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            signUpContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
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
    func showAlert(message: String, setting: Int) {
        let alertController = UIAlertController(title: "Change Setting",                // Alert controller
            message: message,
            preferredStyle: .alert)
        
        alertController.addTextField{(textField) in                                     // Adding textfield to alert controller
            textField.placeholder = "Type here"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {                // Save action
            UIAlertAction in
            
            let textField = alertController.textFields![0]                                  // Get the alert's textfield object
            
            if self.settings[setting].lowercased() == "name" {                              // If user is editing the name
                CoreDataManager.shared.addUser(name: textField.text!, email: "", token: "")                // Save the name to Core Data
                
                self.values!["name"] = textField.text!                                          // Update that on the view
                self.tableView.reloadData()
            } else if self.settings[setting].lowercased() == "email" {
                CoreDataManager.shared.addUser(name: "", email: textField.text!, token: "")
            }
            
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
        let signUpVC = SignUpViewController()
        signUpVC.isPoppedUp = true
        DispatchQueue.main.async {
            self.present(signUpVC, animated: true)
        }
    }
    
    @objc func loginButtonTapped(_ button: UIButton) {
        let loginVC = LoginViewController()
        loginVC.isPoppedUp = true
        DispatchQueue.main.async {
            self.present(loginVC, animated: true)
        }
    }
}
