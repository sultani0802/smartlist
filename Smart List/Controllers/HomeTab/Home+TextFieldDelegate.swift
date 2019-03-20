//
//  Home+TextFieldDelegate.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit


extension HomeViewController : HomeTableViewCellDelegate {
    func didEndEditing(onCell cell: HomeTableViewCell) {
        cell.addNewCell?(cell.nameText.text!)       // Save the changes to the cell
    }
    
}
