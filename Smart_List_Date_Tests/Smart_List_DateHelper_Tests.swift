//
//  Smart_ListTests.swift
//  Smart_ListTests
//
//  Created by Haamed Sultani on Oct/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import XCTest

@testable import Smart_List

class Smart_List_DateHelper_Tests: XCTestCase {
	
	// System Under Test
	var sut : DateHelper!
	
    override func setUp() {
		super.setUp()
		
		sut = DateHelper.shared
    }

    override func tearDown() {
		super.tearDown()
    }

	
	func test_convertDateObject_to_string() {
		// Given
		
		// Create Date object for January 01, 2019 1PM EST
		let date : Date = Date(timeIntervalSince1970: 1546365600)
		let formattedDate : Date = Date(timeIntervalSince1970: 1546365600)
		
		
		let formatter = DateFormatter()
		formatter.dateStyle = .long                   // Jan 01, 2019
		formatter.timeStyle = .short                     // No time displayed
		
		
		
		// When
		let stringifiedDate : String = sut.getDateString(of: date)
		let stringifiedFormattedDate : String = sut.getDateString(of: formattedDate)
		
		
		// Then
		XCTAssertNotEqual(date.description, stringifiedDate)
		XCTAssertEqual("Jan 1, 2019", stringifiedDate, "Date object with default format was not converted to String format properly")
		XCTAssertEqual("Jan 1, 2019", stringifiedDate, "Formatted Date object was not converted to String format properly")
	}
	
	func test_fail_convertDateObject_to_string() {
		// Given
		
		// Create Date object for January 01, 2018 1PM EST
		let date : Date = Date(timeIntervalSince1970: 1514829600)
		
		
		// When
		let stringifiedDate : String = sut.getDateString(of: date)
		
		
		// Then
		XCTAssertNotEqual("Jan 1, 2019", stringifiedDate, "Date object was converted properly when it should have failed")
	}
}
