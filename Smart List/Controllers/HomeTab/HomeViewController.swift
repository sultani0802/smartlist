//
//  HomeViewController.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//


import UIKit
import CoreData
import SwipeCellKit
import ViewAnimator


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, TableViewAnimationDelegate {
    
    /****************************************/
    /****************************************/
    //MARK: - View Model
    /****************************************/
    /****************************************/

    let viewModel : HomeViewModel = HomeViewModel()

    
    /****************************************/
    /****************************************/
    //MARK: - UI View Components
    /****************************************/
    /****************************************/

    var tableView: UITableView!
    var doneShoppingBarButtonItem : UIBarButtonItem?

    
    // The view that tells the user how to add categories/sections to the table
    // It is only visible when the tableview has no cells
    var getStartedView: HomeGetStartedView = {
        var view = HomeGetStartedView()
        view.translatesAutoresizingMaskIntoConstraints = false                          // Conforms to auto-layout
        view.backgroundColor = Constants.ColorPalette.Yellow.withAlphaComponent(0.7)
        view.isHidden = true                                                            // Instruction view is hidden unless the table view is empty
        
        return view
    }()
    
    
    /****************************************/
    /****************************************/
    //MARK: - View Controller Methods
    /****************************************/
    /****************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Print the location of the device's documents
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        setupViews()                                // Set up the view
        viewModel.loadModels()                      // Load model from Core Data
        toggleInstructions()                        // Show/hide instructions
        registerForKeyboardEvents()                 // Register for keyboard events
        self.hideKeyboardWhenTappedAround()         // Enable the keyboard hiding functionality
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.toggleDoneShoppingButton()
    }
    
    deinit {
        // Unregister for the keyboard events
        unregisterFromKeyboardEvents()
    }
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - UIViews Setup Methods
    /****************************************/
    /****************************************/
    
    /// Initializes the UIViews
    /// Called in viewDidLoad
    private func setupViews() {
        // Customize navigation bar elements
        self.navigationItem.title = "Shopping List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableview()                        // Add the tableview
        
        setupGetStartedView()                   // Add instruction view
        
        setupNavItems()                         // Add navigation bar buttons
        
        self.view.backgroundColor = .white      // Set background color
    }
    
    /// Adds the instruction view to the view controller and sets its constraints
    /// Called in setupViews()
    private func setupGetStartedView() {
        self.view.addSubview(getStartedView)
        
        NSLayoutConstraint.activate([
            getStartedView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            getStartedView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            getStartedView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            getStartedView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
            ])
    }
    
    
    /// Create the tableview, set it's content insets, set delegate/datasource, and register cells
    /// Called in setupViews()
    private func setupTableview() {
        // Instantiate the tableView
        tableView = UITableView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: self.view.frame.width, height: self.view.frame.height))
        // Use auto-layout for the tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints applied so that the tableView isn't displayed behind the tab bar
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        tableView.contentInset = adjustForTabbarInsets
        tableView.scrollIndicatorInsets = adjustForTabbarInsets
        
        // Register our cells to the tableview
        self.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: viewModel.homeCellReuseIdentifier)
        self.tableView.register(HomeTableviewHeader.self, forHeaderFooterViewReuseIdentifier: viewModel.headerCellReuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Add tableview to the view
        self.view.addSubview(tableView)
        
        self.tableView.rowHeight = 65           // Set the cell row height
        
        tableView.keyboardDismissMode = .onDrag // Dismiss the keyboard when the user scrolls the table view
        
        tableView.separatorStyle = .none        // Remove cell seperators
    }
    
    /// Brings the collection view cells & headers into view with a nice animation
    func animateTableView() {
        let myAnimation = AnimationType.from(direction: .left, offset: 40)      // Animation
        
        for section in 0 ..< viewModel.categories.count {                                        // For each section
            if let header = tableView.headerView(forSection: section) {                     // Get the header
                
                DispatchQueue.main.async {
                    UIView.animate(views: [header],                                             // Perform the animation on the header
                        animations: [myAnimation],
                        animationInterval: 0.1,
                        duration: 0.4)
                }
            }
            
            
            let cells = tableView.visibleCells(in: section)                                 // Get the cells under that header
            DispatchQueue.main.async {
                UIView.animate(views: cells,                                                    // Perform the animation on the cells
                    animations: [myAnimation],
                    delay: 0.1,
                    animationInterval: 0.07,
                    duration: 0.4)
            }
        }
    }
    
    /****************************************/
    /****************************************/
    //MARK: - Observer Methods
    /****************************************/
    /****************************************/
    func registerForKeyboardEvents() {
        // Listen for keyboard events that will adjust the view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func unregisterFromKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    /****************************************/
    /****************************************/
    //MARK: - View Logic Methods
    /****************************************/
    /****************************************/

    /// Displays or hides the get started pop up depending on whether there are categories in the tableview
    /// This method is called in viewDidLoad and whenever the user adds/removes a category
    func toggleInstructions() {
        // If there are no visible cells in the tableview, category array and item array is empty
        // Display the get started view
        if tableView.visibleCells.isEmpty && viewModel.categories.count <= 0 && viewModel.items.count <= 0 {
            getStartedView.isHidden = false
        } else {    // Otherwise, hide the get started view
            getStartedView.isHidden = true
        }
    }
    
    
    /// This view listens for keyboard events so this method is called whenever the user
    /// triggers the keyboard to be shown or hidden
    ///
    /// - Parameter notification: the notification we listened to
    @objc func keyboardWillChange(notification: Notification) {
        // Get the keyboard size
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        
        // Check the notification that we listened to
        // If the keyboard became visible
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification
        {
            // Set the content and scroll indicator's insets to above the keyboard
            let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets

        } else if notification.name == UIResponder.keyboardWillHideNotification {    // If the keyboard is hidden
            //Once keyboard disappears, restore original positions
            let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.tabBarController!.tabBar.frame.height, right: 0.0)
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets
        }
    }
    
    
    /// Checks if an item has been completed by the user and enables the Done Shopping button in the navigation bar
    func toggleDoneShoppingButton() {
        if viewModel.numberOfCompletedItems > 0 {
            doneShoppingBarButtonItem?.isEnabled = true
        } else {
            doneShoppingBarButtonItem?.isEnabled = false
        }
    }
    
    /// Saves the current working data to the Data Model
    func saveContext() {
        viewModel.coreData.saveContext()        // Go to Data Model and save context
        DispatchQueue.main.async {
            self.tableView.reloadData()             // Update the view
        }
    }
    
    /// Adds empty placeholder cells that the user uses to add new items
    ///
    /// This is called when loading the app after loading context data
    /// When the user adds a new Item to the section
    ///
    /// - Parameter category: The Category entity that the use is adding the new Item to
    func addPlaceHolderCell(toCategory category: Category) {
        // Toggle on tableview updating
        self.tableView.beginUpdates()
        
        let categoryIndex = viewModel.categories.firstIndex(of: category)                             // Grab the index of the Category entity we are working in
        
        let newDummyItem: Item = viewModel.coreData.addItem(toCategory: category, withItemName: "",
                                                         cellType: Constants.CellType.DummyCell) // Create a new dummmy Item entity
        viewModel.items[categoryIndex!].append(newDummyItem)                                          // Add the dummy entity to our tableView array
        
        let itemIndex = viewModel.items[categoryIndex!].count-1                                  // Get the index of the dummy Item we just added to our tableView array
        
        let indexPath: IndexPath = IndexPath(row: itemIndex, section: categoryIndex!)       // Set the indexPath
        self.tableView.insertRows(at: [indexPath], with: .bottom)                           // Finally add it to our visible tableview
        
        // Toggle off tableview updating
        self.tableView.endUpdates()
    }
}
