//
//  Smart_List_Spinner_UITests.swift
//  Smart List_Spinner_UITests
//
//  Created by Haamed Sultani on Nov/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import XCTest

@testable import Smart_List

class Smart_List_Spinner_UITests: XCTestCase {

	// System Under Test
	var app : XCUIApplication!
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		app = XCUIApplication()
		app.launch()
		
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func test_spinner_kitchen_tab() {
		
		
		
	}
}
