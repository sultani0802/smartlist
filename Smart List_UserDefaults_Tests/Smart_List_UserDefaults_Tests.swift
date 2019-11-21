//
//  Smart_List_UserDefaults_Tests.swift
//  Smart List_UserDefaults_Tests
//
//  Created by Haamed Sultani on Nov/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import XCTest

@testable import Smart_List

class Smart_List_UserDefaults_Tests: XCTestCase {

	// System under test
	var sut : SmartListUserDefaults!
	let userDefaultTestSuiteName = "testsuite"
	
    override func setUp() {
		super.setUp()
		
		// Initialize test suite for User Defaults and clear the persistent domain
		sut = SmartListUserDefaults(suite: userDefaultTestSuiteName)
		sut.completeResetUserDefaults(suiteName: userDefaultTestSuiteName)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	
	func test_saving_name() {
		// Given
		let newName : String = "New User"
		XCTAssertEqual(sut.name, "", "Expecting user defaults to have empty name before saving a new name failed")
		
		// When
		sut.name = newName
		
		// Then
		XCTAssertEqual(sut.name, newName, "Expecting user defaults to save new name failed")
	}
	
	func test_saving_email() {
		// Given
		let newEmail : String = "myemail@gmail.com"
		XCTAssertEqual(sut.email, "", "Expecting user defaults to have empty email before saving a new email failed")
		
		// When
		sut.email = newEmail
		
		// Then
		XCTAssertEqual(sut.email, newEmail, "Expecting user defaults to save new email failed")
	}
	
	func test_saving_token() {
		// Given
		let newAuthToken : String = "j1h2k3h1jk2hk14h1kj23h1k23h1"
		XCTAssertEqual(sut.token, "", "Expecting user defaults to have empty auth token before saving a new token failed")
		
		// When
		sut.token = newAuthToken
		
		// Then
		XCTAssertEqual(sut.token, newAuthToken, "Expecting user defaults to save new auth token failed")
	}
	
	func test_saving_loggedInStatus() {
		// Given
		let isLoggedIn = true
		XCTAssertFalse(sut.loggedInStatus, "Expecting user defaults to have logged in status as false before setting it as true failed")
		
		// When
		sut.loggedInStatus = isLoggedIn
		
		// Then
		XCTAssertTrue(sut.loggedInStatus, "Expecting user defaults to save logged in status as true failed")
	}
	
	func test_saving_offlineMode() {
		// Given
		let isOffline = true
		XCTAssertFalse(sut.offlineMode, "Expecting user defaults to have offline mode set as false before setting it as true failed")
		
		// When
		sut.offlineMode = isOffline
		
		// Then
		XCTAssertTrue(sut.offlineMode, "Expecting user defaults saving offline mode as true has failed")
	}
	
	func test_changing_kitchenSort() {
		// Given
		let sortedByDate : KitchenSorter = KitchenSorter.date
		let sortedByName : KitchenSorter = KitchenSorter.name
		XCTAssertEqual(sut.kitchenCollectionViewSort, .date, "Expecting kitchen sort to default to KitchenSorter.date has failed")
		
		// When
		sut.kitchenCollectionViewSort = sortedByName
		
		// Then
		XCTAssertEqual(sut.kitchenCollectionViewSort, sortedByName, "Expecting kitchen sort to be saved as KitchenSorter.name has failed")
		sut.kitchenCollectionViewSort = sortedByDate
		XCTAssertEqual(sut.kitchenCollectionViewSort, sortedByDate, "Expecting kitchen sort to be changed back to KitchenSorter.date has failed")
	}
	
	func test_saving_and_clearing_userSession() {
		// Given
		let name : String = "name"
		let email : String = "email@email.com"
		let token : String = "djhawlkeklj12k3j1kljdla.12kjk12j3fjaid$jadlka.dlkjwlkj4!J4lajdkw"
		
		XCTAssertEqual(sut.name, "", "Expecting name to be an empty string before saving user's session failed")
		XCTAssertEqual(sut.email, "", "Expecting email to be an empty string before saving user's session failed")
		XCTAssertEqual(sut.token, "", "Expecting auth token to be an empty string before saving user's session failed")
		XCTAssertFalse(sut.loggedInStatus, "Expecting logged in status to be false before saving user's session failed")
		XCTAssertFalse(sut.offlineMode, "Expecting offline mode to be false before saving user's session failed")
		
		// When
		// Logging the user in
		sut.saveUserSession(name: name, email: email, token: token)
		
		// Then
		XCTAssertEqual(sut.name, name, "Saving user's session failed at name")
		XCTAssertEqual(sut.email, email, "Saving user's session failed at email")
		XCTAssertEqual(sut.token, token, "Saving user's session failed at auth token")
		XCTAssertTrue(sut.loggedInStatus, "Saving user's logged in status as true after saving user's session failed")
		XCTAssertFalse(sut.offlineMode, "Saving offline mode as false after saving user session has failed")
		
		// Loggin the user out of their session
		sut.clearUserSession()
		XCTAssertEqual(sut.name, "", "Expecting name to be an empty string after clearing user's session failed")
		XCTAssertEqual(sut.email, "", "Expecting email to be an empty string after clearing user's session failed")
		XCTAssertEqual(sut.token, "", "Expecting auth token to be an empty string after clearing user's session failed")
		XCTAssertFalse(sut.loggedInStatus, "Expecting logged in status to be false after clearing user's session failed")
		XCTAssertFalse(sut.offlineMode, "Expecting offline mode to be false after clearing user's session failed")
	}
	
	func test_clearing_userDefaults() {
		// Given
		let name : String = "name"
		let email : String = "email@email.com"
		let token : String = "djhawlkeklj12k3j1kljdla.12kjk12j3fjaid$jadlka.dlkjwlkj4!J4lajdkw"
		let sort : KitchenSorter = .name
		
		XCTAssertEqual(sut.name, "", "Expecting name to be an empty string before saving user's session failed")
		XCTAssertEqual(sut.email, "", "Expecting email to be an empty string before saving user's session failed")
		XCTAssertEqual(sut.token, "", "Expecting auth token to be an empty string before saving user's session failed")
		XCTAssertFalse(sut.loggedInStatus, "Expecting logged in status to be false before saving user's session failed")
		XCTAssertFalse(sut.offlineMode, "Expecting offline mode to be false before saving user's session failed")
		XCTAssertEqual(sut.kitchenCollectionViewSort, .date, "Expecting kitchen collection view sort to be KitchenSorter.date failed")
		
		// When
		sut.saveUserSession(name: name, email: email, token: token)
		sut.kitchenCollectionViewSort = sort
		
		XCTAssertEqual(sut.name, name, "Saving user's session failed at name")
		XCTAssertEqual(sut.email, email, "Saving user's session failed at email")
		XCTAssertEqual(sut.token, token, "Saving user's session failed at auth token")
		XCTAssertTrue(sut.loggedInStatus, "Saving user's logged in status as true after saving user's session failed")
		XCTAssertFalse(sut.offlineMode, "Saving offline mode as false after saving user session has failed")
		XCTAssertEqual(sut.kitchenCollectionViewSort, sort, "Saving kitchen collection view sort as KitchenSorter.name failed")
		
		
		// Then
		// Clearing persistent domain of User Defaults
		sut.completeResetUserDefaults(suiteName: userDefaultTestSuiteName)
		XCTAssertEqual(sut.name, "", "Expecting name to be an empty string after clearing user default suite failed")
		XCTAssertEqual(sut.email, "", "Expecting email to be an empty string after clearing user default suite failed")
		XCTAssertEqual(sut.token, "", "Expecting auth token to be an empty string after clearing user default suite failed")
		XCTAssertFalse(sut.loggedInStatus, "Expecting logged in status to be false after clearing user default suite failed")
		XCTAssertFalse(sut.offlineMode, "Expecting offline mode to be false after clearing user default suite failed")
		XCTAssertEqual(sut.kitchenCollectionViewSort, .date, "Expecting kitchen collection view sort to be the default KitchenSorter.date value failed")
	}
}
