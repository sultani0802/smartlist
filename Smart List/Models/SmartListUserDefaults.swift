//
//  SmartListUserDefaults.swift
//  Smart List
//
//  Created by Haamed Sultani on Nov/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

struct UserDefaultKeys {
	static let nameKey = "name"
	static let emailKey = "email"
	static let tokenKey = "token"
	static let isLoggedInStatusKey = "loggedInStatus"
	static let offlineModeKey = "offlineMode"
	static let kitchenCollectionViewSortingKey = "kitchenSorting"
}


struct SmartListUserDefaults {
	
	private let defaults : UserDefaults = UserDefaults.standard
	
	//
	// MARK: - User Default Properties
	//
	
	var name : String {
		get {
			return defaults.string(forKey: UserDefaultKeys.nameKey) ?? ""
		}
		set {
			defaults.set(newValue, forKey: UserDefaultKeys.nameKey)
		}
	}
	
	var email : String {
		get {
			return defaults.string(forKey: UserDefaultKeys.emailKey) ?? ""
		}
		set {
			defaults.set(newValue, forKey: UserDefaultKeys.emailKey)
		}
	}

	var token : String {
		get {
			return defaults.string(forKey: UserDefaultKeys.tokenKey) ?? ""
		}
		set {
			defaults.set(newValue, forKey: UserDefaultKeys.tokenKey)
		}
	}
	
	var loggedInStatus : Bool {
		get {
			return defaults.bool(forKey: UserDefaultKeys.isLoggedInStatusKey)
		}
		set {
			defaults.set(newValue, forKey: UserDefaultKeys.isLoggedInStatusKey)
		}
	}
	
	var offlineMode : Bool {
		get {
			return defaults.bool(forKey: UserDefaultKeys.offlineModeKey)
		}
		set {
			defaults.set(newValue, forKey: UserDefaultKeys.offlineModeKey)
		}
	}
	
	var kitchenCollectionViewSort : KitchenSorter {
		get {
			guard let sortingMethod = defaults.string(forKey: UserDefaultKeys.kitchenCollectionViewSortingKey) else {
				return .date
			}
			
			return KitchenSorter(rawValue: sortingMethod) ?? .date
		}
		set {
			defaults.set(newValue, forKey: UserDefaultKeys.kitchenCollectionViewSortingKey)
		}
	}
	
	
	//
	// MARK: - Mutating Methods
	//
	
	/// Saves the user's name, email, auth token, and loggedInStatus to User Defaults
	///
	/// - Parameters:
	///   - name: User's name
	///   - email: User's email
	///   - token: Token received from REST API
	mutating func userLoggedIn(name: String, email: String, token: String) {
		self.name = name
		self.email = email
		self.token = token
		self.loggedInStatus = true
		self.offlineMode = true
	}
}