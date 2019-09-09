//
//  Home+SectionDelegates.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//
//
//  The delegate methods associated with a TableView's section


import UIKit

extension HomeViewController {
    
    /// Returns the custom view I made for the headers of each section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: viewModel.headerCellReuseIdentifier) as?  HomeTableviewHeader else {
            return nil
        }
        
        
        if section < viewModel.categories.count {
            headerView.title.text = viewModel.categories[section].name
        }
        
        return headerView
    }
    
    
    /// Set the height of the section label
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.TableView.HeaderHeight)
    }
    
    
    /// Set the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.categories.count
    }
}
