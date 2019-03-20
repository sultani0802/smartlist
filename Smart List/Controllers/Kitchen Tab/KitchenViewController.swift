//
//  KitchenViewController.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class KitchenViewController: UIViewController {


    //MARK: - Class Properties
    /****************************************/
    /****************************************/
    
    // Core Data Manager (Singleton)
    let coreDataManager = CoreDataManager.shared        // Core Data reference
    let kitchenTableViewCellIdentifier: String = Constants.CellID.KitchenTableViewCellID
    

    //MARK: - UI Properties
    /****************************************/
    /****************************************/
    var collectionView: UICollectionView!

    
    
    //MARK: - TableView Data Source
    /****************************************/
    /****************************************/
    var model = [1,2,3,3,3,3,3,3,3,4,5]
    
    

    //MARK: - View Controller Delegate Methods
    /****************************************/
    /****************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white           // Set the background color
        
        setupUIViews()                          // Create and set constraints for UIViews
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
        collectionView.backgroundColor = .white                                          // Set background color
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
    
}
