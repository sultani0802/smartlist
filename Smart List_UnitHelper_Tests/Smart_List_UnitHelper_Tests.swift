//
//  Smart_List_UnitHelper_Tests.swift
//  Smart List_UnitHelper_Tests
//
//  Created by Haamed Sultani on Nov/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import XCTest

@testable import Smart_List

/**
["milligrams"	: "mgs",
"grams"			: "gs",
"kilograms"		: "kgs",
"pounds"		: "lbs",
"millilitres"	: "mLs",
"litres"		: "Ls",
"units"			: "units",
"teaspoons"		: "tsps",
"tablespoons"	: "tbsps",
"cups"			: "cups",
"ounces"		: "oz"]
*/

class Smart_List_UnitHelper_Tests: XCTestCase {

	// System Under Test
	var sut = UnitHelper.shared
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func test_conversion_default() {
		// Given
		let units = Constants.Units
		
		for unit in units.keys {
			// When
			let abbreviatedUnit = sut.abbreviateUnit(u: "15 \(unit)")
			
			// Then
			XCTAssertEqual(abbreviatedUnit, "15 \(units[unit]!)", "Unit did not abbreviate correctly")
		}
		
		
		
		// Given
		let myUnit = "1 milligram"
		// When
		let abbrev = sut.abbreviateUnit(u: myUnit)
		// Then
		XCTAssertEqual(abbrev, "1 mg")
	}
	
	func test_conversion_failing() {
		// Given
		let unitA = "15"
		let unitB = "15 grms"
		let unitC = "cups"
		
		// When
		let abbrevA = sut.abbreviateUnit(u: unitA)
		let abbrevB = sut.abbreviateUnit(u: unitB)
		let abbrevC = sut.abbreviateUnit(u: unitC)
		
		// Then
		XCTAssertEqual(unitA, abbrevA)
		XCTAssertEqual(unitB, abbrevB)
		XCTAssertEqual(unitC, abbrevC)
	}
}
