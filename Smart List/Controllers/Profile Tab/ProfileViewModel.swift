//
//  ProfileViewModel.swift
//  Smart List
//
//  Created by Haamed Sultani on Jul/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

protocol ProfileViewModelDelegate {
	func didFinishLoggingOutSuccess(message: String)
	func didFinishLoggingOutFailure(error: String)
	func willShowAlert(message: String, section: Int, row: Int)
}

/// Used to determine which settings the User wants to edit
enum SettingsOptions : Int {
	case name = 0, email, password, notifications
}

class ProfileViewModel {
	
	//MARK: - Delegate
	var delegate : ProfileViewModelDelegate?
	var coreData : CoreDataManager!
	var defaults : SmartListUserDefaults!
	
	//MARK: - Properties
	let tableViewCellId = Constants.ReuseIdentifier.ProfileTableViewCellID
	let navTitle : String = "Settings"
	var sections : [String]!
	var settings : [[String]]!
	var settingValues : [String:String?]?
	
	
	init(coreDataManager: CoreDataManager, userDefaults: SmartListUserDefaults) {
		self.coreData = coreDataManager
		self.defaults = userDefaults
	}
	
	
	//MARK: - Core Data Methods
	func loadSettings() {
		var name = ""
		var email = ""
		
		name = defaults.name
		
		email = defaults.email
		
		settingValues = ["name":name, "email":email]
		
		if (self.defaults.loggedInStatus) {
			self.sections = ["Account" , "General"]
			self.settings = [["Name", "Email", "Password"], ["Notifications"]]
		} else {
			self.sections = ["General"]
			self.settings = [["Notifications"]]
		}
	}
	
	
	//MARK: - Server Requests
	func logoutRequest() {
		Server.shared.logout() {
			[weak self] response in
			guard let self = self else { return }
			
			if let success = response["success"] {
				self.defaults.clearUserSession()
				self.delegate!.didFinishLoggingOutSuccess(message: success)
			} else {
				let error = response["error"]
				print(error!)
				
				self.delegate!.didFinishLoggingOutFailure(error: error ?? "Unexpected error when logging out")
			}
		}
	}
	
	func sendEditRequest(settingToBeUpdated: String, _ updatedValue: String, completion: @escaping (_ message: String) -> ()) {
		if settingToBeUpdated == "name" {                              // If user is editing the name
			
			Server.shared.editUser(updates: ["name" : updatedValue]) {                   // Send name update to the MongoDB DB
				response in
				
				if let error = response["error"] {                                              // If the request failed
					print("error: \(error)")
					completion("Sorry. Can't update name right now.")
				} else {                                                                        // If the request success
					//					self.coreData.addUser(name: updatedValue, email: "", token: "")     // Save the name to Core
					self.defaults.name = updatedValue
					self.settingValues!["name"] = updatedValue                                   // Update model
					print("Here are the values")
					print(self.settingValues!)
					completion("Updated your name to \(updatedValue)")
				}
			}
		} else if settingToBeUpdated == "email" {
			Server.shared.editUser(updates: ["email" : updatedValue]) {
				response in
				
				if let error = response["error"] {
					print("error: \(error)")
					completion("Sorry. Can't update your email right now.")
				} else {
					//					self.coreData.addUser(name: "", email: updatedValue, token: "")    // Save the name to Core
					self.defaults.email = updatedValue
					self.settingValues!["email"] = updatedValue                                 // Update model
					completion("Updated your name to \(updatedValue)")
				}
			}
		}
	}
	
	
	// MARK: - Misc Methods
	func showEditAlert(section: Int, row: Int) {
		switch row {
			case SettingsOptions.name.rawValue:
				delegate?.willShowAlert(message: "Enter your new name.", section: section, row: row)
			
			case SettingsOptions.email.rawValue:
				delegate?.willShowAlert(message: "Enter your new email.", section: section, row: row)
			
			case SettingsOptions.password.rawValue:
				delegate?.willShowAlert(message: "Enter a new password", section: section, row: row)
			
			case SettingsOptions.notifications.rawValue:
				delegate?.willShowAlert(message: "Change your notification settings in the settings app.", section: section, row: row)
			
			default:
				print("Cancel changing a setting")
		}
	}
	
}
