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
    
    
	/**
	Abbreviates a unit of measurement
	
	- Parameter u: The long version of the unit of measurement
	- Returns : The abbreviated unit of measurement
	
	> If the unit of measurement isn't valid, the original string will be returned
	
	**Example Usage**
	```
	let shortForm = abbreviateUnit(u: "15 millimeters") // 15 mLs
	```
	*/
    func abbreviateUnit(u : String) -> String {
		// Separate the numeral and unit
		let components = u.components(separatedBy: " ")
		
		// Guard that the parameter is 2 words (i.e. 15 millimeters)
		guard components.count == 2 else { return u }
		
        let unit : String = components[1]                       // Grab the unit
		var shortUnit : String = ""								// Will be instantiated to the the abbreviation
		
		// Check if the unit of measurement they used exists in our list of units
		// Otherwise, return the original string
		if (Constants.Units[unit] != nil) {
			shortUnit = Constants.Units[unit]!
		} else if (Constants.Units["\(unit)s"] != nil) {
			shortUnit = Constants.Units["\(unit)s"]!
		} else {
			return u
		}
		
        // Change unit to singular form iff quantity equals 1
        if components[0] == "1" && shortUnit.last == "s" {
            shortUnit = String(shortUnit.dropLast())
        }
        
		// Combine the number and abbreviation
        let result = components[0] + " " + shortUnit
        
        // Return the abbreviated quantity
        return result
    }
}
