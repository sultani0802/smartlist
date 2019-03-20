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
        vc1.tabBarItem = UITabBarItem(title: "List", image: UIImage(named: "list"), tag: 0)
        // The second tab in the tab bar
        let vc2 = KitchenPageViewController()
        vc2.tabBarItem = UITabBarItem(title: "Kitchen", image: UIImage(named: "kitchen"), tag: 1)
        
        
        
        // Setting our view controllers for the tab bar
        let tabBarList = [vc2, vc1]
        viewControllers = tabBarList.map{UINavigationController(rootViewController: $0)}
    }
}
