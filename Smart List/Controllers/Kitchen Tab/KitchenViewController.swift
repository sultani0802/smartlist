//
//  KitchenViewController.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

protocol KitchenCollectionViewCellDelegate : class {
    func userSelectedItem(item: Item)
}



class KitchenViewController: UIViewController {


    //MARK: - Class Properties
    /****************************************/
    /****************************************/
    var pageIndex: Int = 0                              // The page of the controller
    
    // Core Data Manager (Singleton)
    let coreDataManager = CoreDataManager.shared        // Core Data reference
    //Set the cell identifier for the collection view
    let kitchenTableViewCellIdentifier: String = Constants.CellID.KitchenTableViewCellID
    
    // The delegate that handles performing a segue to a the Detail View
    // when the user selects an Item in one of the pages
    weak var kitchenCellDelegate: KitchenCollectionViewCellDelegate?

    //MARK: - UI Properties
    /****************************************/
    /****************************************/
    var collectionView: UICollectionView!

    
    
    //MARK: - TableView Data Source
    /****************************************/
    /****************************************/
    var model : [Item] = [Item]()
    
    
    
    //MARK: - View Controller Delegate Methods
    /****************************************/
    /****************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white           // Set the background color
        
        setupUIViews()                          // Create and set constraints for UIViews
        loadItems()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadItems()
    }
    

    /****************************************/
    /****************************************/
    //MARK: - My Methods
    /****************************************/
    /****************************************/
    func setupUIViews() {
        initCollectionView()
    }
    
    
    
    
    func initCollectionView() {
        // Set the collection view layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()           // Instantiate layout
        layout.scrollDirection = .vertical                                              // Scrolls vertically
        
        // Instantiate the collectionView
        collectionView = UICollectionView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height,
                                                        width: self.view.frame.width,
                                                        height: self.view.frame.height),
                                          collectionViewLayout: layout)
        collectionView.backgroundColor = .white                                         // Set background color
        collectionView.translatesAutoresizingMaskIntoConstraints = false                // Uses auto-layout
        
        view.addSubview(collectionView)                                                 // Add to view
        
        NSLayoutConstraint.activate([                                                   // Apply constraints
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        // Apply offset of the tabbar and the segment control to the collection view
        let tabBarOffset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.contentInset = tabBarOffset
        collectionView.scrollIndicatorInsets = tabBarOffset
        
        collectionView.register(KitchenCollectionViewCell.self,                         // Register cell class
                                forCellWithReuseIdentifier: Constants.CellID.KitchenCollectionViewCellID)
        
        collectionView.delegate = self                                                  // Set collectionview delegate
        collectionView.dataSource = self                                                // Set collectionview datasource
        
    }
    
    
    
    
    //
    // MARK: - Item Instantiation Methods
    //
    
    /// Calls the appropriate method to load Items into the collectionView
    func loadItems() {
        if pageIndex == 0 {                 // 1st Page: Expired Items
            loadExpiredItems()
        } else if pageIndex == 1 {          // 2nd Page: Fresh Items
            loadFreshItems()
        } else if pageIndex == 2 {          // 3rd Page: All completed Items
            loadCompletedItems()
        }
        
        collectionView.reloadData()         // Reload the collectionview with the updated Items
    }
    
    
    /// Loads all the expired Items
    func loadExpiredItems() {
        var expiredItems = [Item]()
        
        for item in coreDataManager.fetchCompletedItems() {
            if item.expiryDate != nil, item.expiryDate! < DateHelper.shared.getCurrentDateObject() {
                expiredItems.append(item)
            }
        }
        
        self.model = expiredItems
    }
    
    
    /// Loads all the fresh Items
    func loadFreshItems() {
        var freshItems = [Item]()
        
        for item in coreDataManager.fetchCompletedItems() {
            if item.expiryDate != nil, item.expiryDate! > DateHelper.shared.getCurrentDateObject() {
                freshItems.append(item)
            }
        }
        
        self.model = freshItems
    }
    
    
    /// Loads all Items that the user has purchased
    func loadCompletedItems() {
        self.model = coreDataManager.fetchCompletedItems()
    }
}
