//
//  Profile+TableViewDelegate.swift
//  Smart List
//
//  Created by Haamed Sultani on Jun/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    /// Sets the number of settings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settings[section].count
    }
    
    /// Customizes each tableviewcell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.profileViewCellId, for: indexPath) as! ProfileTableViewCell

        cell.titleLabel.text = viewModel.settings[indexPath.section][indexPath.row]                       // Set the setting's title
        
        if let content = viewModel.settingValues![viewModel.settings[indexPath.section][indexPath.row].lowercased()] {     // Check if there is a setting for that title
            cell.contentLabel.text = content                                                        // Set the correct value for the correlating title
        }
        
        return cell 
    }
    
    /// Detects which setting the user wants to modify
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.settings[indexPath.section][indexPath.row].lowercased() == "notifications" {         // If the user wants to change the notifications setting
            goToSettings(row: indexPath.row)                                                        // Redirect them to iPhone settings
        } else {
            editSetting(section: indexPath.section, row: indexPath.row)                             // Perform the appropriate setting change
        }
        
        tableView.deselectRow(at: indexPath, animated: true)                                    // Deselect the tableviewcell
    }
}
