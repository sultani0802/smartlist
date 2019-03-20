//
//  KitchenPage+PageDelegates.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension KitchenPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = kitchenPages.firstIndex(of: viewController as! KitchenViewController), index != 0 {
            return kitchenPages[index - 1]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = kitchenPages.firstIndex(of: viewController as! KitchenViewController), index != kitchenPages.count - 1 {
            return kitchenPages[index+1]
        }
        
        return nil
    }
}
