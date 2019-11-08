//
//  Levenshtein.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

extension String {
	
	/// A String extension that determines how closely spelled a String is to self
	///
	/// > A score is returned based on how closely the 2 Strings are spelled. Scores can be between 0 and 1. The closer the score is to 1, the closer the Strings are spelled
	///
	/// - Parameters:
	///   - string: The String that will be evaluated
	///   - ignoreCase: Boolean determines if the evaluation is case sensitive
	///   - trimWhiteSpacesAndNewLines: Boolean determines if white space should be trimmed
	///
	/// - Returns: A score between 0 - 1
    func levenshteinDistanceScore(to string: String, ignoreCase: Bool = true, trimWhiteSpacesAndNewLines: Bool = true) -> Double {
        
        var firstString = self
        var secondString = string
        
		// Lowercase both strings
        if ignoreCase {
            firstString = firstString.lowercased()
            secondString = secondString.lowercased()
        }
        
		// Remove extra white space
        if trimWhiteSpacesAndNewLines {
            firstString = firstString.trimmingCharacters(in: .whitespacesAndNewlines)
            secondString = secondString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let empty = [Int](repeating:0, count: secondString.count)
        var last = [Int](0...secondString.count)
        
        for (i, tLett) in firstString.enumerated() {
            var cur = [i + 1] + empty
            for (j, sLett) in secondString.enumerated() {
                cur[j + 1] = tLett == sLett ? last[j] : Swift.min(last[j], last[j + 1], cur[j])+1
            }
            last = cur
        }
        
        // maximum string length between the two words
        let lowestScore = max(firstString.count, secondString.count)
        
        if let validDistance = last.last {
            return  1 - (Double(validDistance) / Double(lowestScore))
        }
        
        return 0.0
    }
}
