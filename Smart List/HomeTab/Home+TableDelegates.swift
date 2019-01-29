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
    
    // Set the height of the section label
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // Set the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    // Set the title of each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < categories.count {
            return categories[section].name
        }
        
        return nil
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellId, for: indexPath) as! HomeTableViewCell
        cell.delegate = self
        let item = items[indexPath.section][indexPath.row]
        
        cell.nameText.text = item.name
        
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
        
        guard orientation == .right else {return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") {
            (action, indexPath) in
            
            if let itemName = self.items[indexPath.section][indexPath.row].name {
                print("\nDELETING ITEM: \(itemName)\n")
                self.items[indexPath.section].remove(at: indexPath.row) // Delete the Item from the tableView array
                action.fulfill(with: .delete) // Fulfill the delete action BEFORE deleting from Core Data
                self.deleteItem(itemName: itemName) // Delete from Core Data
            }
        }
        
        deleteAction.image = UIImage(named: "delete") // Set the image of the delete icon
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        
        return options
    }
}
