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


/// A Singleton that handles all the API requests
class Server {
    
    static let shared = Server()
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
    }
    
    
    let nutriAppID : String = "b3bc8e5b"                                    // Nutritionix App ID
    let nutriAppKey : String = "868c6f6027df0a34334a232b2543b5bf"           // Nutritionix App Key
    let remoteUserID : String = "0"                                         // Remote User ID = 0 (development)
    let HOST : String = "https://trackapi.nutritionix.com/"                 // Base URL for requests
    
    
    /// Make a request to Nutritionix API for nutritional information of an Item
    func searchItem(itemName : String) {
        AF.request("\(HOST)/v2/natural/nutrients",
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
        
        AF.request("\(HOST)/v2/natural/nutrients",                                      // Endpoint
            method: .post,
            parameters: ["query" : itemName],                                           // Parameters/body of the request
            headers: ["x-app-id" : self.nutriAppID, "x-app-key" : self.nutriAppKey, "x-remote-user-id" : self.remoteUserID]).responseJSON {
                
                response in
                
                switch response.result {
                case.success(let data):                                                 // If the request was a success
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
        
        AF.request("\(HOST)/v2/natural/nutrients",                                      // Endpoint
            method: .post,
            parameters: ["query" : itemName],                                           // Parameters/body of the request
            headers: ["x-app-id" : self.nutriAppID, "x-app-key" : self.nutriAppKey, "x-remote-user-id" : self.remoteUserID]).responseJSON {
                
                response in
                
                switch response.result {
                case.success(let data):                                                 // IF the request was a success
                    callBack(JSON(data)["foods"][0]["photo"]["highres"].stringValue)    // Return the string value of the URL
                    
                case .failure(let error):                                               // The request failed
                    print("Search Nutritionix For Image failed: \(error)")
                }
        }
    }
}
