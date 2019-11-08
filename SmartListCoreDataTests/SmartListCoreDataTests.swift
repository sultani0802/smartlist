//
//  SmartListCoreDataTests.swift
//  SmartListCoreDataTests
//
//  Created by Haamed Sultani on Oct/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import XCTest
import CoreData

@testable import Smart_List

class SmartListCoreDataTests: XCTestCase {
	
	var sut : CoreDataManager!
	
	// Init a Managed Object Model from test Bundle
	// MUST ADD THIS TEST FILE TO TARGETS LIST IN .xcdatamodeld file
	lazy var managedObjectModel : NSManagedObjectModel = {
		// Created the object model from the test Bundle
		let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
		
		return managedObjectModel
	}()
	
	lazy var mockPersistentContainer : NSPersistentContainer = {
		// Init Persistent Container with custom Managed Object Model
		// We have to assign it a managedObjectModel since we are in the test namespace
		let container = NSPersistentContainer(name: "DataModel", managedObjectModel: self.managedObjectModel)
		
		// Separate container in the test target from production persistent store
		let description = NSPersistentStoreDescription()
		description.type = NSInMemoryStoreType			// This persistent storage type gets wiped when you quit the app
		description.shouldAddStoreAsynchronously = false // Make it simpler in test env
		
		container.persistentStoreDescriptions = [description]
		container.loadPersistentStores { (description, error) in
			// Check if the data store is in memory
			precondition( description.type == NSInMemoryStoreType )
			
			// Check if creating container wrong
			if let error = error {
				fatalError("Create an in-memory coordinator failed \(error)")
			}
		}
		return container
	}()
	
	override func setUp() {
		super.setUp()
		sut = CoreDataManager(container: mockPersistentContainer)
		initStubs()
	}
	
	override func tearDown() {
		sut = nil
		flushData()
		super.tearDown()
	}
	
	
	func initStubs() {
		func insertItem(name: String) -> Item? {
			let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: mockPersistentContainer.viewContext)
			
			item.setValue(name, forKey: "name")
			item.setValue(CellType.ValidCell, forKey: "cellType")
			item.setValue("image url", forKey: "imageThumbURL")
			item.setValue("image url", forKey: "imageFullURL")
			item.setValue(false, forKey: "completed")
			item.setValue(false, forKey: "isExpired")
			//relationship: Category
			
			return item as? Item
		}
		
		
		let _ = insertItem(name: "Apples")
		
		do {
			try mockPersistentContainer.viewContext.save()
		} catch {
			print("create fakes erro \(error)")
		}
	}
	
	func flushData() {
		let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
		let items = try! mockPersistentContainer.viewContext.fetch(fetchRequest)
		
		for case let item as NSManagedObject in items {
			mockPersistentContainer.viewContext.delete(item)
		}
		
		try! mockPersistentContainer.viewContext.save()
	}
	
	func test_load_item() {
//		let item = sut.fetchItems(request: <#T##NSFetchRequest<Item>#>)
	}
	
//	func test_create_category() {
//		// Given
//		let category = sut.addCategory(categoryName: "Test Category")
//		
//		// When
//		
//		// Then
//		XCTAssertNotNil(category)
//		
////		let item = sut.addItem(toCategory: category!, withItemName: "Bread", cellType: CellType.ValidCell)
////
////		XCTAssertNotNil(item)
//	}
	
}
