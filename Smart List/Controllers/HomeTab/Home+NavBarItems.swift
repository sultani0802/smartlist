//
//  Home+NavBarItems.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension HomeViewController {
    
    /// Sets up the navigation bar buttons
    func setupNavItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constants.ColorPalette.Yellow
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editButtonPressed))
//        navigationItem.leftBarButtonItem?.tintColor = Constants.ColorPalette.Yellow
    }
    
    
    /// Checks if the table has any categories
    /// If there are none then the Edit button is disabled, otherwise it is enabled
    func editButtonIsEnabled() {
        if categories.count <= 0 {
            navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    
    /// Purpose: This method is called when the user taps on the + sign at the top right
    ///
    /// Allows the user to add a category to the TableView
    /// They are presented with a list of options, one of them being an option to add their own
    @objc func addButtonTapped() {
        // Create the alert controller
        let alert = UIAlertController(title: "New category", message: "Which category would you like to create?", preferredStyle: .actionSheet)
        
        // Goes through the filtered list of categories and adds the action to the alert controller
        for cat in validateCategories() {
            alert.addAction(UIAlertAction(title: cat, style: .default, handler: {(UIAlertAction) in
                self.tableView.beginUpdates()
                
                self.addCategory(categoryName: cat) // Add the Category entity to Core Data
                self.tableView.insertSections(NSIndexSet(index: self.categories.count - 1) as IndexSet, with: .bottom) // Insert the Category section into the table view
                self.addPlaceHolderCell(toCategory: self.categories[self.categories.count-1]) // Insert the dummy cell into the new Category
                
                self.tableView.endUpdates()
                // Scroll to the category the user just added
                let indexPath = IndexPath(row: 0, section: self.categories.count-1)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }))
        }
        
        
        /// Creates another alert where user can type a custom category
        alert.addAction(UIAlertAction(title: "Create my own", style: .default, handler:{ (UIAlertAction) in
            
            // Create another alert that allows the user to type a name for their category
            let customAlert = UIAlertController(title: "Title", message: "Enter the name of your category", preferredStyle: .alert)
            
            // Add a textfield to the alert
            customAlert.addTextField { (textField) in
                textField.placeholder = "Category name"
            }
            
            // Lets the user confirm and add their custom category
            let okAction = UIKit.UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                let textField = customAlert.textFields![0]
                //textField.text!
                self.tableView.beginUpdates()
                
                self.addCategory(categoryName: textField.text!) // Add the Category entity to Core Data
                self.tableView.insertSections(NSIndexSet(index: self.categories.count - 1) as IndexSet, with: .bottom) // Insert the Category section into the table view
                self.addPlaceHolderCell(toCategory: self.categories[self.categories.count-1]) // Insert the dummy cell into the new Category
                
                self.tableView.endUpdates()
                
                // Scroll to the category the user just added
                let indexPath = IndexPath(row: 0, section: self.categories.count-1)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            })
            
            // Disable the OK button in the alert
            okAction.isEnabled = false
            
            
            // Lets the user go back to the previous action sheet
            customAlert.addAction(UIKit.UIAlertAction(title: "Go back", style: .cancel, handler: {(UIAlertAction) in
                self.present(alert, animated: true, completion: nil)
            }))
            
            // Observe the text the user enters
            // If it isn't empty then enable the OK button, otherwise disable it
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: customAlert.textFields![0], queue: OperationQueue.main, using: {(notification) in
                
                if customAlert.textFields![0].text != "" {
                    okAction.isEnabled = true
                } else {
                    okAction.isEnabled = false
                }
            })
            
            // Present the nested alert
            customAlert.addAction(okAction)
            self.present(customAlert, animated: true, completion: nil)
        }))
        
        
        // Cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(UIAlertAction) in
            print("User cancelled selection")
        }))
        
        
        // Display the Alert Controller
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
