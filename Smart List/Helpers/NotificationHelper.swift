//
//  NotificationHelper.swift
//  Smart List
//
//  Created by Haamed Sultani on Apr/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationHelper {
    static let shared = NotificationHelper()
    private init() {}
    
    var notificationsAllowed : Bool = false
    
    
    /// Creates an URL using an image from xcassets
    ///
    /// - Parameter name: The name of the image in assets
    /// - Returns: The URL for the image
    private func createLocalUrl(forImageNamed name: String) -> URL? {
        
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        
        guard fileManager.fileExists(atPath: url.path) else {
            guard
                let image = UIImage(named: name),
                let data = image.pngData()
                else { return nil }
            
            fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
            return url
        }
        
        return url
    }
    
    
    
    /// Creates and schedules a notification after a specified time
    ///
    /// - Parameters:
    ///   - expiryDate: The Item's Expiration Date
    ///   - itemName: The Item's Name
    ///   - imageName: The Item's Image Name
    func sendNotification(withExpiryDate expiryDate: Date, itemName: String, imageName: String) {
        
        // If the user has granted us access to send notifications
        if self.notificationsAllowed {
            let content = UNMutableNotificationContent()                                                                    // Init the notification
            content.title = "Your \(itemName) is about to expire!"                                                          // Set the notitication title
            content.body = "Expiring \(DateHelper.shared.getDateString(of: expiryDate))"                                    // Set the notification's body
            
            let imageURL = createLocalUrl(forImageNamed: imageName)                                                         // Create an URL from the Item's image
            let attachment = try! UNNotificationAttachment(identifier: "image", url: imageURL!, options: .none)             // Add the image as an attachment to the notification
            content.attachments = [attachment]
            
            let today = DateHelper.shared.getCurrentDateObject()                                                            // Get today's date
            let timeDifference = Calendar.current.dateComponents([.hour], from: today, to: expiryDate).hour                 // Get the number of hours from now until the expiration date
            let seconds = timeDifference!*3600                                                                              // Get the number of seconds from now until the expiration date at 1PM

            if seconds > 0 {                                                                                                // If the expiration date is in the future
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)        // Set the notification trigger to the expiration date at 1PM
                let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)   // Create the notification request
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)                                 // Add the notification to the UserNotificationCenter
            }
        } else {
            print("Notifications denied")
        }
    }
    
}
