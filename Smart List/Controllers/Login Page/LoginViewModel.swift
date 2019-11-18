//
//  LoginViewModel.swift
//  Smart List
//
//  Created by Haamed Sultani on Sep/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate : class {
    func showSpinner()
    func hideSpinner()
    func showAlert(title: String, message: String)
    func dismissLoginView()
}

class LoginViewModel {
    
    /****************************************/
    /****************************************/
    //MARK: - Properties
    /****************************************/
    /****************************************/
    var coreData : CoreDataManager
	var defaults : SmartListUserDefaults!
    var isPoppedUp : Bool = false           // Keeps track of whether the view is in view or not
    weak var loginViewModelDelegate : LoginViewModelDelegate?
    
    /****************************************/
    /****************************************/
    //MARK: - Initializers
    /****************************************/
    /****************************************/
	init(coreDataManager : CoreDataManager, userDefaults: SmartListUserDefaults) {
        self.coreData = coreDataManager
		self.defaults = userDefaults
    }
    
    
    func loginUser(email: String, password: String) {
        self.loginViewModelDelegate?.showSpinner()                                                   // Show the loading spinner
        
        Server.shared.loginUser(email: email, password: password) {
            response in
            
            self.loginViewModelDelegate?.hideSpinner()                                                   // Hide the loading spinner
            
            guard let token = response["token"] else {                                                  // If unsuccessful request
                var message : String
                
                if let error = response["error"] {                                                          // Get error message from server
                    message = error
                    print("Error when trying to login. Error: \(error)")
                } else {
                    message = "Something went wrong when logging in. Please try again."
                }
                
                self.loginViewModelDelegate?.showAlert(title: "Error", message: message)                     // Show an alert through delegate
                
                return
            }
            
			// Save user's session in User Defaults
			self.defaults.userLoggedIn(name: response["name"]!, email: response["email"]!, token: token)
			
            self.loginViewModelDelegate?.dismissLoginView()                                                  // Hide the login view controller through delegate
        }
    }
}
