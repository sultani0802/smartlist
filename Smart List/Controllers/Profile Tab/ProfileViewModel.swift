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
}

class ProfileViewModel {
    
    //MARK: - Delegate
    var delegate : ProfileViewController?
    
    //MARK: - Properties
    let navTitle : String = "Settings"
    var sections : [String]!
    var settings : [[String]]!
    var settingValues : [String:String?]?
    
    var isLoggedIn : Bool = false
    
    
    init() {
        
    }
    
    
    func loadSettings() {
        let settings = CoreDataManager.shared.loadSettings()
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
    
    func logoutRequest() {
        Server.shared.logout() {
            response in
            
            if let success = response["success"] {
                CoreDataManager.shared.setOfflineMode(offlineMode: true)
                self.isLoggedIn = false
                self.delegate!.didFinishLoggingOutSuccess(message: success)
            } else {
                let error = response["error"]
                print(error!)
                
                self.delegate!.didFinishLoggingOutFailure(error: error ?? "Unexpected error when logging out")
            }
        }
    }
    
    func editSetting() {
        
    }
}


