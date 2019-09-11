//
//  Constants.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

struct Constants {
    
    struct General {
        static let AppName = "Smart Kitchen"
        static let Server = "https://sultani-smartlist-api.herokuapp.com"
    }
    
    struct Settings {
        static let Name = 0
        static let Email = 1
        static let Password = 2
        static let Notifications = 3
    }
    
    struct Visuals {
        static let fontName = "Gill Sans"
    }
    
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
    
    struct NotificationKey {
        static let LoginViewPoppedUpNotificationKey = "com.sultani.Smart-List.loginViewPoppedUp"
    }
    
    struct TableView {
        static let HeaderHeight = 50
    }
    
    struct DetailView {
        static let notesPlaceholder = "Write some notes about the item here.\n\nFavorite recipes, etc."
    }
    
    struct CellID {
        static let HomeHeaderID =               "homeHeaderCellID"
        static let HomeTableViewCellID =        "homeCellID"
        static let KitchenTableViewCellID =     "kitchenTVCellID"
        static let KitchenCollectionViewCellID = "kitchenCVCellID"
    }
    
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
    
    static let Units = ["milligrams":"mgs",
                        "grams":"gs",
                        "kilograms":"kgs",
                        "pounds":"lbs",
                        "millilitres":"mLs",
                        "litres":"Ls",
                        "units":"units",
                        "teaspoons":"tsps",
                        "tablespoons":"tbsps",
                        "cups":"cups",
                        "ounces":"oz"]
    
    static let ItemImages : [String] = [
                        "apples",
                        "asparagus",
                        "avocados",
                        "bacon",
                        "baguette",
                        "bananas",
                        "beer",
                        "bell peppers",
                        "biscuits",
                        "black pepper",
                        "blueberries",
                        "blueberry jam",
                        "bottle thermos",
                        "bowl",
                        "bread",
                        "broccoli",
                        "burgers",
                        "cabbage",
                        "cake",
                        "candy",
                        "canned food",
                        "carrots",
                        "cauliflower",
                        "cereals",
                        "cheese",
                        "cherries",
                        "chicken drumsticks",
                        "chives",
                        "chocolate bar",
                        "coconut",
                        "coffee",
                        "cookies",
                        "corn",
                        "croissant",
                        "cupcakes",
                        "doughnuts",
                        "eggs",
                        "eggplant",
                        "fig",
                        "fish",
                        "flour",
                        "garlic",
                        "gingerbead",
                        "grapes",
                        "grean peas",
                        "groceries",
                        "ham",
                        "honey",
                        "hot dogs",
                        "ice cream",
                        "ketchup",
                        "lemon",
                        "limes",
                        "milk",
                        "mushrooms",
                        "nutella",
                        "octopus",
                        "olives",
                        "onions",
                        "oranges",
                        "pancakes",
                        "pasta",
                        "peaches",
                        "pears",
                        "peppers",
                        "pepsi",
                        "pickles",
                        "pie",
                        "pineapple",
                        "pizza",
                        "pomegranates",
                        "popsicles",
                        "potato wedges",
                        "potatoes",
                        "pretzels",
                        "pumpkin",
                        "radish",
                        "raspberries",
                        "rice",
                        "salad",
                        "salami",
                        "salmon",
                        "salt",
                        "sausages",
                        "shrimp",
                        "soda pop",
                        "spaghetti",
                        "steak",
                        "strawberries",
                        "strawberry jam",
                        "sushi",
                        "tea",
                        "tomatoes",
                        "turkey",
                        "watermelon",
                        "wine"
    ]
}
