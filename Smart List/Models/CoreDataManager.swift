//
//  CoreDataManager.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    /****************************************/
    /****************************************/
    // MARK: - Variables
    /****************************************/
    /****************************************/
    static let shared = CoreDataManager()
    private init() {} // Prevents creation of another instances
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    /// Saves the current working data to the Data Model
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - Categories in Core Data
    /****************************************/
    /****************************************/
    
    
    /// Loads the categories that are saved in Core Data
    ///
    /// - Returns: An array of all the Category entities
    func loadCategories() -> [Category] {
        var result: [Category] = []
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            result = try context.fetch(request)
        } catch {
            print("Error loading categories from context: \(error)")
        }
        
        return result
    }
    
    
    /// Adds a category entity to the Data Model and saves the context
    ///
    /// - Parameter categoryName: The title of the Category
    /// - Returns: Returns an optional Category entity if it doesn't already exist in the Data Model
    func addCategory(categoryName: String) -> Category? {
        if !categoryExists(categoryName: categoryName) {
            // Create new category
            let newCategory = Category(context: context)
            newCategory.name = categoryName
            newCategory.hasDummy = false
            saveContext()
            
            return newCategory
        }
        
        return nil
    }
    
    
    /// Deletes a Category entity from Data Model and saves the context
    ///
    /// - Parameter categoryName: The title of the Category entity
    func deleteCategory(categoryName: String) {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", categoryName)
        let results: [Category] = try! context.fetch(fetchRequest)
        
        for obj in results {
            context.delete(obj)
        }
        
        saveContext()
    }
    
    func deleteAllCategories() {
        let deleteFetch: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("There was an error deleting all Categories: \(error)")
        }
    }
    
    
    /// Checks if a Category entity exists in the Data Model
    ///
    /// - Parameter categoryName: The title of the Category
    /// - Returns: A boolean if the Category title is found in the Data Model
    func categoryExists(categoryName: String) -> Bool {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let predicate = NSPredicate(format: "name ==[cd] %@", categoryName)
        fetchRequest.predicate = predicate
        
        var results: [Category] = []
        
        do {
            results = try context.fetch(fetchRequest)
        } catch {
            print("Error checking if category \'\(categoryName)\' exists: \(error)")
        }
        
        return results.count > 0
    }
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - Items in Core Data
    /****************************************/
    /****************************************/
    
    /// Loads the Item entities saved in Data Model based on a Category title query
    ///
    /// - Parameter request: The fetch request for Item entity
    /// - Returns: An array of Item entities
    func fetchItems(request: NSFetchRequest<Item>) -> [Item] {
        var result: [Item] = []
        
        do {
            result = try context.fetch(request)
        } catch {
            print("Error fetching items: \(error)")
        }
        
        return result
    }
    
    
    /// Queries the Core Data database for Items that have been completed
    ///
    /// - Returns: an array of Items that have been completed
    func fetchCompletedItems() -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "completed == %@", NSNumber(booleanLiteral: true))  // predicate looks for completed attribute to be true
        let results : [Item] = try! context.fetch(fetchRequest)
        
        return results
    }
    
    
    
    /// Accesses Core Data and gets all the Kitchen Item entities
    ///
    /// - Returns: A [KitchenItem] of Items that have been completed (aka purchased)
    func fetchKitchenItems() -> [KitchenItem] {
        var result: [KitchenItem] = []
        
        let request: NSFetchRequest<KitchenItem> = KitchenItem.fetchRequest()
        
        do {
            result = try context.fetch(request)
        } catch {
            print("Error loading Kitchen Items from context: \(error)")
        }
        
        return result
    }
    
    
    /// Takes an Item from the list when the user swipes 'Done' and adds it to the KitchenItem entity table
    ///
    /// - Parameter item: The Item that the user just completed (aka just purchased)
    func addKitchenItem(item: Item) {
        let newItem = KitchenItem(context: context)                             // Create new Kitchen Item
        newItem.completed = item.completed
        newItem.expiryDate = item.expiryDate
        newItem.id = item.id
        newItem.imageName = item.imageName
        newItem.isExpired = item.isExpired
        newItem.name = item.name                                                // Set the properties...
        newItem.notes = item.notes
        newItem.purchaseDate = item.purchaseDate
        newItem.quantity = item.quantity
        newItem.store = item.store
        
        saveContext()                                                           // Save context
    }
    
    
    /// Add an Item entity to the Data Model and save the context
    ///
    /// - Parameters:
    ///   - category: The Category entity we want the Item to relate to
    ///   - name: The title of the Item entity
    /// - Returns: The new Item entity to be added to the Table View
    func addItem(toCategory category: Category, withItemName name: String, cellType: String) -> Item {
        let newItem = Item(context: context)                                    // Create new Item
        newItem.name = name                                                     // Set the name
        newItem.cellType = cellType                                             // Set the type to a real or dummy cell
        category.addToItems(newItem)                                            // Create relationship with appropriate Category
        saveContext()                                                           // Save context
        
        newItem.id = newItem.objectID.uriRepresentation().absoluteString        // Set the ID *AFTER* saving (because new core data objects have a temp objectID until context is saved)
        saveContext()                                                           // Save the Item with the new objectID
        
        return newItem
    }
    
    
    /// Delete an Item entity from the Data Model and save the context
    ///
    /// - Parameter itemName: The title of the Item entity
    func deleteItem(itemId: String, categoryName: String) {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@ && category.name = %@", String(itemId), categoryName)
        let results: [Item] = try! context.fetch(fetchRequest)
        
        for obj in results {
            context.delete(obj)
        }
        
        saveContext()
    }
    
    
    /// Deletes all the Item entities saved to the device's Core Data DB
    func deleteAllItems() {
        let deleteFetch: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")          // Get the "Item" entity column
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)                                 // Create the request
        
        // Try to delete all Item entities
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("There was an error deleting all Items: \(error)")
        }
    }
}
