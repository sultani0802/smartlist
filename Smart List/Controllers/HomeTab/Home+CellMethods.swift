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

extension HomeViewController {
    
    /// Set the number of rows for each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    
    
    
    
    
    /// Customize the contents of the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellReuseIdentifier, for: indexPath) as! HomeTableViewCell
        
        // Set the delegates
        cell.delegate = self
        cell.textDelegate = self
        
        // Get the Item for that cell
        let item = items[indexPath.section][indexPath.row]
        
        // Get the Category for that section
        let category = categories[indexPath.section]
        
        
        // Apply the Item entity's model to the cell
        if item.cellType != Constants.CellType.DummyCell {
            cell.accessoryType = item.completed ? .checkmark : .none                    // Display a checkmark if the item is completed
            cell.nameText.text = item.name                                              // Set the name of the cell
            cell.itemImageView.isHidden = false
        } else {
            cell.accessoryType = .none
            cell.itemImageView.isHidden = true                                          // Hide item image if cell is dummy
            cell.nameText.text = ""
        }
        
        cell.itemImageView.image = UIImage(named: item.imageName ?? "groceries")        // Set the image of the cell
        cell.completed = item.completed                                                 // Synchronize completion state of cell with core data
        
        
        
        
        
        /// Called when user hits Enter on the keyboard
        /// This allows them to enter a new item
        cell.addNewCell = { [weak self] newTitle in
            guard let `self` = self else {return}                                       // Capture self
            
            // If the user hits RETURN on a cell that isn't empty
            if cell.nameText.text != "" {
                let newTitle: String = cell.nameText.text!                              // Grab the name øf the item the user just entered
                let itemToUpdate = self.items[indexPath.section][indexPath.row]         // Grab the item they typed
                
                // Set the new Item entity's values in Core Data and save
                itemToUpdate.setValue(newTitle, forKey: "name")
                itemToUpdate.setValue(Constants.CellType.ValidCell, forKey: "cellType")
                itemToUpdate.setValue(ItemImageHelper.shared.getMatchedImage(item: itemToUpdate), forKey: "imageName")
                
                
                // Unhide item image
                cell.itemImageView.image = UIImage(named: itemToUpdate.imageName!)
                cell.itemImageView.isHidden = false
                
                // Save the new Item to Core Data
                self.coreDataManager.saveContext()
                
                // Add a dummy cell if needed...
                // If the Category entity doesn't already have a dummy cell then...
                if !self.categoryHasDummy(categoryIndex: indexPath.section) {
                    // Add a place holder cell (AKA a dummy cell) right below it
                    self.addPlaceHolderCell(toCategory: self.categories[indexPath.section])
                    self.categories[indexPath.section].hasDummy = true                  // Set the Dummy boolean indicator to true for the category
                } else {
                    print("Cannot add dummy cell because there is already a dummy cell under that category")
                }
                

            } else if (cell.nameText.text == "" && self.items[indexPath.section][indexPath.row].cellType != Constants.CellType.DummyCell) {
                // another cell in the section is a dummy cell
                // remove the cell the user just saved with an empty name
                
                self.items[indexPath.section].remove(at: indexPath.row)                             // Delete the Item from the tableView array
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)     // Delete the cell from the tableView
                self.deleteItem(itemId: item.id!, categoryName: category.name!)                 // Delete from Core Data

                print("Can not add new cell since current cell is empty")
            }
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
        let item = self.items[indexPath.section][indexPath.row]
        let category = self.categories[indexPath.section]
        
        
        
        
        /// If swiping on a dummy cell & there are no other items
        /// Delete the category, the dummy cell from the tableview array and core data
        if self.items[indexPath.section][indexPath.row].cellType == Constants.CellType.DummyCell && self.items[indexPath.section].count <= 1 {
            let deleteCategorySwipe = SwipeAction(style: .default, title: "Delete section") {
                (action, indexPath) in
                
                if let categoryName = category.name {
                    print("Deleting Category: \(categoryName)")
                    let indexSet = IndexSet(arrayLiteral: indexPath.section)                // Grab index of section
                    
                    self.categories.remove(at: indexPath.section)                           // Remove category from the tableview array
                    self.items.remove(at: indexPath.section)                                // Remove the items under that category in the tableview array
                    self.tableView.deleteSections(indexSet, with: .automatic)               // Delete the section from the tableview
                    action.fulfill(with: .delete)                                           // Fulfill the delete action BEFORE deleting from Core Data
                    self.deleteCategory(categoryName: categoryName)                         // Delete the Category entity & cascade to the deletion of the Item entities
                }
            }
            // Customize the visuals of the swipe button
            deleteCategorySwipe.image = UIImage(named: "delete")
            deleteCategorySwipe.backgroundColor = .red
            
            // Set the button(s) to the swipe options
            swipeActions = [deleteCategorySwipe]
        }
        
            
            
            
        /// If swiping on a valid cell: Mark as done OR delete
        /// Mark the Item as done
        ///         OR
        /// Delete the valid cell from the tableview array and core data
        else if self.items[indexPath.section][indexPath.row].cellType != Constants.CellType.DummyCell {
            /// Swipe action to delete the Item
            let deleteAction = SwipeAction(style: .default, title: "Delete") {
                (action, indexPath) in
                
                if let itemId : String = item.id {
                    print("\nDELETING ITEM: \(item.name!), id: \(itemId)\n")
                    self.items[indexPath.section].remove(at: indexPath.row)                 // Delete the Item from the tableView array
                    action.fulfill(with: .delete)                                           // Fulfill the delete action BEFORE deleting from Core Data
                    let categoryName = self.categories[indexPath.section].name              // Grab Category name
                    self.deleteItem(itemId: itemId, categoryName: categoryName!)            // Delete from Core Data
                }
            }
            // Customize visuals of the swipe buttons
            deleteAction.image = UIImage(named: "delete")                                   // Set the image of the delete icon
            
            deleteAction.backgroundColor = .red
            
            
            /// Swipe action to mark an Item entity as done
            let completedAction = SwipeAction(style: .default, title: "Done") {
                (action, indexPath) in

                let cell : HomeTableViewCell = self.tableView.cellForRow(at: indexPath) as! HomeTableViewCell
                
                if (item.completed == false){
                    item.completed = true
                    cell.completed = true
                    self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    item.purchaseDate = DateHelper.shared.getCurrentDateObject()
                } else {
                    item.completed = false
                    cell.completed = false
                    self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                }
                self.toggleDoneShoppingButton()
                self.coreDataManager.saveContext()
            }
            
            completedAction.backgroundColor = .green
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
        let item: Item = self.items[indexPath.section][indexPath.row]
        
        let detailVC = DetailViewController()
        detailVC.item = item
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        // Hide the keyboard
        self.view.endEditing(true)
    }
}
