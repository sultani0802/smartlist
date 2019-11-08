//
//  Regex.swift
//  Smart List
//
//  Created by Haamed Sultani on Jul/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

class Regex {
    static let shared = Regex()
    private init(){}
    
	
	/// Evaluates an email and determines whether it is valid or not
	/// - Parameter candidate: The email to be evaluated (String)
	/// - Returns: A Boolean where true means the email is valid, false if invalid
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let n : Int = candidate.count
		
		// Dictionary of invalid characters at the beginning of the email
		let invalidSpecialChars : Set<Character> = ["-", "_", ".", "@"]
		
		// Gaurd that the email doesn't start with an invalid character
		guard let firstChar = candidate.first, !invalidSpecialChars.contains(firstChar) else {
			return false
		}
		
		// Index used to traverse the String
		var i = 0
		while (i < n-1) {
			// Traverse the String and check if any of the special characters are next to each other
			
			let stringIndex = candidate.index(candidate.startIndex, offsetBy: i)			// The current String index
			let currentChar = Character(String(candidate[stringIndex]))						// Char at the current index
			let stringIndexAfter = candidate.index(candidate.startIndex, offsetBy: i+1)		// The index right after it
			let nextChar = Character(String(candidate[stringIndexAfter]))					// Char at next index
			
			
			if (invalidSpecialChars.contains(currentChar) && invalidSpecialChars.contains(nextChar)) {
				// If any special characters are next to each other, the email is invalid
				return false
			} else {
				i += 1
			}
		}
		
		
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    
}
