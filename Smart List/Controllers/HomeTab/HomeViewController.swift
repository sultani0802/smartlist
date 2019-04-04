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


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    /****************************************/
    /****************************************/
    //MARK: - Class Properties
    /****************************************/
    /****************************************/
    
    // Core Data Manager (Singleton)
    let coreDataManager = CoreDataManager.shared
    
    //MARK: - Constants
    let homeCellReuseIdentifier: String = Constants.CellID.HomeTableViewCellID
    let headerCellReuseIdentifier: String = Constants.CellID.HomeHeaderID
    
    //MARK: - Variables
    
    // This variable is used to keep track of the tab bar's height
    // so that when the user is finished editing, the insets for this view
    // are maintained properly
    public var tabBarHeight: CGFloat?

    
    var defaultCategories : [String] = [
        Constants.DefaultCategories.Produce,
        Constants.DefaultCategories.Bakery,
        Constants.DefaultCategories.MeatSeafood,
        Constants.DefaultCategories.Dairy,
        Constants.DefaultCategories.PackagedCanned,
        Constants.DefaultCategories.Frozen
    ]
    
    //MARK: - Data Sources
    var categories: [Category] = [Category]()
    var items: [[Item]] = [[Item]]()
    
    //MARK: - Views
    var tableView: UITableView!
    var doneShoppingBarButtonItem : UIBarButtonItem?

    
    // The view that tells the user how to add categories/sections to the table
    // It is only visible when the tableview is empty
    var getStartedView: HomeGetStartedView = {
        var view = HomeGetStartedView()
        view.translatesAutoresizingMaskIntoConstraints = false                          // Conforms to auto-layout
        view.backgroundColor = Constants.ColorPalette.Yellow.withAlphaComponent(0.7)
        view.isHidden = true                                                            // Instruction view is hidden unless the table view is empty
        
        return view
    }()
    
    
    
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - View Controller Delegate Methods
    /****************************************/
    /****************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        deleteAllCategories()
//        deleteAllItems()
        
        
        // Initialization
        setupView()                                 // Set up the view
        setupModels()                               // Set up the models
        
        // Save the height of the tab bar
        self.tabBarHeight = self.tabBarController!.tabBar.frame.height
        
        // Show/hide instructions
        toggleInstructions()
        
        // Print the location of the device's documents
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        // Listen for keyboard events that will adjust the view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Enable the keyboard hiding functionality
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.toggleDoneShoppingButton()
    }
    
    deinit {
        // Unregister for the keyboard notifications. Therefore, stop listening for the events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - Initialization Methods
    /****************************************/
    /****************************************/
    
    
    /// Adds the instruction view to the view controller and sets its constraints
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
    /// Called in setupView()
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
        self.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: homeCellReuseIdentifier)
        self.tableView.register(HomeTableviewHeader.self, forHeaderFooterViewReuseIdentifier: headerCellReuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Add tableview to the view
        self.view.addSubview(tableView)
        
        self.tableView.rowHeight = 65           // Set the cell row height
        
        tableView.keyboardDismissMode = .onDrag // Dismiss the keyboard when the user scrolls the table view
        
        tableView.separatorStyle = .none        // Remove cell seperators
    }
    

    
    /// Sets all visual settings of this view
    /// Called in viewDidLoad
    private func setupView() {
        // Customize navigation bar elements
        self.navigationItem.title = Constants.General.AppName
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableview()                        // Add the tableview

        setupGetStartedView()                   // Add instruction view
        
        setupNavItems()                         // Add navigation bar buttons
        
        self.view.backgroundColor = .white      // Set background color
    }
    
    
    /// Purpose: Sets up all the models
    /// Called in viewDidLoad
    private func setupModels() {
        loadCategoriesFromContext()     // Load the categories
        loadItemsFromContext()          // Load the items
    }
    
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - My Methods
    /****************************************/
    /****************************************/
    
    /// Checks a certain Category for dummy cells
    ///
    /// - Parameter categoryIndex: The index (Section) of the Category we are validating
    /// - Returns: True if there is a dummy cell, false otherwise
    func categoryHasDummy(categoryIndex: Int) -> Bool {
        if let _ = self.items[categoryIndex].first(where: {$0.name == ""}) {
            return true
        } else {
            self.categories[categoryIndex].hasDummy = false         // Set the dummy indicator to false
            return false
        }
    }
    
    
    /// 1) Checks the category entities loaded from Core Data
    /// 2) Filters the options displayed in the action sheet when the user wants to add a category
    ///
    /// - Returns: A String array of the categories that AREN'T in use
    func validateCategories() -> [String] {
        // Initialize the result to the full list of default categories
        var result : [String] = defaultCategories
        
        // Go through them and remove the categories that already exist
        for i in defaultCategories {
            // If the category exists in tableview array...
            if let existingCategory = categories.first(where: {$0.name == i}) {
                print("default category: \(i) matches categories array: \(existingCategory.name!)")
                // then filter it out of the result
                result.remove(at: result.firstIndex(of: i)!)
            }
        }
        
        // Return the modified array of Categories that are not in use
        return result
    }
    
    
    /// Displays or hides the get started pop up depending on whether there are categories in the tableview
    /// This method is called in viewDidLoad and whenever the user adds/removes a category
    func toggleInstructions() {
        // If there are no visible cells in the tableview, category array and item array is empty
        // Display the get started view
        if tableView.visibleCells.isEmpty && categories.count <= 0 && items.count <= 0 {
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
    
    
    func toggleDoneShoppingButton() {
        for x in 0 ..< self.categories.count {
            for y in 0 ..< self.items[x].count {
                if self.items[x][y].completed {
                    self.doneShoppingBarButtonItem?.isEnabled = true
                    return
                }
            }
        }
        
        self.doneShoppingBarButtonItem?.isEnabled = false
    }
    
    /****************************************/
    /****************************************/
    //MARK: - General Core Data Methods
    /****************************************/
    /****************************************/
    
    /// Saves the current working data to the Data Model
    func saveContext() {
        coreDataManager.saveContext()           // Go to Data Model and save context
        self.tableView.reloadData()             // Update the view
    }
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - Category Core Data Methods
    /****************************************/
    /****************************************/
    
    /// Loads the Categories from Data Model
    private func loadCategoriesFromContext() {
        categories = coreDataManager.loadCategories()   // Make a request to fetch the Category entities in the database
    }
    
    /// Adds a Category to the Data Model and the Table View
    ///
    /// - Parameter categoryName: The title of the Category entity
    func addCategory(categoryName: String) {
        if !categoryExists(categoryName: categoryName) {
            // Get the new Category created
            if let newCategory = coreDataManager.addCategory(categoryName: categoryName) {
                // Add new category to table View's array
                self.categories.append(newCategory)
                self.items.append([])
                
                toggleInstructions()
            }
        }
    }
    
    /// Deletes a Category entity
    ///
    /// - Parameter categoryName: The title of the Category entity
    func deleteCategory(categoryName: String) {
        coreDataManager.deleteCategory(categoryName: categoryName)
        toggleInstructions()
    }
    
    /// Deletes all Category entities from the Data Model
    /// !!! ONLY TO BE USED FOR TESTING !!!
    private func deleteAllCategories() {
        coreDataManager.deleteAllCategories()
        tableView.reloadData()
    }
    
    /// Checks if a Category exists in the Data Model
    ///
    /// - Parameter categoryName: Title of Category entity
    /// - Returns: A boolean of whether the Category with that title exists
    func categoryExists(categoryName: String) -> Bool {
        return coreDataManager.categoryExists(categoryName: categoryName)
    }
    
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - Item Core Data Methods
    /****************************************/
    /****************************************/
    
    /// Adds an Item to the Data Model and the Table View
    ///
    /// - Parameters:
    ///   - name: Title of the Item entity
    ///   - category: The Category entity the Item relates to
    /// Make a fetch request for each Item entity related to the Category entities
    private func loadItemsFromContext() {
        let requestItems: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Cycle through the categories and load all the items related to each Category entity
        for index in 0..<categories.count {
            // Predicate = all items in this category
            let itemPredicate = NSPredicate(format: "ANY category.name in %@", [categories[index].name])
            requestItems.predicate = itemPredicate
            
            // Instantiate the items tableView array with the loaded Item entities
            items.append(coreDataManager.fetchItems(request: requestItems))
            
            guard let _ = items[index].first(where: {$0.cellType == Constants.CellType.DummyCell}) else {
                // Add a placeholder cell to the category if it doesn't have one already
                addPlaceHolderCell(toCategory: categories[index])
                
                // Go to the next category index in the for loop
                continue
            }
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
        
        let categoryIndex = categories.firstIndex(of: category)                             // Grab the index of the Category entity we are working in
        
        let newDummyItem: Item = coreDataManager.addItem(toCategory: category, withItemName: "",
                                                         cellType: Constants.CellType.DummyCell) // Create a new dummmy Item entity
        items[categoryIndex!].append(newDummyItem)                                          // Add the dummy entity to our tableView array
        
        let itemIndex = self.items[categoryIndex!].count-1                                  // Get the index of the dummy Item we just added to our tableView array
        
        let indexPath: IndexPath = IndexPath(row: itemIndex, section: categoryIndex!)       // Set the indexPath
        self.tableView.insertRows(at: [indexPath], with: .bottom)                           // Finally add it to our visible tableview
        
        // Toggle off tableview updating
        self.tableView.endUpdates()
    }
    
    
    
    /// Adds a new Item entity to the specified Category
    ///
    /// - Parameters:
    ///   - name: The name of the Item
    ///   - category: The Category entity
    ///   - cellType: Used to distinguish between dummy placeholder cells and real ones
    func add(itemName name:String, toCategory category: Category, type cellType: String) {
        let index = categories.firstIndex(of: category)!        // Get the index of the Category we are adding to
        let newItem = coreDataManager.addItem(toCategory: category, withItemName: name, cellType: cellType)
        
        items[index].append(newItem)                            // Add to items tableview array
    }
    
    
    /// Deletes an Item from the Data Model and the Table View
    ///
    /// - Parameter itemName: The title of the Item entity
    func deleteItem(itemId: String, categoryName: String) {
        coreDataManager.deleteItem(itemId: itemId, categoryName: categoryName)
        tableView.reloadData()
    }
    
    
    /// Delete all Item entities from Core Data model
    /// !!! ONLY TO BE USED FOR TESTING !!!
    private func deleteAllItems() {
        coreDataManager.deleteAllItems()
        tableView.reloadData()
    }
}



