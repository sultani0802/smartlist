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

class Server {
    
    static let shared = Server()
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
    }
    
    
    let nutriAppID : String = "b3bc8e5b"
    let nutriAppKey : String = "868c6f6027df0a34334a232b2543b5bf"
    let remoteUserID : String = "0"
    let HOST : String = "https://trackapi.nutritionix.com/"
    
    
    func searchItem() {
        AF.request("\(HOST)/v2/natural/nutrients",
            method: .post,
            parameters: ["query" : "tomato"],
            headers: ["x-app-id" : self.nutriAppID, "x-app-key" : self.nutriAppKey, "x-remote-user-id" : self.remoteUserID]).responseJSON {
                
                response in
                
                switch response.result {
                case .success(let data):
                    print("Nutrients endpoint success")
                    print(JSON(data))
                case .failure(let error):
                    print("Nutrients endpoint failure: \(error)")
                }
        }
    }
    
    
    func getItemThumbnailURL(item: String, callBack: @escaping (_ imageURL: String) -> Void) {
        
        AF.request("\(HOST)/v2/natural/nutrients",
            method: .post,
            parameters: ["query":item],
            headers: ["x-app-id" : self.nutriAppID, "x-app-key" : self.nutriAppKey, "x-remote-user-id" : self.remoteUserID]).responseJSON {
                response in
                
                
                switch response.result {
                case.success(let data):
                    callBack(JSON(data)["foods"][0]["photo"]["thumb"].stringValue)
                    
                case .failure(let error):
                    print("Search Nutritionix For Image failed: \(error)")
                }
        }
    }
    
    
    func getItemFullURL(item: String, callBack: @escaping (_ imageURL: String) -> Void) {
        
        AF.request("\(HOST)/v2/natural/nutrients",
            method: .post,
            parameters: ["query":item],
            headers: ["x-app-id" : self.nutriAppID, "x-app-key" : self.nutriAppKey, "x-remote-user-id" : self.remoteUserID]).responseJSON {
                response in
                
                
                switch response.result {
                case.success(let data):
                    callBack(JSON(data)["foods"][0]["photo"]["highres"].stringValue)
                    
                case .failure(let error):
                    print("Search Nutritionix For Image failed: \(error)")
                }
        }
    }
}
