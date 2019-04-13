//
//  KitchenPageViewController.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit
import Segmentio
import UserNotifications

class KitchenPageViewController: UIViewController, KitchenTabTitleDelegate {
    
    
    //
    // MARK: - Class Properties
    //
    let coreDataManager = CoreDataManager.shared
    
    //
    // MARK: - Data Model
    //
    let kitchenPages : [KitchenViewController] = [KitchenViewController(), KitchenViewController(), KitchenViewController()]
    var pageIndex: Int = 0
    var editMode: Bool = false

    
    //  
    // MARK: - UIViews
    //
    var pageViewController: UIPageViewController!
    var segmentControl: Segmentio!
    
    
    //
    // MARK: - View methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()                     // Set up this view
        initSegmentControl()            // Init segmented control and add constraints
        initPageViewController()        // Init page controller and add constraints
        
                                        // Set User Notification delegate
        UNUserNotificationCenter.current().delegate = self
                                        // Request permission to send notifications
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert]) {
            (granted, error) in
            
            NotificationHelper.shared.notificationsAllowed = granted
                
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.segmentControl.fadeIn(0.5)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.segmentControl.fadeOut(0.5)
    }
    
    //
    // MARK: - UIView Initialization Methods
    //
    
    /// Sets up general view settings
    func setupView() {
        self.view.backgroundColor = .white                          // Set background color
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
                                                                    // Set up left navigation bar button
        let editBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.editButtonTapped))
        navigationItem.leftBarButtonItem = editBarButtonItem//UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editButtonTapped))

        navigationItem.leftBarButtonItem?.tintColor = Constants.ColorPalette.Yellow
    }
    
    
    
    /// Initializes the UISegmentedControl
    func initSegmentControl() {
        let segmentioViewRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height*0.07)
        segmentControl = Segmentio(frame: segmentioViewRect)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentControl)                             // Add segmented control to view
        
        
        
        let segmentItems = [SegmentioItem(title: "Expired", image: nil),
                            SegmentioItem(title: "Fresh", image: nil),
                            SegmentioItem(title: "All", image: nil)]
        
        segmentControl.setup(content: segmentItems, style: SegmentioStyle.onlyLabel, options: nil)
        segmentControl.selectedSegmentioIndex = 0
        
        NSLayoutConstraint.activate([                               // Apply constraints
            segmentControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(self.tabBarController?.tabBar.frame.height)!),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentControl.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
            ])
        
        
        /// Closure that is executed when the user switches between pages
        /// This relates to the segment control
        segmentControl.valueDidChange = {
            segmentio, segmentIndex in
            
            var direction : UIPageViewController.NavigationDirection!                           // Determines the direction the page flipping
            
                                                                                                // Set the direction based on the page the user scrolls to
            
            if self.pageIndex > segmentIndex {
                direction = .reverse
                self.pageIndex = segmentIndex                                                       // Set the page index to the new index
                self.pageViewController.setViewControllers([self.kitchenPages[segmentIndex]],       // Perform the animation
                    direction: direction,
                    animated: true,
                    completion: nil)
            } else if self.pageIndex < segmentIndex {
                direction = .forward
                self.pageIndex = segmentIndex                                                       // Set the page index to the new index
                self.pageViewController.setViewControllers([self.kitchenPages[segmentIndex]],       // Perform the animation
                    direction: direction,
                    animated: true,
                    completion: nil)
            }
        }
    }
    
    
    /// Initializes the UIPageController
    func initPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll,                 // Instantiate PageViewController
                                                  navigationOrientation: .horizontal,
                                                  options: nil)
        
        pageViewController.delegate = self                                                  // Set Delegate
        pageViewController.dataSource = self                                                // Set datasource
        
        view.addSubview(pageViewController.view)                                            // Add pagecontroller view to this view
        
        kitchenPages.forEach {
            $0.pageIndex = kitchenPages.firstIndex(of: $0)!                                 // Record index of each page
            $0.kitchenCellDelegate = self                                                   // Set our custom delegate to this controller
            $0.kitchenTitleDelegate = self
        }
        pageViewController.setViewControllers([kitchenPages.first!],                        // Add pages to the page controller
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
        
        setPageConstraints()                                                                // Apply constraints to page controller
    }
    
    
    /// Applies constraints to the UIPageController content view
    func setPageConstraints() {
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false               // Use auto-layout
        
        NSLayoutConstraint.activate([                                                           // Set constraints
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -8)
            ])
    }
    
    
    //
    // MARK: - My Methods
    //
    
    @objc func editButtonTapped() {
        self.editMode = !editMode                                               // Toggle edit mode
        
        if editMode {                                                           // If the user is editing
            self.navigationItem.leftBarButtonItem?.title = "Done editing"       // Change leftBarButtonItem text
        } else if editMode == false {                                           // If the user is done editing
            self.navigationItem.leftBarButtonItem?.title = "Edit"               // Change leftBarButtonItem text
        }
                                                                                // Go through each page and toggle the editMode boolean flag
        self.kitchenPages.forEach {
            $0.editMode = self.editMode
            if let _ = $0.collectionView {
                $0.toggleDeleteButton()
            }
        }
    }
    
    func changeNavBarTitle(title: String) {
        self.navigationItem.title = title
    }
}
