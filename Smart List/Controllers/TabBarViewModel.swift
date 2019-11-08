//
//  TabBarViewModel.swift
//  Smart List
//
//  Created by Haamed Sultani on Sep/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

protocol TabBarViewModelDelegate : class {
    func presentSignUpVC()
}

class TabBarViewModel {
    
    /****************************************/
    /****************************************/
    //MARK: - Properties
    /****************************************/
    /****************************************/
    var coreData : CoreDataManager
    weak var tabBarViewModelDelegate : TabBarViewModelDelegate?
    
    // The Item view controller (HomeViewController) conforms to this protocol for tableview animations
    var tableViewAnimationDelegate : TableViewAnimationDelegate?
    // The Kitchen view controllers (KitchenViewController) conforms to this protocol for collectionview animations
    var collectionViewAnimationDelegate : [CollectionViewAnimationDelegate]?
     // Used to keep track of which tab is in view
    
    
    /****************************************/
    /****************************************/
    //MARK: - Initializers
    /****************************************/
    /****************************************/
    init(coreDataManager : CoreDataManager) {
        self.coreData = coreDataManager
    }
    
    
    /****************************************/
    /****************************************/
    //MARK: - Model Methods
    /****************************************/
    /****************************************/
    
    /// Loads 'Settings' entity from Core Data
    /// Makes API request to log in user with saved auth token in 'Settings' entity
    func loadSettings() {
        let settings = self.coreData.loadSettings()             // Get the settings from Core Data
        
        Server.shared.authUser() {                              // Make a call to log the user in
            response in
            
            if let error = response["error"] {                  // If user didn't automatically get logged in
                print(error)
                
                settings.isLoggedIn = false                     // Save user's logged in status as false
                self.coreData.saveContext()                     // Save in Core Data
            } else {
                print(response["success"] ?? "Succesfully authenticated")
            }
		}
    }
}
