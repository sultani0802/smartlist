//
//  Home+TableDelegates.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//


import UIKit

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
        let item = items[indexPath.section][indexPath.row]
        
        cell.nameText.text = item.name
        
        /// Called when user hits Enter on the keyboard
        /// This allows them to enter a new item
        cell.callback = { [weak self] newTitle in
            guard let `self` = self else {return} // Capture self
            
            if cell.nameText.text != "" {
                // Save the change that the user made to the cell he just edited
                self.items[indexPath.section][indexPath.row].name = cell.nameText.text
                self.coreDataManager.saveContext()
                
                // Create reference to indexpath below the existing cell
                let newIndexPath = IndexPath(row: indexPath.row+1, section: indexPath.section) // Set the indexPath to the cell below
                // Create new dummy item
                let newPlaceholderItem = self.coreDataManager.addItem(toCategory: self.categories[indexPath.section], withItemName: "")
                // Add dummy item to tableview array
                self.items[indexPath.section].append(newPlaceholderItem)
                self.tableView.insertRows(at: [newIndexPath], with: .automatic) // Insert it into the tableView
            } else {
                print("Can not add new cell since current cell is empty")
            }
        }
        
        return cell
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
