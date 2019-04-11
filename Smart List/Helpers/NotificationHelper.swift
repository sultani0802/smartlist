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
    /// - Parameter name: The name of the image we want to send with the notification
    func sendNotification(withItem item: Item) {
        let content = UNMutableNotificationContent()
        content.title = "Your \(item.name!) is about to expire!"
        content.body = "Expiring \(DateHelper.shared.getDateString(of: item.expiryDate!))"
        
        let imageURL = createLocalUrl(forImageNamed: item.imageName!)
        let attachment = try! UNNotificationAttachment(identifier: "image", url: imageURL!, options: .none)
        
        content.attachments = [attachment]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}
