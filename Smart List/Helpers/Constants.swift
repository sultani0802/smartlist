//
//  Constants.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

struct Constants {
    struct CellType {
        static let ValidCell = "valid"
        static let DummyCell = "dummy"
    }
    
    struct DefaultCategories {
        static let Produce =            "Produce"
        static let Bakery =             "Bakery"
        static let MeatSeafood =        "Meat/Seafood"
        static let Dairy =              "Dairy"
        static let PackagedCanned =     "Packaged/Canned"
        static let Frozen =             "Frozen"
    }
    
    
    struct TableView {
        static let HeaderHeight = 50
    }
    
    struct CellID {
        static let HomeHeaderID =           "homeHeaderCellID"
        static let HomeTableViewCellID =    "homeCellID"
    }
    
    struct ColorPalette {
        static let Charcoal = UIColor(hexString: "#121B20")
        static let TealBlue = UIColor(hexString: "#33658A")
        static let DarkGray = UIColor(hexString: "#2F4858")
        static let BabyBlue = UIColor(hexString: "#86BBD8")
        static let Yellow = UIColor(hexString: "#F6AE2D")
        static let Orange = UIColor(hexString: "#F26419")
    }
}
