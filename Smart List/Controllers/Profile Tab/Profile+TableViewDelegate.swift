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
        return self.settings.count
    }
    
    /// Customizes each tableviewcell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.profileViewCellId, for: indexPath) as! ProfileTableViewCell
        
        cell.titleLabel.text = settings[indexPath.row]
        
        return cell
    }
    
    /// Detects which setting the user wants to modify
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editSetting(setting: indexPath.row)        // Perform the appropriate setting change
        
        tableView.deselectRow(at: indexPath, animated: true)    // Deselect the tableviewcell
    }
}
