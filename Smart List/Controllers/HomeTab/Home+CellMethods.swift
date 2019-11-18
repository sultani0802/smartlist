//
//  Home+TableDelegates.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//
//
//  The delegate methods associated with a tableview's cells
//
//  SwipeCellKit: https://github.com/SwipeCellKit/SwipeCellKit


import UIKit
import SwipeCellKit
import UserNotifications
import Kingfisher

extension HomeViewController {
    
    /// Set the number of rows for each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.items[section].count
    }
    
    
    
    
    /// Customize the contents of the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.homeCellReuseIdentifier, for: indexPath) as! HomeTableViewCell
        
        // Set the delegates
        cell.delegate = self
        cell.textDelegate = self
        cell.scannerDelegate = self
        
        // Get the Item for that cell
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        // Get the Category for that section
        let category = viewModel.categories[indexPath.section]
        
        
        // Apply the Item entity's model to the cell
        if item.cellType != CellType.DummyCell {
            cell.accessoryType = item.completed ? .checkmark : .none                    // Display a checkmark if the item is completed
            cell.nameText.text = item.name                                              // Set the name of the cell
            cell.itemImageView.isHidden = false                                         // Show item's image
            cell.scannerButton.isHidden = true                                          // Hide scanner button
        } else {
            cell.accessoryType = .none
            cell.itemImageView.isHidden = true                                          // Hide item image if cell is dummy
            cell.scannerButton.isHidden = false                                         // Show scanner button
            cell.nameText.text = ""
        }
        
        if item.cellType != CellType.DummyCell {
            if let imgURL = item.imageThumbURL {                                            // If Item's thumbnail image url isn't nil
                cell.itemImageView.kf.setImage(with: URL(string: imgURL))                   // Download and set the Item's image to the image at the URL
            } else {
                cell.itemImageView.image = UIImage(named: "groceries")                      // Else, set it to default 'groceries' image in assets
            }
        }

        
        cell.completed = item.completed                                                 // Show or hide the checkmark based on item completion
        
        
        /// Set the cell's method to this closure
        /// Called when user hits Enter on the keyboard
        cell.addNewCell = { [weak self] newTitle in
            guard let `self` = self else {return}                                       // Capture self
            
			
            // If the user hits RETURN on a cell that isn't empty
            if cell.nameText.text != "" {
                cell.scannerButton.isHidden = true              // Hide the scanner button
                let itemToUpdate = item//self.viewModel.items[indexPath.section][indexPath.row]         // Get the Item instance from the array
                
                // Set the new Item entity's values in Core Data and save
                itemToUpdate.setValue(newTitle, forKey: "name")                         // Set Item's name in Core Data entity
                itemToUpdate.setValue(CellType.ValidCell, forKey: "cellType") // Set Item's cell type in Core Data entity
                
                Server.shared.getItemThumbnailURL(itemName: newTitle) {                 // Set the image of the Item based on Nutritionix pic
                    imageURL in
                    
                    itemToUpdate.setValue(imageURL, forKey: "imageThumbURL")                       // Update the Item entity's thumbnail image URL
                    cell.itemImageView.kf.setImage(with: URL(string: itemToUpdate.imageThumbURL!)) // Update the cell's image
                    print("item to update image: \(itemToUpdate.imageThumbURL!)")
                }
                
                cell.itemImageView.isHidden = false                                     // Unhide item's image
                
                self.viewModel.coreData.saveContext()                                      // Save the new Item to Core Data
                
                // Add a dummy cell if needed...
                // If the Category entity doesn't already have a dummy cell then...
                if !self.viewModel.categoryHasDummy(categoryIndex: indexPath.section) {
                    // Add a place holder cell (AKA a dummy cell) right below it
                    self.addPlaceHolderCell(toCategory: self.viewModel.categories[indexPath.section])
                    self.viewModel.categories[indexPath.section].hasDummy = true                  // Set the Dummy boolean indicator to true for the category
                } else {
                    print("There is already a dummy cell in that category")
                }

            } else if (cell.nameText.text == "" && item.cellType != CellType.DummyCell) {
                // another cell in the section is a dummy cell
                // remove the cell the user just saved with an empty name
                
                self.viewModel.items[indexPath.section].remove(at: indexPath.row)                             // Delete the Item from the tableView array
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)     // Delete the cell from the tableView
                self.viewModel.deleteItem(itemId: item.id!, categoryName: category.name!)                     // Delete from Core Data
                DispatchQueue.main.async {
                    self.tableView.reloadData()             // Update the view
                }
                print("Can not add new cell since current cell is empty")
            }
        }

        
        cell.scannerTapped = { [weak self] in
            guard let self = self else {return}
            
            print("scanner closure")
        }
        
        return cell
    }
    
    
    
    
    
    /// What happens when you click on a tableview cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect animation so that the cell doesn't stay highlighted even after touching
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
    /// The functionality when the user swipes on a cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        // Only perform swipe actions if the user swipes from the right
        guard orientation == .right else {return nil}
        
        
        
        // Our array of the different Swipe Actions available on each 'Valid' cell
        var swipeActions: [SwipeAction]?
        // The Item entity the user just swiped on
        let item = viewModel.items[indexPath.section][indexPath.row]
        let category = viewModel.categories[indexPath.section]
        
        
        
        
        /// If swiping on a dummy cell & there are no other items
        /// Delete the category, the dummy cell from the tableview array and core data
        if viewModel.items[indexPath.section][indexPath.row].cellType == CellType.DummyCell && viewModel.items[indexPath.section].count <= 1 {
            let deleteCategorySwipe = SwipeAction(style: .default, title: "Delete section") {
                [weak self] (action, indexPath) in
                guard let `self` = self else {return}

                if let categoryName = category.name {
                    print("Deleting Category: \(categoryName)")
                    let indexSet = IndexSet(arrayLiteral: indexPath.section)                // Grab index of section
                    
                    self.viewModel.categories.remove(at: indexPath.section)                 // Remove category from the tableview array
                    self.viewModel.items.remove(at: indexPath.section)                      // Remove the items under that category in the tableview array
                    DispatchQueue.main.async {
                        self.tableView.deleteSections(indexSet, with: .automatic)           // Delete the section from the tableview
                    }
                    action.fulfill(with: .delete)                                           // Fulfill the delete action BEFORE deleting from Core Data
                    self.viewModel.deleteCategoryFromCoreData(categoryName: categoryName)               // Delete the Category entity & cascade to the deletion of the Item entities
                    self.toggleInstructions()
                }
            }
            // Customize the visuals of the swipe button
            deleteCategorySwipe.image = UIImage(named: "delete")
			deleteCategorySwipe.backgroundColor = Constants.Visuals.ColorPalette.Crimson
            
            // Set the button(s) to the swipe options
            swipeActions = [deleteCategorySwipe]
        }
        
            
            
            
        /// If swiping on a valid cell: Mark as done OR delete
        /// Mark the Item as done
        ///         OR
        /// Delete the valid cell from the tableview array and core data
        else if viewModel.items[indexPath.section][indexPath.row].cellType != CellType.DummyCell {
            /// Swipe action to delete the Item
            let deleteAction = SwipeAction(style: .default, title: "Delete") {
                [weak self] (action, indexPath) in
                guard let `self` = self else {return}
                
                if let itemId : String = item.id {
                    if (item.completed) {
                        self.viewModel.numberOfCompletedItems -= 1
                    }
                    
                    print("\nDELETING ITEM: \(item.name!), id: \(itemId)\n")
					DispatchQueue.main.async {
						self.tableView.deleteRows(at: [indexPath], with: .left)
					}
                    self.viewModel.items[indexPath.section].remove(at: indexPath.row)       // Delete the Item from the tableView array
                    action.fulfill(with: .delete)                                           // Fulfill the delete action BEFORE deleting from Core Data
                    let categoryName = self.viewModel.categories[indexPath.section].name    // Grab Category name
                    self.viewModel.deleteItem(itemId: itemId, categoryName: categoryName!)  // Delete from Core Data
                    self.toggleDoneShoppingButton()                                         // Hide or show the 'Unload' nav bar button
					
					print(self.viewModel.items)
                }
            }
            // Customize visuals of the swipe buttons
            deleteAction.image = UIImage(named: "delete")                                   // Set the image of the delete icon
            
			deleteAction.backgroundColor = Constants.Visuals.ColorPalette.Crimson
            
            
            /// Swipe action to mark an Item entity as done
            let completedAction = SwipeAction(style: .default, title: "Load") {
                [weak self] (action, indexPath) in
                guard let `self` = self else {return}
                
                let cell : HomeTableViewCell = self.tableView.cellForRow(at: indexPath) as! HomeTableViewCell
                
                if (item.completed == false){
                    item.completed = true
                    cell.completed = true
                    self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    item.purchaseDate = DateHelper.shared.getCurrentDateObject()
                    self.viewModel.numberOfCompletedItems += 1
                } else {
                    item.completed = false
                    cell.completed = false
                    self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    self.viewModel.numberOfCompletedItems -= 1
                }
                self.toggleDoneShoppingButton()
                self.viewModel.coreData.saveContext()
            }
            
			completedAction.backgroundColor = Constants.Visuals.ColorPalette.SeaGreen
            completedAction.hidesWhenSelected = true
            
            // Set the button(s) to the swipe options
            swipeActions = [deleteAction, completedAction]
        }
        
        // Returns the buttons on a swipe based on the type of the cell
        return swipeActions
    }
    
    
    /// Options for SwipeCellKit
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        
        return options
    }
    
    
    
    /// Segue's to the Detail View of the cell
    ///
    /// - Parameters:
    ///   - tableView: This view's tableView
    ///   - indexPath: the index of the cell
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let item: Item = viewModel.items[indexPath.section][indexPath.row]
        
        let detailVC = DetailViewController(coreDataManager: self.viewModel.coreData)
        detailVC.item = item
        self.navigationController?.pushViewController(detailVC, animated: true)
         
        // Hide the keyboard
        self.view.endEditing(true)
    }
}
