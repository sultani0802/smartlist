//
//  KitchenPageViewController.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit
import Segmentio

/// Errors that can be thrown when handling KitchenPageIndex enums
enum KitchenPageIndexError : Error {
	/// An attempt to initialize a KitchenPageIndex failed as it did not match one of the pages in the KitchenPageViewController
	case invalidPageIndexInitialization
}

/// Used to index the Kitchen Pages
public enum KitchenPageIndex : Int {
	case expired = 0, fresh, all
	
	func stringValue() -> String {
		switch (self) {
			case .expired : return "Expired"
			case .fresh : return "Fresh"
			case .all : return "All"
		}
	}
}

/// Initializes a KitchenPageIndex enum
/// - Parameter index: An integer that represents a page in the KitchenPageViewController datasource
/// > Throws a **KitchenPageIndexError** if an invalid index is passed into it
func makeKitchenPageIndex(index: Int) throws -> KitchenPageIndex {
	switch (index) {
		case 0: return .expired
		case 1: return .fresh
		case 2: return .all
		default: throw KitchenPageIndexError.invalidPageIndexInitialization
	}
}


/// Protocol-Delegate pattern that determines which one of the pages' cells are sorted
protocol KitchenSortDelegate : class {
    func sortKitchenItems(by: KitchenSorter)
}




class KitchenPageViewController: UIViewController, KitchenTabTitleDelegate, SegmentControlDelegate {
    
    //
    // MARK: - Class Properties
    //
	
	private var viewModel : KitchenPageViewModel!
    // Delegate-protocol pattern for the NavigationBar's "Sort" button
	// The presently visible pageViewController conforms to this protocol
	weak var sortDelegate : KitchenSortDelegate?

    
    //  
    // MARK: - UIViews
    //
    var pageViewController: UIPageViewController!
    var segmentControl: Segmentio!
	var editBarButtonItem : UIBarButtonItem!
	var sortBarButtonItem : UIBarButtonItem!
    
	
	//
	// MARK: - Initializers
	//
	init(coreDataManager : CoreDataManager, userDefaults: SmartListUserDefaults) {
		self.viewModel = KitchenPageViewModel(coreDataManager: coreDataManager, userDefaults: userDefaults)
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
    //
    // MARK: - View methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Initialize the view
        setupView()
        // Make current visible page conform to Sorting delegate
		sortDelegate = viewModel.kitchenPages[viewModel.currentVisiblePage.rawValue]
		// This view controller conforms to the Segment Control delegate
		self.viewModel.segmentControlDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
		// Fade the Segment control into view
        self.segmentControl.fadeIn(0.5)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
		// Fade the segment control out of view
        self.segmentControl.fadeOut(0.5)
    }
    
	
	//
	// MARK: - UI Initializers
	//
	
    /// Sets up general view settings
    func setupView() {
		self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
        
		initBarButtonItems()
		initSegmentControl()
		initPageViewController()
    }
    

	/// Initializes the Navigation Bar's left and right buttons
	func initBarButtonItems() {
		// Initialize left navigation bar button
		editBarButtonItem = UIBarButtonItem(title: "Edit",
											style: UIBarButtonItem.Style.done,
											target: self,
											action: #selector(self.editButtonTapped))
		navigationItem.leftBarButtonItem = editBarButtonItem
		navigationItem.leftBarButtonItem?.tintColor = Constants.Visuals.ColorPalette.Yellow
		
		// Initialize right navigation bar button
		sortBarButtonItem = UIBarButtonItem(title: "Sort",
											 style: UIBarButtonItem.Style.plain,
											 target: self,
											 action: #selector(self.sortButtonTapped))
		navigationItem.rightBarButtonItem = sortBarButtonItem
		navigationItem.rightBarButtonItem?.tintColor = Constants.Visuals.ColorPalette.Yellow
	}
	
    
    /// Initializes the custom UISegmentedControl
    func initSegmentControl() {
		// Initialize, customize properties, and add to subview
        let segmentioViewRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height*0.07)
        segmentControl = Segmentio(frame: segmentioViewRect)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.layer.borderWidth = 0
        view.addSubview(segmentControl)
        
		// Initialize the segments and default selection to the expired tab
		segmentControl.setup(content: viewModel.segmentItems, style: SegmentioStyle.onlyLabel, options: nil)
		segmentControl.selectedSegmentioIndex = KitchenPageIndex.expired.rawValue
        
        NSLayoutConstraint.activate([
            segmentControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(self.tabBarController?.tabBar.frame.height)!),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentControl.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
            ])
        
        
        /// Closure that is executed when the user switches between pages using the Segment Control
        segmentControl.valueDidChange = { [weak self] segmentio, segmentIndex in
			self?.viewModel.segmentDidChange(newSegmentIndex: segmentIndex)
        }
    }
	
	
    
    
    /// Initializes the UIPageController
    func initPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: nil)
		// Add PageViewController to view and apply constraints
		view.addSubview(pageViewController.view)
		setPageConstraints()
		
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        
		self.viewModel.kitchenPages.forEach {
			// Set the page index for each KitchenViewController
			$0.pageIndex = self.viewModel.kitchenPages.firstIndex(of: $0)!
            // Conform to delegates
			$0.kitchenCellDelegate = self	// Presents detail view for selected collection view cell
            $0.kitchenTitleDelegate = self	// Changes navigation bar title based on KitchenViewController being displayed
        }
		
		// Display the first page
		pageViewController.setViewControllers([self.viewModel.kitchenPages.first!],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
        

    }
    
    
    /// Applies constraints to the UIPageController content view
    func setPageConstraints() {
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -1)
            ])
    }
    
    
    //
    // MARK: - UI Logic Methods
    //
	
	func changeNavBarTitle(title: String) {
		self.navigationItem.title = title
	}
    
    @objc func editButtonTapped() {
		// Toggle the edit mode flag
		self.viewModel.editMode = !self.viewModel.editMode
        var newTitle = "Edit"
		
		// Update editButtonBarButton title
		if self.viewModel.editMode {                                   		// If the user is editing
            newTitle = "Done editing"       // Change leftBarButtonItem text
		}
		
		// Update the UI
		DispatchQueue.main.async {
			self.navigationItem.leftBarButtonItem?.title = newTitle
		}
		
		// Go through each page and toggle the editMode boolean flag
		self.viewModel.kitchenPages.forEach {
			$0.editMode = self.viewModel.editMode
            if let _ = $0.collectionView {
                $0.toggleDeleteButtons()
            }
        }
    }
    
    
    
    /// Presents an AlertAction to allow the user to sort the Kitchen items. This is triggered by the
    /// RightBarButtonItem in KitchenPageViewController
    @objc func sortButtonTapped() {
        let alertController = UIAlertController(title: "Sort Kitchen items",
                                                message: "Select whether you'd like to sort the Kitchen items by name or expiration date.",
                                                preferredStyle: .alert)
        
		// Sort by date
        let dateAction = UIAlertAction(title: "Sort By Date", style: UIAlertAction.Style.default) {
            [weak self] UIAlertAction in
			guard let self = self else { return }
            
			self.sortDelegate?.sortKitchenItems(by: .date)
			self.viewModel.defaults.kitchenCollectionViewSort = .date
//			self.viewModel.loadSettings().kitchenTableViewSort = KitchenSorter.date.rawValue
//			self.viewModel.coreData.saveContext()
        }
        
		// Sort by name
        let nameAction = UIAlertAction(title: "Sort By Name", style: .default) {
			[weak self] UIAlertAction in
			guard let self = self else { return }
			
			self.sortDelegate?.sortKitchenItems(by: .name)
			self.viewModel.defaults.kitchenCollectionViewSort = .name
//			self.viewModel.coreData.loadSettings().kitchenTableViewSort = KitchenSorter.name.rawValue
//			self.viewModel.coreData.saveContext()
        }
        
		// Cancel sorting
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            print("User cancelled changing sorting of Kitchen Items")
        }
        
        
        alertController.addAction(dateAction)
        alertController.addAction(nameAction)
        alertController.addAction(cancelAction)
        
		DispatchQueue.main.async {
			self.present(alertController, animated: true, completion: nil)
		}
    }
	
	
	/// Updates the UI by changing the page
	/// - Parameters:
	///   - indexToChangeTo: The index of the KitchenViewController to be displayed
	///   - direction: The direction to scroll in the KitchenPageViewController
	func changePageFromSegmentControl(indexToChangeTo: Int, direction: UIPageViewController.NavigationDirection) {
		// Navigate to the new page
		DispatchQueue.main.async {
			self.pageViewController.setViewControllers([self.viewModel.kitchenPages[indexToChangeTo]],
				direction: direction,
				animated: true,
				completion: nil)
		}
		
		// Update sort delegate to the new page
		self.sortDelegate = self.viewModel.kitchenPages[indexToChangeTo]
	}

}


// MARK: - PageViewController Delegate & Datasource
extension KitchenPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		if let index = viewModel.kitchenPages.firstIndex(of: viewController as! KitchenViewController), index != 0 {
			return self.viewModel.kitchenPages[index - 1]
		}
		
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		if let index = self.viewModel.kitchenPages.firstIndex(of: viewController as! KitchenViewController), index != self.viewModel.kitchenPages.count - 1 {
			return self.viewModel.kitchenPages[index+1]
		}
		
		return nil
	}
	
	/// This method is called when the user INITIATES a swipe between pages
	func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
		// Get the page the user is trying scroll to
		if let nextPage = pendingViewControllers.first,
			let index = self.viewModel.kitchenPages.firstIndex(of: nextPage as! KitchenViewController) {
			// Get that page's index in the array
			
			do {
				let kitchenPageIndex = try makeKitchenPageIndex(index: index)
				self.viewModel.currentVisiblePage = kitchenPageIndex
				
				// Update the SegmentControl index
				self.segmentControl.selectedSegmentioIndex = self.viewModel.currentVisiblePage.rawValue
			} catch KitchenPageIndexError.invalidPageIndexInitialization {
				print("An invalid index was passed into the KitchenPageIndex enum generator")
			} catch {
				print("An unexpected error occured when trying to create a KitchenPageIndex enum")
			}
		}
	}
	
	/// This method is called when the page swiping animation is completed
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		
		// If the user completed a swipe to a different KitchenViewController
		if completed {
			// Get the KitchenViewController instance of the page we are on and its index in the datasource
			if let currentPage = pageViewController.viewControllers?.first,
				let index = self.viewModel.kitchenPages.firstIndex(of: currentPage as! KitchenViewController) {
				
				self.viewModel.currentVisiblePage = KitchenPageIndex(rawValue: index) ?? .all
				// Update the SegmentControl index
				self.segmentControl.selectedSegmentioIndex = self.viewModel.currentVisiblePage.rawValue
			}
		} else {
			// If the user didn't complete the swipe
			// Get the view controller of the page we are viewing
			if let currentPage = previousViewControllers.first,
				let index = self.viewModel.kitchenPages.firstIndex(of: currentPage as! KitchenViewController) {
				// Get the index of the view controller
				self.viewModel.currentVisiblePage = KitchenPageIndex(rawValue: index) ?? .all
				self.segmentControl.selectedSegmentioIndex = self.viewModel.currentVisiblePage.rawValue
			}
		}
		
		// Update the sort delegate to the new page
		self.sortDelegate = self.viewModel.kitchenPages[self.viewModel.currentVisiblePage.rawValue]
	}
}


// MARK: - KitchenView Cell Delegate
extension KitchenPageViewController: KitchenCollectionViewCellDelegate {
	
	/// Segue's to the detail view of the Item the user selected
	///
	/// - Parameter item: Item the user wants to edit
	func userSelectedItem(item: KitchenItem) {
		
		// init detail view
		let detailVC = KitchenDetailViewController(coreDataManager: self.viewModel.coreData)
		
		detailVC.item = item                                                                // Set the Item the user wants to edit
		self.navigationController?.pushViewController(detailVC, animated: true)             // Show the detail view
	}
}


//
// MARK: - Push Notification Delegate
//
extension KitchenPageViewController: UNUserNotificationCenterDelegate {
	
	
	/// Requests the user to allow/decline Push Notifications
	func requestPushNotificationFromUser() {
		// Set User Notification delegate to TabBar Controller
		UNUserNotificationCenter.current().delegate = self
		// Request permission to send push notifications
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
			(granted, error) in
			
			// Apply the user's selection
			NotificationHelper.shared.notificationsAllowed = granted
			
			if granted {
				print("Notification authorization granted")
			} else {
				print("Notification authorization denied")
			}
		}
	}
	
	/// Asks delegate how to handle push notifications when the app is in the foreground
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		
		completionHandler([.alert, .sound])
	}
}
