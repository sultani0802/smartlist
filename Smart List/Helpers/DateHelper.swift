//
//  DateHelper.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//  Thanks to Scott Gardner for the insight
//  https://stackoverflow.com/a/33343958/3365488
//

import Foundation

class DateHelper {
    
    static let shared = DateHelper()
    private init() {}                                   // Prevents creation of multiple instances
    
    
    /// Gets today's date and time
	///
    /// - Returns: String representation of today's date and time
	func getCurrentDate() -> String {
        let currentDate = Date()                        // Get current date and time
        
        // Format the date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium                   // Feb 19, 2019
        formatter.timeStyle = .none                     // No time displayed
        
        
        return formatter.string(from: currentDate)      // Return the date in String format
    }
    
    
    /// Creates a Date object with the current time and date
    ///
    /// - Returns: A Date object with the current date and time.
    func getCurrentDateObject() -> Date {
        return Date()
    }
    
    
    /// Converts a Date object to it's string representation
	/// > Formats the Date object to "MMM DD, YYYY"
    ///
    /// - Parameter date: The Date object we want to stringify
    /// - Returns: The stringified version of the Date object
    func getDateString(of date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter.string(from: date)
    }
}
