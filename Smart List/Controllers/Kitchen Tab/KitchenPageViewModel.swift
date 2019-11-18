//
//  KitchenPageViewModel.swift
//  Smart List
//
//  Created by Haamed Sultani on Nov/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation
import Segmentio

protocol SegmentControlDelegate : class {
	func changePageFromSegmentControl(indexToChangeTo: Int, direction: UIPageViewController.NavigationDirection)
}

class KitchenPageViewModel {
	//
	// MARK: - Properties
	//
	
	// Dependency injected Core Data
	let coreData : CoreDataManager
	var defaults : SmartListUserDefaults!
	
	// Delegate-Protocol pattern that responds to KitchenPageViewController's navigation bar button "Sort"
	// The presently visible KitchenViewController conforms to this delegate
	weak var sortDelegate : KitchenSortDelegate?
	// Delegate-Protocol pattern that responds to UI interaction of the Segment Control
	weak var segmentControlDelegate : SegmentControlDelegate?
	// Flag for whether the user is deleting KitchenItems or not
	var editMode : Bool = false
	// Keeps track of which KitchenViewController is currently visible
	var currentVisiblePage : KitchenPageIndex = .expired
	
	
	
	//
	// MARK: - Datesources
	//
	// The pages in the PageViewController
	let kitchenPages : [KitchenViewController]!
	// Items in the Segment Control
	let segmentItems = [SegmentioItem(title: KitchenPageIndex.expired.stringValue(), image: nil),
						SegmentioItem(title: KitchenPageIndex.fresh.stringValue(), image: nil),
						SegmentioItem(title: KitchenPageIndex.all.stringValue(), image: nil)]
	
	//
	// MARK: - Initializer
	//
	init(coreDataManager: CoreDataManager, userDefaults: SmartListUserDefaults) {
		self.coreData = coreDataManager
		self.defaults = userDefaults
		
		kitchenPages = [KitchenViewController(coreDataManager: coreDataManager, userDefaults: userDefaults),
						KitchenViewController(coreDataManager: coreDataManager, userDefaults: userDefaults),
						KitchenViewController(coreDataManager: coreDataManager, userDefaults: userDefaults)]
	}
	
	//
	// MARK: - Methods
	//
	
//	func loadSettings() -> Settings {
//		return self.coreData.loadSettings()
//	}
	
	/// Updates the viewmodel with the page that is currently being displayed
	/// - Parameter index: The new index
	func setCurrentPageIndex(index: Int) {
		switch (index) {
			case 0: self.currentVisiblePage = .expired
			case 1: self.currentVisiblePage = .fresh
			case 2: self.currentVisiblePage = .all
			default: self.currentVisiblePage = .all
		}
	}
	
	
	/// Determines the direction to turn the PageViewController and shows the page in the UI
	/// > This method is called every time one of the items is clicked in the Segment Control.
	/// - Parameter newSegmentIndex: The index of the page the user is changing to
	func segmentDidChange(newSegmentIndex : Int) {
		// The direction the page is flipping
		var direction : UIPageViewController.NavigationDirection!
		
		// Set the direction based on the page the user scrolls to
		if self.currentVisiblePage.rawValue > newSegmentIndex {
			direction = .reverse
		} else if self.currentVisiblePage.rawValue < newSegmentIndex {
			direction = .forward
		} else {
			return
		}
		
		// Update the model to current page that is being displayed
		self.setCurrentPageIndex(index: newSegmentIndex)
		
		// Update UI by changing page to the new page
		self.segmentControlDelegate?.changePageFromSegmentControl(indexToChangeTo: newSegmentIndex, direction: direction)
	}
	
}
