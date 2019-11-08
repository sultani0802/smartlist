//
//  Smart_ListUITests.swift
//  Smart ListUITests
//
//  Created by Haamed Sultani on Oct/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import XCTest

@testable import Smart_List

class Smart_ListUITests: XCTestCase {
	
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

    func testExample() {
        // UI tests must launch the application that they test.
		
		let app = XCUIApplication()
		app.tabBars.buttons["Shopping List"].tap()
		
		let textField = app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element
		textField.tap()
		textField.swipeLeft()
		
		let addButton = app.navigationBars["Shopping List"].buttons["Add"]
		addButton.tap()
		
		let elementsQuery = app.sheets["New category"].scrollViews.otherElements
		elementsQuery.buttons["Produce"].tap()
		addButton.tap()
		elementsQuery.buttons["Bakery"].tap()
		app.tables.children(matching: .cell).element(boundBy: 2).textFields["tap here to start"].tap()
				

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
