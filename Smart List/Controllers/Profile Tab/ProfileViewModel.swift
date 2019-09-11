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

class ProfileViewModel {
    
    //MARK: - Delegate
    var delegate : ProfileViewModelDelegate?
    var coreData : CoreDataManager
    
    //MARK: - Properties
    let navTitle : String = "Settings"
    var sections : [String]!
    var settings : [[String]]!
    var settingValues : [String:String?]?
    
    var isLoggedIn : Bool = false
    
    
    init(coreDataManager: CoreDataManager) {
        self.coreData = coreDataManager
    }
    
    
    //MARK: - Core Data Methods
    func loadSettings() {
        let settings = self.coreData.loadSettings()
        var name = ""
        var email = ""
        
        if (settings.name != "") {
            name = settings.name ?? ""
        }
        
        if (settings.email != "") {
            email = settings.email ?? ""
        }
        
        settingValues = ["name":name, "email":email]
        
        isLoggedIn = settings.isLoggedIn                    // Set logged in status
        
        if (isLoggedIn) {
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
            response in
            
            if let success = response["success"] {
                self.coreData.setOfflineMode(offlineMode: true)
                self.isLoggedIn = false
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
                    self.coreData.addUser(name: updatedValue, email: "", token: "")     // Save the name to Core
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
                    self.coreData.addUser(name: "", email: updatedValue, token: "")    // Save the name to Core
                    self.settingValues!["email"] = updatedValue                                 // Update model
                    completion("Updated your name to \(updatedValue)")
                }
            }
        }
    }
    
    
    //MARK: - Misc Methods
    func showEditAlert(section: Int, row: Int) {
        switch row {
        case Constants.Settings.Name:
            delegate?.willShowAlert(message: "Enter your new name.", section: section, row: row)
        case Constants.Settings.Email:
            delegate?.willShowAlert(message: "Enter your new email.", section: section, row: row)
        case Constants.Settings.Password:
            delegate?.willShowAlert(message: "Enter a new password", section: section, row: row)
        case Constants.Settings.Notifications:
            delegate?.willShowAlert(message: "Change your notification settings in the settings app.", section: section, row: row)
        default:
            print("Cancel setting modification")
        }
    }
    
}


