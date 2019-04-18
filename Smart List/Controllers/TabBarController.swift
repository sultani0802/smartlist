//
//  TabBarController.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit


protocol TableViewAnimationDelegate : class {
    func animateTableView()
}

protocol CollectionViewAnimationDelegate : class {
    func animateCollectionView()
}


class TabBarController: UITabBarController {
    
    var tableViewAnimationDelegate : TableViewAnimationDelegate?                // The Item view controller (HomeViewController) conforms to this protocol for tableview animations
    var collectionViewAnimationDelegate : [CollectionViewAnimationDelegate]?    // The Kitchen view controllers (KitchenViewController) conforms to this protocol for collectionview animations
    var currentTab : UITabBarItem?                                              // Used to keep track of which tab is in view
    // The second tab in the tab bar
    let homeViewController = HomeViewController()
    // The first tab in the tab bar
    let kitchenViewController = KitchenPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the color of the tab bar
        tabBar.barTintColor = .white
        // Set the color of the selected tab bar button
        tabBar.tintColor = Constants.ColorPalette.Yellow
        // Set the color of the unselected tab bar button
        tabBar.unselectedItemTintColor = Constants.ColorPalette.DarkGray
        
        
        homeViewController.tabBarItem = UITabBarItem(title: "List", image: UIImage(named: "list"), tag: 0)

        kitchenViewController.tabBarItem = UITabBarItem(title: "Kitchen", image: UIImage(named: "kitchen"), tag: 1)
        
        tableViewAnimationDelegate = homeViewController
        collectionViewAnimationDelegate = kitchenViewController.kitchenPages
        
        
        // Setting our view controllers for the tab bar
        let tabBarList = [kitchenViewController, homeViewController]
        viewControllers = tabBarList.map{UINavigationController(rootViewController: $0)}
        
        
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.title == "List" {
            if currentTab?.title != "List" {
                tableViewAnimationDelegate?.animateTableView()
            }
        } else if item.title == "Kitchen" {
            if currentTab?.title != "Kitchen" {
                kitchenViewController.kitchenPages[kitchenViewController.pageIndex].animateCollectionView()
            }
        }
        
        
        currentTab = item
    }
}
