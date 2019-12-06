//
//  SignUpViewModel.swift
//  Smart List
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

struct SignUpViewModel {
	
	// MARK:- Properties
	// Keeps track of which textfield is currently being edited
	var activeText : UITextField?
	// Flag that signifies if the SignUpViewController was initiated before the TabBar
	var initializedBeforeTabBar : Bool = false
	
	var coreData : CoreDataManager!
	var defaults : SmartListUserDefaults!
	
	
	init(coreData : CoreDataManager, defaults: SmartListUserDefaults, initBeforeTabBar : Bool) {
		self.coreData = coreData
		self.defaults = defaults
		self.initializedBeforeTabBar = initBeforeTabBar
	}
}
