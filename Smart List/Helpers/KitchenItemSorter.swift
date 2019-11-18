//
//  KitchenItemSort.swift
//  Smart List
//
//  Created by Haamed Sultani on Nov/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

public enum KitchenSorterError : Error {
	case invalidSortStringFromCoreData
}

public enum KitchenSorter : String {
	case name = "name"
	case date = "date"
}

func getKitchenSorter(sortString : String) throws -> KitchenSorter {
	if (sortString == KitchenSorter.name.rawValue) { return .name }
	else if (sortString == KitchenSorter.date.rawValue) { return .date }
	else {
		throw KitchenSorterError.invalidSortStringFromCoreData
	}
}
