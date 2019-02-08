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


class HomeViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    /****************************************/
    /****************************************/
    //MARK: - Variables
    /****************************************/
    /****************************************/
    // Core Data Manager (Singleton)
    let coreDataManager = CoreDataManager.shared
    
    //MARK: - Constants
    let homeCellReuseIdentifier: String = Constants.CellID.HomeTableViewCellID
    let headerCellReuseIdentifier: String = Constants.CellID.HomeHeaderID
    
    //MARK: - Variables
    var categories: [Category] = []
    var items: [[Item]] = [[],[],[],[],[],[],[]]
    
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - View Methods
    /****************************************/
    /****************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register our cell to the tableview
        self.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: homeCellReuseIdentifier)
        self.tableView.register(HomeTableviewHeader.self, forHeaderFooterViewReuseIdentifier: headerCellReuseIdentifier)
        
        // Initialization
        setupView() // Set up the view
        setupModels() // Set up the models
        deleteAllCategories()
        // Print the location of the simulator's documents
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - My Methods
    /****************************************/
    /****************************************/
    
    // Purpose: Sets up all the view elements of the list page
    // Called in viewDidLoad
    
    /// Sets all visual settings of this view
    private func setupView() {
        // Customize navigation bar elements
        self.navigationItem.title = "App Name"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add plus button to navigation bar to allow the user to add catogories
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        // Set background color
        self.view.backgroundColor = .white
        
        // Set the cell row height
        self.tableView.rowHeight = 50
        
        // Dismiss the keyboard when the user drags the table
        tableView.keyboardDismissMode = .interactive
        
        // Remove cell seperators
        tableView.separatorStyle = .none
    }
    
    
    
    
    /// Purpose: Sets up all the models
    /// Called in viewDidLoad
    private func setupModels() {
        loadCategoriesFromContext() // Load the categories
        loadItemsFromContext() // Load the items
    }
    
    
    /// Checks a certain Category for dummy cells
    ///
    /// - Parameter categoryIndex: The index (Section) of the Category we are validating
    /// - Returns: True if there is a dummy cell, false otherwise
    func categoryHasDummy(categoryIndex: Int) -> Bool {
        if let _ = self.items[categoryIndex].first(where: {$0.name == ""}) {
            return true
        } else {
            self.categories[categoryIndex].hasDummy = false // Set the dummy indicator to false
            return false
        }
    }
    
    /// Purpose: This method is called when the user taps on the + sign at the top right
    ///
    /// Allows the user to add a category to the TableView
    /// They are presented with a list of options, one of them being an option to add their own
    @objc func addButtonTapped() {
        // Create the alert controller
        let alert = UIAlertController(title: "New category", message: "Which category would you like to create?", preferredStyle: .actionSheet)
        
        
        // Add the different options for the user
        alert.addAction(UIAlertAction(title: "Produce", style: .default, handler:{ (UIAlertAction) in
            print("User selected Produce")
            
            self.tableView.beginUpdates()
            
            self.addCategory(categoryName: Constants.DefaultCategories.Produce) // Add the Category entity to Core Data
            self.tableView.insertSections(NSIndexSet(index: self.categories.count - 1) as IndexSet, with: .bottom) // Insert the Category section into the table view
            self.addPlaceHolderCell(toCategory: self.categories[self.categories.count-1]) // Insert the dummy cell into the new Category
            
            self.tableView.endUpdates()
            // Scroll to the category the user just added
            let indexPath = IndexPath(row: 0, section: self.categories.count-1)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Bakery", style: .default, handler:{ (UIAlertAction) in
            print("User selected Bakery")
            self.tableView.beginUpdates()
            
            self.addCategory(categoryName: Constants.DefaultCategories.Bakery) // Add the Category entity to Core Data
            self.tableView.insertSections(NSIndexSet(index: self.categories.count - 1) as IndexSet, with: .bottom) // Insert the Category section into the table view
            self.addPlaceHolderCell(toCategory: self.categories[self.categories.count-1]) // Insert the dummy cell into the new Category
            
            self.tableView.endUpdates()
            // Scroll to the category the user just added
            let indexPath = IndexPath(row: 0, section: self.categories.count-1)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Meat/Seafood", style: .default, handler:{ (UIAlertAction) in
            print("User selected Meat")
            self.tableView.beginUpdates()
            
            self.addCategory(categoryName: Constants.DefaultCategories.MeatSeafood) // Add the Category entity to Core Data
            self.tableView.insertSections(NSIndexSet(index: self.categories.count - 1) as IndexSet, with: .bottom) // Insert the Category section into the table view
            self.addPlaceHolderCell(toCategory: self.categories[self.categories.count-1]) // Insert the dummy cell into the new Category
            
            self.tableView.endUpdates()
            // Scroll to the category the user just added
            let indexPath = IndexPath(row: 0, section: self.categories.count-1)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Dairy", style: .default, handler:{ (UIAlertAction) in
            print("User selected Dairy")
            self.tableView.beginUpdates()
            
            self.addCategory(categoryName: Constants.DefaultCategories.Dairy) // Add the Category entity to Core Data
            self.tableView.insertSections(NSIndexSet(index: self.categories.count - 1) as IndexSet, with: .bottom) // Insert the Category section into the table view
            self.addPlaceHolderCell(toCategory: self.categories[self.categories.count-1]) // Insert the dummy cell into the new Category
            
            self.tableView.endUpdates()
            // Scroll to the category the user just added
            let indexPath = IndexPath(row: 0, section: self.categories.count-1)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Packaged/Canned", style: .default, handler:{ (UIAlertAction) in
            print("User selected Packaged")
            self.tableView.beginUpdates()
            
            self.addCategory(categoryName: Constants.DefaultCategories.PackagedCanned) // Add the Category entity to Core Data
            self.tableView.insertSections(NSIndexSet(index: self.categories.count - 1) as IndexSet, with: .bottom) // Insert the Category section into the table view
            self.addPlaceHolderCell(toCategory: self.categories[self.categories.count-1]) // Insert the dummy cell into the new Category
            
            self.tableView.endUpdates()
            // Scroll to the category the user just added
            let indexPath = IndexPath(row: 0, section: self.categories.count-1)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Frozen", style: .default, handler:{ (UIAlertAction) in
            print("User selected Frozen")
            self.tableView.beginUpdates()
            
            self.addCategory(categoryName: Constants.DefaultCategories.Frozen) // Add the Category entity to Core Data
            self.tableView.insertSections(NSIndexSet(index: self.categories.count - 1) as IndexSet, with: .bottom) // Insert the Category section into the table view
            self.addPlaceHolderCell(toCategory: self.categories[self.categories.count-1]) // Insert the dummy cell into the new Category
            
            self.tableView.endUpdates()
            
            // Scroll to the category the user just added
            let indexPath = IndexPath(row: 0, section: self.categories.count-1)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Create my own", style: .default, handler:{ (UIAlertAction) in
            print("User selected Custom")
            // Create another alert that allows the user to type a name for their category
            let customAlert = UIAlertController(title: "Title", message: "Enter the name of your category", preferredStyle: .alert)
            customAlert.addTextField { (textField) in
                textField.placeholder = "Category name"
            }
            
            customAlert.addAction(UIKit.UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                let textField = customAlert.textFields![0]
                print("The text the user entered: \(textField.text!)")
            }))
            
            // Lets the user go back to the previous action sheet that lets them choose a category
            customAlert.addAction(UIKit.UIAlertAction(title: "Go back", style: .cancel, handler: {(UIAlertAction) in
                self.present(alert, animated: true, completion: nil)
            }))
            
            self.present(customAlert, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(UIAlertAction) in
            print("User cancelled selection")
        }))
        
        
        // Display the Alert Controller
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        

    }
    
    /****************************************/
    /****************************************/
    //MARK: - General Core Data Methods
    /****************************************/
    /****************************************/
    
    /// Saves the current working data to the Data Model
    func saveContext() {
        coreDataManager.saveContext() // Go to Data Model and save context
        self.tableView.reloadData() // Update the view
    }
    
    /****************************************/
    /****************************************/
    //MARK: - Category Core Data Methods
    /****************************************/
    /****************************************/
    
    /// Loads the Categories from Data Model
    private func loadCategoriesFromContext() {
        categories = coreDataManager.loadCategories() // Make a request to fetch the Category entities in the database
    }
    
    /// Adds a Category to the Data Model and the Table View
    ///
    /// - Parameter categoryName: The title of the Category entity
    private func addCategory(categoryName: String) {
        if !categoryExists(categoryName: categoryName) {
            // Get the new Category created
            if let newCategory = coreDataManager.addCategory(categoryName: categoryName) {
                // Add new category to table View's array
                self.categories.append(newCategory)
            }
        }
    }
    
    /// Deletes a Category entity
    ///
    /// - Parameter categoryName: The title of the Category entity
    private func deleteCategory(categoryName: String) {
        coreDataManager.deleteCategory(categoryName: categoryName)
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
            items[index] = coreDataManager.fetchItems(request: requestItems)
            
            guard let _ = items[index].first(where: {$0.cellType == Constants.CellType.DummyCell}) else {
                // Add a placeholder cell to the category if it doesn't have one already
                addPlaceHolderCell(toCategory: categories[index])
                
                // Go to the next category index in the for loop
                continue
            }
        }
    }
    
    func addPlaceHolderCell(toCategory category: Category) {
        self.tableView.beginUpdates()
        
        let categoryIndex = categories.firstIndex(of: category) // Grab the index of the Category entity we are working in
        
        let newDummyItem: Item = coreDataManager.addItem(toCategory: category, withItemName: "", cellType: Constants.CellType.DummyCell) // Create a new dummmy Item entity
        items[categoryIndex!].append(newDummyItem) // Add the dummy entity to our tableView array
        
        let itemIndex = self.items[categoryIndex!].count-1 // Get the index of the dummy Item we just added to our tableView array
        
        let indexPath: IndexPath = IndexPath(row: itemIndex, section: categoryIndex!) // Set the indexPath
        self.tableView.insertRows(at: [indexPath], with: .bottom)
        
        self.tableView.endUpdates()
    }
    
    func add(itemName name:String, toCategory category: Category, type cellType: String) {
        let index = categories.firstIndex(of: category)! // Get the index of the Category we are adding to
        let newItem = coreDataManager.addItem(toCategory: category, withItemName: name, cellType: cellType)
        
        items[index].append(newItem) // Add to items tableview array
    }
    
    
    /// Deletes an Item from the Data Model and the Table View
    ///
    /// - Parameter itemName: The title of the Item entity
    func deleteItem(itemName: String) {
        coreDataManager.deleteItem(itemName: itemName)
        tableView.reloadData()
    }
    
    
    /// Delete all Item entities from Core Data model
    /// !!! ONLY TO BE USED FOR TESTING !!!
    private func deleteAllItems() {
        coreDataManager.deleteAllItems()
        tableView.reloadData()
    }
}
