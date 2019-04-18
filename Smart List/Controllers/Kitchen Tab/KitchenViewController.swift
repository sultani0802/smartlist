//
//  KitchenViewController.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit
import ViewAnimator

protocol KitchenCollectionViewCellDelegate : class {
    func userSelectedItem(item: KitchenItem)
}

protocol KitchenTabTitleDelegate: class {
    func changeNavBarTitle(title: String)
}


class KitchenViewController: UIViewController, KitchenCellDeleteDelegate, CollectionViewAnimationDelegate, KitchenSortDelegate {

    
    //MARK: - Class Properties
    /****************************************/
    /****************************************/
    var pageIndex: Int = 0                              // The page of the controller
    var editMode: Bool = false
    var instructionText : [String] = ["Your expired Kitchen Items will appear here when they expire.",
                                        "Your fresh Kitchen Items will appear here when you set an expiration date.",
                                        "All Kitchen Items will appear here when you unload from the List."]
    
    // Core Data Manager (Singleton)
    let coreDataManager = CoreDataManager.shared        // Core Data reference
    //Set the cell identifier for the collection view
    let kitchenTableViewCellIdentifier: String = Constants.CellID.KitchenTableViewCellID
    
    // The delegate that handles performing a segue to a the Detail View
    // when the user selects an Item in one of the pages
    weak var kitchenCellDelegate: KitchenCollectionViewCellDelegate?
    
    weak var kitchenTitleDelegate: KitchenTabTitleDelegate?
    
    //MARK: - UI Properties
    /****************************************/
    /****************************************/
    var collectionView: UICollectionView!
    
    var getStartedView: HomeGetStartedView = {
        var view = HomeGetStartedView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.ColorPalette.Yellow.withAlphaComponent(0.7)
        view.isHidden = true                           // Instruction view is hidden unless the collection view is empty
        
        return view
    }()

    
    
    //MARK: - TableView Data Source
    /****************************************/
    /****************************************/
    var model : [KitchenItem] = [KitchenItem]()
    
    
    
    //MARK: - View Controller Delegate Methods
    /****************************************/
    /****************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white           // Set the background color
        
        setupUIViews()                          // Create and set constraints for UIViews
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch self.pageIndex {
        case 0:
            kitchenTitleDelegate?.changeNavBarTitle(title: "Expired Items")
        case 1:
            kitchenTitleDelegate?.changeNavBarTitle(title: "Fresh Items")
        case 2:
            kitchenTitleDelegate?.changeNavBarTitle(title: "All Items")
        default:
            kitchenTitleDelegate?.changeNavBarTitle(title: "Smart Kitchen")
        }
        
        loadItems()                             // Load the KitchenItems from Core Data
        toggleInstructions()                    // Show/hide instructions
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    

    /****************************************/
    /****************************************/
    //MARK: - My Methods
    /****************************************/
    /****************************************/
    func setupUIViews() {
        initCollectionView()
        setupGetStartedView()
    }
    
    
    func setupGetStartedView() {
        self.getStartedView.instructionText.text = self.instructionText[self.pageIndex]
        self.view.addSubview(getStartedView)
        
        NSLayoutConstraint.activate([
            getStartedView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            getStartedView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            getStartedView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            getStartedView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.45)
            ])
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
    
    
    /// Fade and slide in the cells using an animation.
    /// Triggered by switch from a DIFFERENT tab in the tabBar to the Kitchen tab
    func animateCollectionView() {
        let cells = collectionView.visibleCells(in: 0) as! [KitchenCollectionViewCell]  // Get all the cells in the collection view
        
        let myAnimation = AnimationType.from(direction: .right, offset: 40)              // My animation
        
        UIView.animate(views: cells,                                                    // Animate the cells
                       animations: [myAnimation],
                       animationInterval: 0.07,
                       duration: 0.4)
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
        var expiredItems = [KitchenItem]()
        
        let sort = coreDataManager.loadSettings().kitchenTableViewSort
        
        for item in coreDataManager.fetchKitchenItemsSorted(by: sort!) {
            if item.expiryDate != nil, item.expiryDate! < DateHelper.shared.getCurrentDateObject() {
                expiredItems.append(item)
            }
        }
        
        self.model = expiredItems
    }
    
    
    /// Loads all the fresh Items
    func loadFreshItems() {
        var freshItems = [KitchenItem]()
        
        let sort = coreDataManager.loadSettings().kitchenTableViewSort
        
        for item in coreDataManager.fetchKitchenItemsSorted(by: sort!) {
            if item.expiryDate != nil, item.expiryDate! > DateHelper.shared.getCurrentDateObject() {
                freshItems.append(item)
            }
        }
        
        self.model = freshItems
    }
    
    
    /// Loads all Items that the user has purchased
    func loadCompletedItems() {
        let sort = coreDataManager.loadSettings().kitchenTableViewSort

        self.model = coreDataManager.fetchKitchenItemsSorted(by: sort!)
    }
    
    
    /// Display/hide delete buttons on Items
    func toggleDeleteButton() {
        let cells = collectionView.visibleCells(in: 0) as!
            [KitchenCollectionViewCell]                         // Get all the cells in the collectionView
        
        for cell in cells {                                     // Go through the cells
            if self.editMode {                                  // If the user wants to delete Items
                cell.deleteButton.fadeIn()                      // Fade in the delete buttons
            } else {
                cell.deleteButton.fadeOut()                     // The user is done editing -> fade out the delete buttons
            }
        }
    }
    
    func deleteKitchenItem(button: UIButton) {
        
        print("\nDELETING ITEM INDEX: \(button.tag)")
        self.coreDataManager.deleteKitchenItem(item: self.model[button.tag])
        self.model.remove(at: button.tag)
        self.collectionView.reloadData()
    }
    
    /// Sorts the collectionView cells and model by name or expiry date
    ///
    /// - Parameter by: sort by 'date' or 'name'
    func sortKitchenItems(by: String) {
        if by == "name" {
            self.model = coreDataManager.fetchKitchenItemsSorted(by: "name")
            self.collectionView.reloadData()
        } else if by == "date" {
            self.model = coreDataManager.fetchKitchenItemsSorted(by: "date")
            self.collectionView.reloadData()
        }
    }
    
    /// Toggles the instruction view when if there are Items in the 'expired', 'fresh', or 'all' tab
    /// This method is called in viewDidLoad and whenever the user adds/removes a category
    func toggleInstructions() {
        if collectionView.visibleCells.isEmpty && model.count <= 0 {
            getStartedView.isHidden = false
        } else {
            getStartedView.isHidden = true
        }
    }
}
