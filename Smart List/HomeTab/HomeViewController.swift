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
    var defaultCategories : [String] = [
        Constants.DefaultCategories.Produce,
        Constants.DefaultCategories.Bakery,
        Constants.DefaultCategories.MeatSeafood,
        Constants.DefaultCategories.Dairy,
        Constants.DefaultCategories.PackagedCanned,
        Constants.DefaultCategories.Frozen
    ]
    
    var categories: [Category] = [Category]()
    var items: [[Item]] = [[Item]]()
    
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - View Methods
    /****************************************/
    /****************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleteAllCategories()

        // Register our cell to the tableview
        self.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: homeCellReuseIdentifier)
        self.tableView.register(HomeTableviewHeader.self, forHeaderFooterViewReuseIdentifier: headerCellReuseIdentifier)
        
        // Initialization
        setupView() // Set up the view
        setupModels() // Set up the models
        print(validateCategories())
        
        // Print the location of the device's documents
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonTapped))
        
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
    
    
    func validateCategories() -> [String] {
        var result : [String] = defaultCategories
        
        for i in defaultCategories {
            if let existingCategory = categories.first(where: {$0.name == i}) {
                print("default category: \(i) matches categories array: \(existingCategory.name!)")
                
                result.remove(at: result.firstIndex(of: i)!)
            }
        }
        
        return result
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
    func addCategory(categoryName: String) {
        if !categoryExists(categoryName: categoryName) {
            // Get the new Category created
            if let newCategory = coreDataManager.addCategory(categoryName: categoryName) {
                // Add new category to table View's array
                self.categories.append(newCategory)
                self.items.append([])
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
            //items[index] = coreDataManager.fetchItems(request: requestItems)
            items.append(coreDataManager.fetchItems(request: requestItems))
            
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
