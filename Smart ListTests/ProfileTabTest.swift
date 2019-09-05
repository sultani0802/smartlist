//
//  ProfileTest.swift
//  Smart ListTests
//
//  Created by Haamed Sultani on Aug/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation
import XCTest

@testable import Smart_List

class ProfileTabTest: XCTestCase {
    func testNavigationTitle() {
        let viewModel = ProfileViewModel()
        
        XCTAssertEqual("Settings", viewModel.navTitle)
    }
    
    func testIsNotLoggedIn() {
        let viewModel = ProfileViewModel()
        
        XCTAssertFalse(viewModel.isLoggedIn)
    }
}
