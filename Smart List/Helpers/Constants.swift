//
//  Constants.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit


/// File containing all the Constants that will be used throughout the app
struct Constants {
	
	/// General Smart List app constants
    struct General {
        // Name of the app
		static let AppName = "Smart Kitchen"
        // Endpoint for the REST API
		static let Server = "https://sultani-smartlist-api.herokuapp.com"
    }
    
	/// UI values that are used through the app
	/// > These constants are to be used throughout the app to ensure the UI is consistent
    struct Visuals {
        static let fontName = "Gill Sans"
		static let tableViewHeaderHeight = 50
		static let detailViewNotesPlaceHolderText = "Write some notes about the item here.\n\nFavorite recipes, etc."
		
		
		/// Colors used throughout the app
		/// > UIColors initialized using hex values
		struct ColorPalette {
			static let Charcoal = UIColor(hexString: "#121B20")
			static let TealBlue = UIColor(hexString: "#33658A")
			static let DarkGray = UIColor(hexString: "#2F4858")
			static let BabyBlue = UIColor(hexString: "#86BBD8")
			static let Yellow = UIColor(hexString: "#F6AE2D")
			static let Orange = UIColor(hexString: "#F26419")
			static let SeaGreen = UIColor(hexString: "#3CB371")
			static let Crimson = UIColor(hexString: "#DC143C")
			static let OffWhite = UIColor(hexString: "F2F3F5")
		}
    }
	
	/// Notification Keys (names) used for notifications
	/// > These Keys are used throughout the application for the Notification communication pattern
    struct NotificationKey {
        static let LoginViewPoppedUpNotificationKey = "com.sultani.Smart-List.loginViewPoppedUp"
    }
	
	/// Reuse Identifiers for the different CollectionView cells
    struct ReuseIdentifier {
        static let HomeHeaderID =               "homeHeaderCellID"
        static let HomeTableViewCellID =        "homeCellID"
        static let KitchenCollectionViewCellID = "kitchenCVCellID"
		static let ProfileTableViewCellID =		"profileViewCellID"
    }
    
	/// Dictionary of units of measurement
	/// > [String:String] dictionary, where Keys are the full unit of measurement and Values are the abbreviation
	///
	/// > Example:
	/// * **Key**: milligrams
	/// * **Value**: mgs
    static let Units = ["milligrams"	: "mgs",
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
	
	
	
	enum UIUserInterfaceIdiom : Int
	{
		case Unspecified
		case Phone
		case Pad
	}
	
	/// Contains the device's screen dimensions
	struct ScreenSize
	{
		static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
		static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
		static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
		static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
	}
	
	struct DeviceType
	{
		static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
		static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
		static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
		static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
		static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
	}
}
