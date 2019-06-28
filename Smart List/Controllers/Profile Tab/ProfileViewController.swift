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
    
    var tableView: UITableView!                     // The tableview that will contain the different settings options
    
    
    
    ///
    //MARK - View Methods
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVisualSettings()
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
    }
    
    
    /// Initializes and configures the tableView
    private func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0,                                                     // Instantiate tableView
                                              y: UIApplication.shared.statusBarFrame.size.height,
                                              width: self.view.frame.width,
                                              height: self.view.frame.height))
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
    
    
    
    //MARK: - My Methods
    func editSetting(setting: Int) {
        switch setting {
        case Constants.Settings.Name:
            showAlert(message: "Enter your name.")
        case Constants.Settings.Email:
            showAlert(message: "Enter your email.")
        case Constants.Settings.Notifications:
            showAlert(message: "Change your notification settings in the settings app.")
        default:
            print("Cancel setting modification")
        }
    }
    
    
    /// Shows an alert that allows the user to edit the setting
    ///
    /// - Parameter message: The message to be displayed appropriate to the setting being changed
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Change Setting",
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Type here"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            UIAlertAction in
            
            let textField = alertController.textFields![0]
            print("saved changes: \(textField.text!)")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            print("cancelled changes")
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
