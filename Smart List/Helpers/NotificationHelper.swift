//
//  NotificationHelper.swift
//  Smart List
//
//  Created by Haamed Sultani on Apr/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//
//
//

import UIKit
import UserNotifications


/// Singleton that creates and sends local notifications at a specified date and time
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
    func sendNotification(withExpiryDate expiryDate: Date, itemName: String, imageURL: String) {
        
        // If the user has granted us access to send notifications
        if self.notificationsAllowed {
            // Init the notification
			let content = UNMutableNotificationContent()
			
			// Make notification title plural/singular form
            if itemName.last == "s" {
                content.title = "Your \(itemName) are about to expire!"
            } else {
                content.title = "Your \(itemName) is about to expire!"
            }
			
			// Set the notification's body
            content.body = "Expiring \(DateHelper.shared.getDateString(of: expiryDate))"
			
            if !imageURL.isEmpty {
				// If the item has an imageUrl, attach it to the notification
                let imageData = NSData(contentsOf: URL(string: imageURL)!)!
                let attachment = UNNotificationAttachment.saveImageToDisk(fileIdentifier: "image.jpg", data: imageData, options: nil)
                content.attachments = [attachment] as! [UNNotificationAttachment]
            }
            
			// Set the notification's date/time to the Item's expiration date
            let today = DateHelper.shared.getCurrentDateObject()
            let timeDifference = Calendar.current.dateComponents([.hour], from: today, to: expiryDate).hour                 // Get the number of hours from now until the expiration date
            let seconds = timeDifference!*3600                                                                              // Get the number of seconds from now until the expiration date at 1PM

            if seconds > 0 {                                                                                                // If the expiration date is in the future
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)        // Set the notification trigger to the expiration date at 1PM
                let triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: expiryDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)   // Create the notification request
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)                                 // Add the notification to the UserNotificationCenter
            }
        } else {
            print("User has denied Push Notifications")
        }
    }
}


@available(iOSApplicationExtension 10.0, *)
extension UNNotificationAttachment {
    
	
	/// Saves an image to the device and returns a Notification Attachment that will be used in local notifications
	///
	/// - Parameters:
	///   - fileIdentifier: The image's description
	///   - data: The image data
	///   - options: Notification options
	///
	/// - Returns: A Notification Attachment
    static func saveImageToDisk(fileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL?.appendingPathComponent(fileIdentifier)
            try data.write(to: fileURL!, options: [])
            let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: fileURL!, options: options)
            return attachment
        } catch let error {
            print("error \(error)")
        }
        
        return nil
    }
}
