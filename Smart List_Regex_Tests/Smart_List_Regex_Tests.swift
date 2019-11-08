//
//  Smart_List_Regex_Tests.swift
//  Smart List_Regex_Tests
//
//  Created by Haamed Sultani on Nov/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import XCTest

@testable import Smart_List

class Smart_List_Regex_Tests: XCTestCase {
	// System Under Test
	var sut : Regex = Regex.shared
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func test_email_passing() {
		// Given
		let emailA = "myemail@ema.il.com"
		let emailB = "myemail@ab.co"
		let emailC = "mye.mail@ab.co"
		
		// When
		let regexA = sut.validateEmail(candidate: emailA)
		let regexB = sut.validateEmail(candidate: emailB)
		let regexC = sut.validateEmail(candidate: emailC)
		
		// Then
		XCTAssertTrue(regexA)
		XCTAssertTrue(regexB)
		XCTAssertTrue(regexC)
	}
	// datehelper, levenshtein, regex
	func test_email_failing() {
		// Given
		let emailA = "dwajkh@dakw."
		let emailB = "awkdj@d.c"
		let emailC = "awdklj.dakwljd@.dawjk"
		let emailD = ".awkldj@ab.com"
		let emailE = "awdk.com"
		let emailF = "_awkldj@ab.com"
		let emailG = "-awkldj@ab.com"
		let emailH = "a..wkldj@ab.com"
		let emailJ = "a-.wkldj@ab.com"
		let emailK = "a._wkldj@ab.com"
		
		// When
		let regexA = sut.validateEmail(candidate: emailA)
		let regexB = sut.validateEmail(candidate: emailB)
		let regexC = sut.validateEmail(candidate: emailC)
		let regexD = sut.validateEmail(candidate: emailD)
		let regexE = sut.validateEmail(candidate: emailE)
		let regexF = sut.validateEmail(candidate: emailF)
		let regexG = sut.validateEmail(candidate: emailG)
		let regexH = sut.validateEmail(candidate: emailH)
		let regexJ = sut.validateEmail(candidate: emailJ)
		let regexK = sut.validateEmail(candidate: emailK)
		
		// Then
		XCTAssertFalse(regexA)
		XCTAssertFalse(regexB)
		XCTAssertFalse(regexC)
		XCTAssertFalse(regexD)
		XCTAssertFalse(regexE)
		XCTAssertFalse(regexF)
		XCTAssertFalse(regexG)
		XCTAssertFalse(regexH)
		XCTAssertFalse(regexJ)
		XCTAssertFalse(regexK)
	}
}
