//
//  DateHelper.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
// Thanks to Scott Gardner for the insight
// https://stackoverflow.com/a/33343958/3365488
//

import Foundation

class DateHelper {
    
    static let shared = DateHelper()
    private init() {} // Prevents creation of multiple instances
    
    
    /// Creates a Date object with todays date and
    /// time and then...
    /// - Returns: returns the string version
    func getCurrentDate() -> String {
        // Get current date and time
        let currentDate = Date()
        
        // Format the date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Feb 19, 2019
        formatter.timeStyle = .none // No time displayed
        
        // Get the date in String format
        return formatter.string(from: currentDate)
    }
    
    
    /// Creates a Date object with the current time and date
    ///
    /// - Returns: Returns the Date object that was just created
    func getCurrentDateObject() -> Date {
        return Date()
    }
    
    
    /// Converts a Date object to it's string counterpart
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
