//
//  Home+TableDelegates.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//


import UIKit
import SwipeCellKit

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: headerCellReuseIdentifier) as?  HomeTableviewHeader else {
            return nil
        }
        
        
        if section < categories.count {
            headerView.title.text = categories[section].name
        }
        
        return headerView
    }
    
    // Set the height of the section label
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.TableView.HeaderHeight)
    }
    
    // Set the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    // Set the title of each section
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section < categories.count {
//            return categories[section].name
//        }
//
//        return nil
//    }
    
    // Set the number of rows for each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowCount = 0
        
        switch section
        {
        case 0:
            rowCount = items[0].count
        case 1:
            rowCount = items[1].count
        case 2:
            rowCount = items[2].count
        case 3:
            rowCount = items[3].count
        case 4:
            rowCount = items[4].count
        case 5:
            rowCount = items[5].count
        case 6:
            rowCount = items[6].count
        default:
            rowCount = 0
        }
        
        return rowCount
    }
    
    
    
    
    /// Customize the contents of the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellReuseIdentifier, for: indexPath) as! HomeTableViewCell
        cell.delegate = self
        let item = items[indexPath.section][indexPath.row]
        
        cell.nameText.text = item.name
        cell.accessoryType = item.completed ? .checkmark : .none
        
        /// Called when user hits Enter on the keyboard
        /// This allows them to enter a new item
        cell.addNewCell = { [weak self] newTitle in
            guard let `self` = self else {return} // Capture self
            
            // If the user entered a new item
            if cell.nameText.text != "" {
                
                let newTitle: String = cell.nameText.text! // Grab the name øf the item the user just entered
                let itemToUpdate = self.items[indexPath.section][indexPath.row] // Grab the item they typed
                
                // Update the Item entity's values in Core Data and save
                itemToUpdate.setValue(newTitle, forKey: "name")
                itemToUpdate.setValue(Constants.CellType.ValidCell, forKey: "cellType")
                self.coreDataManager.saveContext()
                
                // Add a place holder cell (AKA a dummy cell) right below it
                self.addPlaceHolderCell(toCategory: self.categories[indexPath.section])
            } else {
                print("Can not add new cell since current cell is empty")
            }
        }

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        // Only perform swipe actions if the cell is not a Dummy cell
        guard orientation == .right, self.items[indexPath.section][indexPath.row].cellType != Constants.CellType.DummyCell else {return nil}
        
        // Our array of the different Swipe Actions available on each 'Valid' cell
        var swipeActions: [SwipeAction]?
        // The Item entity the user just swiped on
        let item = self.items[indexPath.section][indexPath.row]
        
        
        /// Swipe action to delete the Item
        let deleteAction = SwipeAction(style: .default, title: "Delete") {
            (action, indexPath) in
            
            if let itemName = item.name {
                print("\nDELETING ITEM: \(itemName)\n")
                self.items[indexPath.section].remove(at: indexPath.row) // Delete the Item from the tableView array
                action.fulfill(with: .delete) // Fulfill the delete action BEFORE deleting from Core Data
                self.deleteItem(itemName: itemName) // Delete from Core Data
            }
        }
        deleteAction.image = UIImage(named: "delete") // Set the image of the delete icon
        deleteAction.backgroundColor = .red
        
        
        /// Swipe action to mark an Item entity as done
        let completedAction = SwipeAction(style: .default, title: "Done") {
            (action, indexPath) in
            
            if (item.completed == false){
                item.completed = true
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            } else {
                item.completed = false
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }
            
            self.coreDataManager.saveContext()
        }
        completedAction.backgroundColor = .green
        completedAction.hidesWhenSelected = true
        
        // The array of the different actions
        swipeActions = [deleteAction, completedAction]
        
        return swipeActions
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        
        
        return options
    }
}
