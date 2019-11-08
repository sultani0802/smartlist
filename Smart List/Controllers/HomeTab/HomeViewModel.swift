//
//  HomeViewModel.swift
//  Smart List
//
//  Created by Haamed Sultani on Sep/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation
import CoreData

struct DefaultCategories {
	static let Produce =            "Produce"
	static let Bakery =             "Bakery"
	static let MeatSeafood =        "Meat/Seafood"
	static let Dairy =              "Dairy"
	static let PackagedCanned =     "Packaged/Canned"
	static let Frozen =             "Frozen"
}

struct CellType {
	static let ValidCell = "valid"
	static let DummyCell = "dummy"
}

class HomeViewModel {
    // MARK: - Constants
    let coreData : CoreDataManager
    let homeCellReuseIdentifier: String = Constants.ReuseIdentifier.HomeTableViewCellID
    let headerCellReuseIdentifier: String = Constants.ReuseIdentifier.HomeHeaderID
    
    init(coreDataManager : CoreDataManager) {
        self.coreData = coreDataManager     // Dependency injection for core data manager
    }
    
    
    // MARK: - TableView Datasource
    let defaultCategories : [String] = [
        DefaultCategories.Produce,
        DefaultCategories.Bakery,
        DefaultCategories.MeatSeafood,
        DefaultCategories.Dairy,
        DefaultCategories.PackagedCanned,
        DefaultCategories.Frozen
    ]
    
    var categories: [Category] = [Category]()
    var items: [[Item]] = [[Item]]()
    var numberOfCompletedItems : Int = 0            // Used to determine when to display "Unload" nav bar item
    
    
    
    // MARK: - Model Methods
    
    /// Checks a certain Category for dummy cells
    ///
    /// - Parameter categoryIndex: The index (Section) of the Category we are validating
    /// - Returns: True if there is a dummy cell, false otherwise
    func categoryHasDummy(categoryIndex: Int) -> Bool {
        if let _ = items[categoryIndex].first(where: {$0.name == ""}) {
            return true
        } else {
            categories[categoryIndex].hasDummy = false         // Set the dummy indicator to false
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
            if let _ = categories.first(where: {$0.name == i}) {
                // then filter it out of the result
                result.remove(at: result.firstIndex(of: i)!)
            }
        }
        
        // Return the modified array of Categories that are not in use
        return result
    }
    
    
    /// Traverses through items and counts the number of completed items
    func countNumberOfCompletedItems() {
        numberOfCompletedItems = 0
        
        for i in 0 ..< categories.count {
            for j in 0 ..< items[i].count {
                if items[i][j].completed {
                    numberOfCompletedItems += 1
                }
            }
        }
    }
    
    
    // MARK - Core Data Methods
    
    /// Purpose: Sets up all the models
    /// Called in viewDidLoad()
    func loadModels() {
        loadCategoriesFromContext()     // Load the categories
        loadItemsFromContext()          // Load the items
        countNumberOfCompletedItems()
    }
    
    /// Loads the Categories from Data Model
    private func loadCategoriesFromContext() {
        categories = coreData.loadCategories()   // Make a request to fetch the Category entities in the database
    }
    
    /// Adds a Category to the Data Model and the Table View
    ///
    /// - Parameter categoryName: The title of the Category entity
    func addCategory(categoryName: String) -> Bool {
        if !categoryExists(categoryName: categoryName) {
            // Get the new Category created
            if let newCategory = coreData.addCategory(categoryName: categoryName) {
                // Add new category to table View's array
                self.categories.append(newCategory)
                self.items.append([])
                
                return true
            }
        }
        
        return false
    }
    
    
    /// Deletes a Category entity
    ///
    /// - Parameter categoryName: The title of the Category entity
    func deleteCategory(categoryName: String) {
        coreData.deleteCategory(categoryName: categoryName)
    }
    
    /// Deletes all Category entities from the Data Model
    /// !!! ONLY TO BE USED FOR TESTING !!!
    private func deleteAllCategories() {
        coreData.deleteAllCategories()
    }
    
    /// Checks if a Category exists in the Data Model
    ///
    /// - Parameter categoryName: Title of Category entity
    /// - Returns: A boolean of whether the Category with that title exists
    func categoryExists(categoryName: String) -> Bool {
        return coreData.categoryExists(categoryName: categoryName)
    }
    
    
    func loadItemsFromContext() {
        let requestItems: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Cycle through the categories and load all the items related to each Category entity
        for index in 0 ..< categories.count {
            // Predicate = all items in this category
            let itemPredicate = NSPredicate(format: "ANY category.name in %@", [categories[index].name])
            requestItems.predicate = itemPredicate
            
            // Instantiate the items datasource array with the loaded Item entities
            items.append(coreData.fetchItems(request: requestItems))
        }
    }
    
    /// Adds a new Item entity to the specified Category
    ///
    /// - Parameters:
    ///   - name: The name of the Item
    ///   - category: The Category entity
    ///   - cellType: Used to distinguish between dummy placeholder cells and real ones
    func add(itemName name:String, toCategory category: Category, type cellType: String) {
        let index = categories.firstIndex(of: category)!        // Get the index of the Category we are adding to
        let newItem = coreData.addItem(toCategory: category, withItemName: name, cellType: cellType)
        
        items[index].append(newItem)                            // Add to items tableview array
    }
    
    /// Deletes an Item from the Data Model and the Table View
    ///
    /// - Parameter itemName: The title of the Item entity
    func deleteItem(itemId: String, categoryName: String) {
        coreData.deleteItem(itemId: itemId, categoryName: categoryName)
    }
    
    
    /// Delete all Item entities from Core Data model
    /// !!! ONLY TO BE USED FOR TESTING !!!
    private func deleteAllItems() {
        coreData.deleteAllItems()
    }
}
