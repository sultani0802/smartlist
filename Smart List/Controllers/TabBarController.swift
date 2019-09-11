//
//  TabBarController.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani and Lara Khouri. All rights reserved.
//

import UIKit


protocol TableViewAnimationDelegate : class {
    func animateTableView()
}

protocol CollectionViewAnimationDelegate : class {
    func animateCollectionView()
}


class TabBarController: UITabBarController {
    
    /****************************************/
    /****************************************/
    //MARK: - Properties
    /****************************************/
    /****************************************/
    var viewModel : TabBarViewModel
    
    /****************************************/
    /****************************************/
    //MARK: - UI Properties
    /****************************************/
    /****************************************/
    var currentTab : UITabBarItem?

    private var kitchenViewController : KitchenPageViewController
    private var homeViewController : HomeViewController
    private var profileViewController : ProfileViewController
    
    /****************************************/
    /****************************************/
    //MARK: - Initializers
    /****************************************/
    /****************************************/
    init(coreDataManager: CoreDataManager) {
        self.viewModel = TabBarViewModel(coreDataManager: coreDataManager)
        
        // The first tab in the tab bar
        self.kitchenViewController = KitchenPageViewController()
        // The second tab in the tab bar
        self.homeViewController = HomeViewController(coreDataManager: coreDataManager)
        // The third tab in the tab bar
        self.profileViewController = ProfileViewController(coreDataManager: coreDataManager)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deinitializing TabBarController")
    }
    
    
    /****************************************/
    /****************************************/
    //MARK: - UIView Methods
    /****************************************/
    /****************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.tabBarViewModelDelegate = self
        
        // Set the color of the tab bar
        tabBar.barTintColor = .white
        // Set the color of the selected tab bar button
        tabBar.tintColor = Constants.ColorPalette.Yellow
        // Set the color of the unselected tab bar button
        tabBar.unselectedItemTintColor = Constants.ColorPalette.DarkGray
        
        
        homeViewController.tabBarItem = UITabBarItem(title: "Shopping List", image: UIImage(named: "list"), tag: 0)

        kitchenViewController.tabBarItem = UITabBarItem(title: "Kitchen", image: UIImage(named: "kitchen"), tag: 1)
        
        profileViewController.tabBarItem = UITabBarItem(title: "Me", image: UIImage(named: "profile"), tag: 2)
        
        viewModel.tableViewAnimationDelegate = homeViewController
        viewModel.collectionViewAnimationDelegate = kitchenViewController.kitchenPages
        
        
        // Setting our view controllers for the tab bar
        let tabBarList = [kitchenViewController, homeViewController, profileViewController]
        viewControllers = tabBarList.map{UINavigationController(rootViewController: $0)}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.loadSettings()        // Load the user's app settings
    }
    
    /****************************************/
    /****************************************/
    //MARK: - Tab Bar Delegate Methods
    /****************************************/
    /****************************************/
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.title == "Shopping List" {
            if currentTab?.title != "Shopping List" {
                viewModel.tableViewAnimationDelegate?.animateTableView()
            }
        } else if item.title == "Kitchen" {
            if currentTab?.title != "Kitchen" {
                kitchenViewController.kitchenPages[kitchenViewController.pageIndex].animateCollectionView()
            }
        }
        
        currentTab = item
    }
}


/****************************************/
/****************************************/
//MARK: - Tab Bar View Model Delegates
/****************************************/
/****************************************/

extension TabBarController : TabBarViewModelDelegate {
    func presentSignUpVC() {
        print("hi")
        self.present(SignUpViewController(coreDataManager: self.viewModel.coreData), animated: true)
    }
}
