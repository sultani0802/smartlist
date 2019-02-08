//
//  TabBarController.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the color of the tab bar
        tabBar.barTintColor = .white
        // Set the color of the selected tab bar button
        tabBar.tintColor = Constants.ColorPalette.Yellow
        // Set the color of the unselected tab bar button
        tabBar.unselectedItemTintColor = Constants.ColorPalette.DarkGray
        
        // The first tab in the tab bar
        let vc1 = HomeViewController()
        // The second tab in the tab bar
        let vc2 = HomeViewController()
        
        // Adding the tabs...
        vc1.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        vc2.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        
        // Setting our view controllers for the tab bar
        let tabBarList = [vc1, vc2]
        viewControllers = tabBarList.map{UINavigationController(rootViewController: $0)}
    }
}

