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
    var isPoppedUp : Bool = false           // Keeps track of whether the view controller is in view or not
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
    
	
	/// Sends a request to the server to log the user in. If the login was successful, save the authentication token, name, and email into user defaults
	/// - Parameters:
	///   - email: The email for the account
	///   - password: The password for the account
    func loginUser(email: String, password: String) {
        // Show the spinner
		self.loginViewModelDelegate?.showSpinner()
        
		// Send request to server to login user
        Server.shared.loginUser(email: email, password: password) {
            response in
            
			// Hide the spinner once you receive a response from the server
            self.loginViewModelDelegate?.hideSpinner()
            
			// Guard that the response has a token
            guard let token = response["token"] else {
                var message : String
                
				// Get the error response
                if let error = response["error"] {
                    message = error
                    print("Error when trying to login. Error: \(error)")
                } else {
                    message = "Something went wrong when logging in. Please try again."
                }
                
				// Display an alert that the login failed
                self.loginViewModelDelegate?.showAlert(title: "Error", message: message)
                
                return
            }
            
			// Save user's session in User Defaults
			self.defaults.saveUserSession(name: response["name"]!, email: response["email"]!, token: token)
			
			// Dimiss the login view controller
            self.loginViewModelDelegate?.dismissLoginView()
        }
    }
}
