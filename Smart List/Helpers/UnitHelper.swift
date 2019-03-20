//
//  UnitHelper.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class UnitHelper {
    static let shared = UnitHelper()
    private init() {}                                           // Prevents creation of another instances
    
    
    /// Converts the long version of the units to their short-hand/abbreviated version
    /// and makes it get reflected in the Detail View's quantity button
    ///
    /// - Parameter u: The quantity that is saved to the Item's entity
    func abbreviateUnit(u : String) -> String {
        let components = u.components(separatedBy: " ")         // Separate the numeral and unit
        let unit : String = components[1]                       // Grab the unit
        var shortUnit : String = Constants.Units[unit]!         // Grab the short-hand version of it in Costants
        
        // Change unit to singular form iff quantity equals 1
        if components[0] == "1" && shortUnit.last == "s" {
            shortUnit = String(shortUnit.dropLast())
        }
        
        let result = components[0] + " " + shortUnit            // Combine the numeral and short-hand unit
        
        // Return the abbreviated quantity
        return result
    }
    
}
