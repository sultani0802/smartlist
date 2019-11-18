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
    // MARK: - Properties
    /****************************************/
    /****************************************/
	
	let persistentContainer : NSPersistentContainer!
	lazy var backgroundContext : NSManagedObjectContext = {			// This var is used to save context using background thread
		return self.persistentContainer.newBackgroundContext()
	}()
	
	
	/****************************************/
	/****************************************/
	// MARK: - Initialization
	/****************************************/
	/****************************************/
	
	// Init with Dependency
	public init(container: NSPersistentContainer) {
		self.persistentContainer = container
		self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
	}
	
	// Initializer will instantiate persistentContainer from appDelegate
	convenience init() {
		// Use default container for production environment
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			fatalError("Could not get shared app delegate within CoreDataManager")
		}
		
		self.init(container: appDelegate.persistentContainer)
	}
	
	
	
	
    /// Saves the current working data to the Data Model
    func saveContext() {
		if backgroundContext.hasChanges {
			print("has changes")
			do {
				try backgroundContext.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
    }
    
    
    
    /****************************************/
    /****************************************/
    //MARK: - Settings Entity
    /****************************************/
    /****************************************/

	
	/// Fetches Settings entity from Core Data
	/// - Returns: Settings Entity
//    func loadSettings() -> Settings {
//        // Will be instantiated to the result of the fetch request
//		var result : [Settings]?
//
//        let request : NSFetchRequest<Settings> = Settings.fetchRequest()
//
//        do {
//            result = try backgroundContext.fetch(request)
//        } catch {
//            print("Error loading Settings from core date: \(error)")
//        }
//
//
//        if result == nil || result!.count == 0 {
//			// Initialize a new Settings entity if one doesn't exist already
//			return createSettingsEntity()
//		} else {
//			// Return the settings entity
//			return result![0]
//		}
//    }
//
//	/// Creates a new Settings Entity
//	func createSettingsEntity() -> Settings {
//
//
//
//		let newSettings = Settings(context: self.backgroundContext)		// Init Settings entity
//		newSettings.kitchenTableViewSort = KitchenSorter.date.rawValue			// Set the Kitchen Collection View to be sorted by expiry date
//		saveContext()
//
//		return newSettings
//	}
//
//
//    /// If the user chooses to skip sign up or log in then they will be in offline mode
//    /// Therfore, we clear any online properties such as name, email, auth token, and set their logged in status to false
//    ///
//    /// - Parameter offlineMode: The boolean flag that will determine whether the user is offline or not
//    func setOfflineMode(offlineMode: Bool) {
//        let settings = loadSettings()           // Get settings core data object
//
//        if (offlineMode == true ) {            // Clear all online properties and set to offline
//            settings.offlineMode = true
//            settings.isLoggedIn = false
//            settings.email = ""
//            settings.name = ""
//            settings.token = ""
//
//            saveContext()
//
//            print("User has gone offline.")
//        } else {                                // Otherwise, don't change anything but set offline to false
//            settings.offlineMode = false
//
//            saveContext()
//        }
//    }
//
//    /// Sets the user's name and email for their profile
//    ///
//    /// - Parameters:
//    ///   - name: User's name they set when they sign up/sign in
//    ///   - email: User's email they set when they sign up/sign in
//    func addUser(name: String, email: String, token: String) {
//        let settings = loadSettings()   // Load settings object
//
//        // Set properties in Core Data
//        if name != "" {
//            settings.name = name        // Update user's name
//        }
//        if email != "" {                // Update user's email
//            settings.email = email
//        }
//        if token != "" {
//            settings.token = token      // Update auth token
//            settings.isLoggedIn = true  // Set logged in flag to true
//        }
//
//        settings.isLoggedIn = true      // Set logged-in flag to true
//        settings.offlineMode = false    // Set offline flag to false
//
//        saveContext()                   // Save settings object
//    }
//
//    func loadUser() -> [String: String] {
//        var user : [String:String] = [:]
//
//        let request : NSFetchRequest<Settings> = Settings.fetchRequest()
//
//        do {
//            let result = try backgroundContext.fetch(request)                 // Fetch the Settings object from Core Data
//            user["name"] = result[0].name                           // Grab name
//            user["email"] = result[0].email                         // Grab email
//        } catch {
//            print("Error loading Settings from context: \(error)")
//        }
//
//        return user                                                 // Return the user info
//    }
    
    /****************************************/
    /****************************************/
    //MARK: - Categories in Core Data
    /****************************************/
    /****************************************/
    
    
    /// Loads the Shopping List tab categories that are saved in Core Data
    ///
    /// - Returns: An array of all the Category objects
    func loadCategoriesForShoppingList() -> [Category] {
        var result: [Category] = []
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            result = try backgroundContext.fetch(request)
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
			guard let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: backgroundContext) as? Category else {
				print("ERROR: Could not create new Category entity: \(categoryName)")
				return nil
			}
			
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
        let results: [Category] = try! backgroundContext.fetch(fetchRequest)
        
        for obj in results {
            backgroundContext.delete(obj)
        }
        
        saveContext()
    }
    
	
	/// Deletes all Category entities from Core Data
    func deleteAllCategories() {
        let deleteFetch: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try backgroundContext.execute(deleteRequest)
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
            results = try backgroundContext.fetch(fetchRequest)
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
    
    /// Loads the Item entities saved in Data Model based on a Category name
    ///
    /// - Parameter categoryName: The name of the Category you want to find Items for
    /// - Returns: An array of Item entities in the given Category
	func fetchItems(categoryName: String) -> [Item] {
		// Instantiate an array that will be returned to the user
		var result: [Item] = []
		// Fetch Request Items
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		// Any Item with a relationship to the Category passed in
		let itemPredicate = NSPredicate(format: "ANY category.name in %@", [categoryName])	// Predicate requires an array of Strings for the predicate
		request.predicate = itemPredicate
		
		do {
			result = try backgroundContext.fetch(request)
		} catch {
			print("Error fetching items: \(error)")
		}
		
		return result
	}
    
    
    /// Queries the Core Data database for Items that have been completed
    ///
    /// - Returns: an array of Items that have been completed
    func fetchCompletedItems() -> [Item] {
		var result : [Item] = []
		let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
		// Predicate for fetch request to find Items with completed boolean = true
        fetchRequest.predicate = NSPredicate(format: "completed == %@", NSNumber(booleanLiteral: true))
        
		do {
			result = try backgroundContext.fetch(fetchRequest)
		} catch {
			print("Error fetching Completed Items")
		}
		
        
        return result
    }
    
    
    
    /// Fetches all the Kitchen Item entities
    ///
    /// - Returns: A [KitchenItem] that have been completed (aka purchased)
    func fetchKitchenItems() -> [KitchenItem] {
        var result: [KitchenItem] = []
        
        let request: NSFetchRequest<KitchenItem> = KitchenItem.fetchRequest()
        
        do {
            result = try backgroundContext.fetch(request)
        } catch {
            print("Error loading Kitchen Items from context: \(error)")
        }
        
        return result
    }
    
    
    /// Fetches Kitchen Items with a sort descriptor
    ///
	///	> **Example Usage**
	///	```
	///	collectionView.datasourceArray = fetchKitchenItemsSorted(by .date)
	///	```
    /// - Parameter by: flag used to determine what KitchenItem attribute to sort by
    /// - Returns: The KitchenItems sorted by KitchenItem.name or KitchenItem.expiryDate
	func fetchKitchenItemsSorted(by sorter: KitchenSorter, onlyExpired : Bool = false) -> [KitchenItem] {
        var results : [KitchenItem] = []
        var sort : NSSortDescriptor
        let request: NSFetchRequest<KitchenItem> = NSFetchRequest<KitchenItem>(entityName: "KitchenItem")
		
		// If isExpired flag is true, filter fetch result to only expired KitchenItems
//		if (onlyExpired) {
//			request.predicate = NSPredicate(format: "isExpired == %@", NSNumber(booleanLiteral: true))
//		}
		
		switch (sorter) {
			case .date:
				sort = NSSortDescriptor(key: "expiryDate", ascending: true)         // Sort by date
			case .name:
				sort = NSSortDescriptor(key: "name", ascending: true)               // Sort by name
		}
		
		// Add the sort to the fetch request
        request.sortDescriptors = [sort]
        
        do {
            results = try backgroundContext.fetch(request)
        } catch {
            print("Error fetching sorted Kitchen Items from context: \(error)")
        }
        
        return results
    }
    
    
    /// Takes an Item from the list when the user swipes 'Done' and adds it to the KitchenItem entity table
    ///
    /// - Parameter item: The Item that the user just completed (aka just purchased)
    func addKitchenItem(item: Item) {
        let newItem = KitchenItem(context: backgroundContext)                             // Create new Kitchen Item
        newItem.completed = item.completed
        newItem.expiryDate = item.expiryDate
        newItem.id = item.id
        newItem.imageThumbURL = item.imageThumbURL
        newItem.imageFullURL = item.imageFullURL
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
        let newItem = Item(context: backgroundContext)                                    // Create new Item
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
        let results: [Item] = try! backgroundContext.fetch(fetchRequest)
        
        for obj in results {
            backgroundContext.delete(obj)
        }
        
        saveContext()
    }
    
    
    func deleteKitchenItem(item: KitchenItem) {
        let fetchRequest: NSFetchRequest<KitchenItem> = KitchenItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id!)
        let results : [KitchenItem] = try! backgroundContext.fetch(fetchRequest)
        
        for obj in results {
            print(obj)
            backgroundContext.delete(obj)
        }
        
        saveContext()
    }
    
    
    /// Deletes all the Item entities saved to the device's Core Data DB
    func deleteAllItems() {
        let deleteFetch: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")          // Get the "Item" entity column
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)                                 // Create the request
        
        // Try to delete all Item entities
        do {
            try backgroundContext.execute(deleteRequest)
            saveContext()
        } catch {
            print("There was an error deleting all Items: \(error)")
        }
    }
}

