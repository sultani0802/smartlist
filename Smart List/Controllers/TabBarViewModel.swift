//
//  TabBarViewModel.swift
//  Smart List
//
//  Created by Haamed Sultani on Sep/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation
import UserNotifications


protocol TabBarViewModelDelegate : class {
	func presentSignUpVC()
}

class TabBarViewModel {
	
	/****************************************/
	/****************************************/
	// MARK: - Properties
	/****************************************/
	/****************************************/
	var coreData : CoreDataManager!
	var defaults : SmartListUserDefaults!
	weak var tabBarViewModelDelegate : TabBarViewModelDelegate?
	
	// HomeViewController conforms to this protocol for tableview animations
	var tableViewAnimationDelegate : TableViewAnimationDelegate?
	// The KitchenViewController's conform to this protocol for collectionview animations
	var collectionViewAnimationDelegate : [CollectionViewAnimationDelegate]?
	
	
	/****************************************/
	/****************************************/
	// MARK: - Initializers
	/****************************************/
	/****************************************/
	init(coreDataManager : CoreDataManager, userDefaults: SmartListUserDefaults) {
		self.coreData = coreDataManager
		self.defaults = userDefaults
	}
	
	
	/****************************************/
	/****************************************/
	// MARK: - Authentication Methods
	/****************************************/
	/****************************************/
	
	/// Loads 'Settings' entity from Core Data
	/// Makes API request to log in user with saved auth token in 'Settings' entity
	func loadSettings() {
		// Authenticate the user
		Server.shared.authUser() {
			[weak self] response in
			
			if let error = response["error"] {
				print(error)
				
				// Save user's logged in status
				self?.defaults.loggedInStatus = false
				
				// If the user has offline mode off, show the sign up page
				if (self?.defaults.offlineMode == false) {
					self?.tabBarViewModelDelegate?.presentSignUpVC()
				}
			} else {
				print(response["success"] ?? "Succesfully authenticated")
			}
		}
	}
}
