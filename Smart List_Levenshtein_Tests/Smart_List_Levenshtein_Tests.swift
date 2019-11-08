//
//  Smart_List_Levenshtein_Tests.swift
//  Smart List_Levenshtein_Tests
//
//  Created by Haamed Sultani on Nov/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import XCTest

@testable import Smart_List

class Smart_List_Levenshtein_Tests: XCTestCase {

	// System Under Test
	
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_strings_being_equal() {
		// Given
		let apple : String = "Apple"
		let secondApple : String = "Apple"
		let lowercaseApple : String = "apple"
		
		let letterA : String = "AAAAA"
		let letterZ : String = "ZZZZZ"
		
		
		// When
		let score : Double = apple.levenshteinDistanceScore(to: secondApple)
		let lowercaseScore : Double = apple.levenshteinDistanceScore(to: lowercaseApple)
		let charScore : Double = letterA.levenshteinDistanceScore(to: letterZ)
		
		// Then
		XCTAssertEqual(1.0, score, "Levenshtein score was not computed correctly for equal Strings")
		XCTAssertEqual(1.0, lowercaseScore, "Levenshtein score was not computed correctly for case-insensitive Strings")
		XCTAssertEqual(0.0, charScore, "Levenshtein score was not computed correctly completely different Strings")
    }

	func test_strings_being_similar() {
		// Given
		let myWord : String = "AAABBB"
		let halfWord : String = "AAA"
		
		// When
		let halfScore : Double = myWord.levenshteinDistanceScore(to: halfWord)

		// Then
		XCTAssertEqual(0.5, halfScore, "Levenshtein score was not computed correctly for Strings that are half equal.\nScore: \(halfScore)")
	}
		
	func test_score_comparisons() {
		// Given
		let cupertino = "cupertino"
		let wordA = "copertino"
		let wordB = "bopertino"
		let wordC = "apple"
		
		// When
		let higherScore = cupertino.levenshteinDistanceScore(to: wordA)
		let midScore = cupertino.levenshteinDistanceScore(to: wordB)
		let lowerScore = cupertino.levenshteinDistanceScore(to: wordC)
		
		// Then
		XCTAssertTrue(higherScore > midScore)
		XCTAssertTrue(midScore > lowerScore)
	}
}
