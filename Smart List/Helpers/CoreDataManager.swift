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
    private init() {} // Prevents creationg of another instance
    
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
    
    /**
     - Description: Loads the categories that are saved in Core Data
     
     - returns: An array of all the Category entities
    */
    
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
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", categoryName)
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
    func fetchItems(request: NSFetchRequest<Item>)-> [Item] {
        var result: [Item] = []
        
        do {
            result = try context.fetch(request)
        } catch {
            print("Error fetching items: \(error)")
        }
        
        return result
    }
    
    
    /// Add an Item entity to the Data Model and save the context
    ///
    /// - Parameters:
    ///   - category: The Category entity we want the Item to relate to
    ///   - name: The title of the Item entity
    /// - Returns: The new Item entity to be added to the Table View
    func addItem(toCategory category: Category, withItemName name: String, cellType: String) -> Item {
        let newItem = Item(context: context) // Create new Item
        newItem.name = name // Set the name
        newItem.cellType = cellType // Set the type to a real or dummy cell
        category.addToItems(newItem) // Create relationship with appropriate Category
        saveContext()
        
        return newItem
    }
    
    
    /// Delete an Item entity from the Data Model and save the context
    ///
    /// - Parameter itemName: The title of the Item entity
    func deleteItem(itemName: String) {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", itemName)
        let results: [Item] = try! context.fetch(fetchRequest)
        
        for obj in results {
            context.delete(obj)
        }
        
        saveContext()
    }
    
    func deleteAllItems() {
        let deleteFetch: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("There was an error deleting all Items: \(error)")
        }
    }
}
