//
//  Server.swift
//  Smart List
//
//  Created by Haamed Sultani on Apr/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


/// This allows each Request made on a Session to be inspected and adapted before being created.
/// In this case, it is being used to append an Authorization header to requests behind a certain type of authentication (Bearer in our case)
struct EnvironmentInterceptor : RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AFResult<URLRequest>) -> Void) {
        var adaptedRequest = urlRequest
        
        guard let token = CoreDataManager.shared.loadSettings().token else {            // Get the token from Core Data
            print("token is null in Core Data")
            completion(.success(adaptedRequest))                                            // If it doesn't exist, then run the callback
            return
        }
        
        adaptedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Set the auth token for the request header
        completion(.success(adaptedRequest))                                            // Run the callback
    }
}


/// A Singleton that handles all the API requests
class Server {
    
    static let shared = Server()
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        
        return Session(configuration: configuration, interceptor: EnvironmentInterceptor())
    }()

    
    private init() {
    }
    
    // Nurtirionix API properties
    let nutriAppID : String = "b3bc8e5b"                                    // Nutritionix App ID
    let nutriAppKey : String = "868c6f6027df0a34334a232b2543b5bf"           // Nutritionix App Key
    let remoteUserID : String = "0"                                         // Remote User ID = 0 (development)
    let NUTRITIONIX_API : String = "https://trackapi.nutritionix.com/"      // Base URL for requests
    
    // Smart List API properties
    let SMARTLIST_DB_API : String = Constants.General.Server                   // Base URL for MongoDB requests
    
    
    /// Make a request to Nutritionix API for nutritional information of an Item
    func searchItem(itemName : String) {
        sessionManager.request("\(NUTRITIONIX_API)/v2/natural/nutrients",
            method: .post,
            parameters: ["query" : itemName],
            headers: ["x-app-id" : self.nutriAppID, "x-app-key" : self.nutriAppKey, "x-remote-user-id" : self.remoteUserID]).responseJSON {
                
                response in
                
                switch response.result {
                case .success(let data):                            // If request was a success
                    print("Nutrients endpoint success")
                    print(JSON(data))
                case .failure(let error):                           // If request was a failure
                    print("Nutrients endpoint failure: \(error)")
                }
        }
    }
    
    
    
    /// Makes a request to Nutritionix API to get the URL for the thumbnail image of a specified Item
    ///
    /// - Parameters:
    ///   - itemName: The name of the Item entity
    ///   - callBack: Used for returning the data fetched from the request
    func getItemThumbnailURL(itemName: String, callBack: @escaping (_ imageURL: String) -> Void) {
        
        sessionManager.request("\(NUTRITIONIX_API)/v2/natural/nutrients",                                      // Endpoint
            method: .post,
            parameters: ["query" : itemName],                                           // Parameters/body of the request
            headers: ["x-app-id" : self.nutriAppID, "x-app-key" : self.nutriAppKey, "x-remote-user-id" : self.remoteUserID]).responseJSON {
                
                response in
                
                switch response.result {
                case .success(let data):                                                 // If the request was a success
                    callBack(JSON(data)["foods"][0]["photo"]["thumb"].stringValue)      // Return the string value of the URL
                    
                case .failure(let error):                                               // The request failed
                    print("Search Nutritionix For Image failed: \(error)")
                }
        }
    }
    
    
    /// Makes a request to the Nutritionix API to get the URL for the full image of the specified Item
    ///
    /// - Parameters:
    ///   - itemName: The name of the Item in question
    ///   - callBack: Used to return the data fetched from the request
    func getItemFullURL(itemName: String, callBack: @escaping (_ imageURL: String) -> Void) {
        
        sessionManager.request("\(NUTRITIONIX_API)/v2/natural/nutrients",                                      // Endpoint
            method: .post,
            parameters: ["query" : itemName],                                           // Parameters/body of the request
            headers: ["x-app-id" : self.nutriAppID, "x-app-key" : self.nutriAppKey, "x-remote-user-id" : self.remoteUserID]).validate().responseJSON {
                
                response in
                
                switch response.result {
                case .success(let data):                                                 // IF the request was a success
                    callBack(JSON(data)["foods"][0]["photo"]["highres"].stringValue)    // Return the string value of the URL
                    
                case .failure(let error):                                               // The request failed
                    print("Search Nutritionix For Image failed: \(error)")
                }
        }
    }
    
    
    
    /// Sends a request to the server to create a new User in the DB
    /// The server responds with the User object
    ///
    /// - Parameters:
    ///   - name: The user's name
    ///   - email: the user's email; must be unique and valid
    ///   - password: The user'spassword; must be 8+ characters
    ///   - callBack: callback with the data that we should do something with
    func signUpNewUser(name: String, email: String, password: String, callback: @escaping (_ newUser: [String:String]) -> Void) {
        
        // The reqeust's body
        let params = ["name" : name.trimmingCharacters(in: .whitespacesAndNewlines),
                      "email" : email.trimmingCharacters(in: .whitespacesAndNewlines),
                      "password" : password.trimmingCharacters(in: .whitespacesAndNewlines)]
        
        sessionManager.request("\(SMARTLIST_DB_API)/users",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default).validate().responseJSON {
                response in
                
                switch response.result {
                case .success(let data):                                    // If successful request
                    let obj = JSON(data)                                            // Get JSON
                    print(obj)
                    
                    let name = obj["user"]["name"].stringValue                      // Get name
                    let email = obj["user"]["email"].stringValue                    // Get email
                    let token = obj["newToken"].stringValue                         // Get token
                    
                    callback(["name": name, "email": email, "token":token])         // callback
                    
                    break
                case .failure(let error):                                   // If failed request
                    let data = response.data                                        // Get response object from
                    let errorObject = JSON(data)                                    // Create error object to JSON
                    print(errorObject)
                    let errorMessage = errorObject["message"].stringValue           // Get the error message
                    
                    print(error.localizedDescription)                               // Log request error
                    callback(["error" : errorMessage])                              // Callback with error message
                    
                    break
                }
        }
    }
    
    
    
    /// Sends a request to the server to log in.
    /// The server responds with the User object and the new token
    ///
    /// - Parameters:
    ///   - email: The user's email
    ///   - password: The user's password
    ///   - callback: callback with the data that we should do something with
    func loginUser(email: String, password: String, callback: @escaping (_ response : [String:String]) -> Void) {
        
        // The request's body
        let params = ["email" : email,
                      "password" : password]
        
        sessionManager.request("\(SMARTLIST_DB_API)/users/login",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default).validate().responseJSON {
                
                response in
                
                switch response.result {
                case .success(let data):                                        // Successful request
                    let obj = JSON(data)                                            // Get JSON object
                    print(obj)
                    
                    let name = obj["user"]["name"].stringValue                      // Get name
                    let email = obj["user"]["email"].stringValue                    // Get email
                    let token = obj["newToken"].stringValue                         // Get new token
                    
                    callback(["name": name, "email":email, "token":token])              // Callback with user object
                    
                    break
                case .failure(let error):                                       // Failed request
                    let data = response.data                                        // Get response object from response
                    let errorMessage = JSON(data)["error"].stringValue              // Convert to JSON then get the error message
                    
                    print(error.localizedDescription)                               // Log request error
                    callback(["error" : errorMessage])                              // Callback with error message
                    
                    break
                }
        }
    }
    
    
    /// Sends a request to the server to log the user out and clear the auth token in the MongoDB DB
    ///
    /// - Parameter callback: callback with the success or failure message
    func logout(callback: @escaping (_ response : [String:String]) -> Void) {
        sessionManager.request("\(SMARTLIST_DB_API)/users/logout",
            method: .post,
            encoding: JSONEncoding.default).validate().responseJSON {
                response in
                
                switch response.result {
                case .success(let data):                                        // If the request was a success
                    let obj = JSON(data)                                            // Get the response JSON
                    
                    callback(["success" : obj["success"].stringValue])              // Callback with success message
                    
                case .failure(let error):                                       // If the request was a failure
                    print("Error when trying to logout. (Error: \(error)")
                    
                    callback(["error" : error.localizedDescription])                // Callback with error message
                }
        }
    }
    
    
    func authUser(callback: @escaping (_ response : [String:String]) -> Void) {
        sessionManager.request("\(SMARTLIST_DB_API)/users/auth",
        method: .post,
        encoding: JSONEncoding.default).validate().responseJSON {
            response in
            
            switch response.result {
            case .success(let data):
                let obj = JSON(data)
                
                callback(["success" : "success"])
                break
                
            case .failure(let error) :
                let data = response.data                                        // Get response object from response
                let errorMessage = JSON(data)["error"].stringValue              // Convert to JSON then get the error message
                
                print(error.localizedDescription)                               // Log request error
                callback(["error" : errorMessage])                              // Callback with error message
                
                break
            }
        }
    }
    
    
    func editUser(updates : [String : String], callback: @escaping (_ response : [String : String]) -> Void) {
        let params = updates
        
        sessionManager.request("\(SMARTLIST_DB_API)/users/update/me",
            method: .patch,
            parameters: params,
            encoding: JSONEncoding.default).validate().responseJSON {
                response in
                
                switch response.result {
                case .success(let data):                                            // If response was a success
                    let obj = JSON(data)                                                // Convert obj to JSON
                    print(obj)                                                          // Log JSON
                    
                    let updatedUser = [                                                 // Create a dictionary with relevant info
                        "name" : obj["name"].stringValue,
                        "email" : obj["email"].stringValue
                    ]
                    
                    callback(updatedUser)                                               // callback relevant info
                    break
                    
                case .failure(let error):
                    let data = response.data                                        // Get response object from response
                    let errorMessage = JSON(data)["error"].stringValue              // Convert to JSON then get the error message
                    
                    print(error.localizedDescription)                               // Log request error
                    callback(["error" : errorMessage])                              // Callback with error message
                    
                    break
                }
        }
    }
}
