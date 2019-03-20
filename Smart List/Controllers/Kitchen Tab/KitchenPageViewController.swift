//
//  KitchenPageViewController.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class KitchenPageViewController: UIViewController {

    //
    // MARK: - Data Model
    //
    let kitchenPages : [KitchenViewController] = [KitchenViewController(), KitchenViewController(), KitchenViewController()]
    
    
    //
    // MARK: - UIViews
    //
    var pageViewController: UIPageViewController!
    
    var segmentControl: UISegmentedControl = {
        let segments = ["Expired", "About To Expire", "Fresh"]
        var segment = UISegmentedControl(items: segments)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        
        return segment
    }()
    
    
    //
    // MARK: - View methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()                     // Set up this view
        initSegmentControl()            // Init segmented control and add constraints
        initPageViewController()        // Init page controller and add constraints
    }
    
    
    //
    // MARK: - UIView Initialization Methods
    //
    
    /// Sets up general view settings
    func setupView() {
        self.view.backgroundColor = .white                          // Set background color
        
        self.navigationItem.title = Constants.General.AppName       // Customize navigation bar elements
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// Initializes the UISegmentedControl
    func initSegmentControl() {
        view.addSubview(segmentControl)             // Add segmented control to view
        
        NSLayoutConstraint.activate([               // Apply constraints
            segmentControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(self.tabBarController?.tabBar.frame.height)!),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentControl.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.075)
            ])
    }
    
    
    /// Initializes the UIPageController
    func initPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll,                 // Instantiate PageViewController
                                                  navigationOrientation: .horizontal,
                                                  options: nil)

        pageViewController.delegate = self                                                  // Set Delegate
        pageViewController.dataSource = self                                                // Set datasource
        
        view.addSubview(pageViewController.view)                                            // Add pagecontroller view to this view
        
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
            pageViewController.view.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -5)
            ])
    }
}
