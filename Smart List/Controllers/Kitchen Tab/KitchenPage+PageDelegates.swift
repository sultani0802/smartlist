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
    
    /// This method is called when the user INITIATES a swipe between pages
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let nextPage = pendingViewControllers.first,                                     // Get the page the user is scrolling to
            let index = kitchenPages.firstIndex(of: nextPage as! KitchenViewController) {   // Get that page's index in the array
            self.pageIndex = index                                                          // Keep track of the index
            segmentControl.selectedSegmentioIndex = pageIndex                               // Update the Segment Control UI
        }
    }

    /// This method is called when the page swiping animation is completed
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {                                                                              // If the user actually swiped to a different page
            if let currentPage = pageViewController.viewControllers?.first,                         // Get the viewcontroller of the page we are on
                let index = kitchenPages.firstIndex(of: currentPage as! KitchenViewController) {    // Get the index of the page
                self.pageIndex = index                                                              // Keep track of the index
                segmentControl.selectedSegmentioIndex = pageIndex                                   // Update the Segment Control UI
            }
        } else {                                                                                    // If the didn't complete the swipe to the next page
            if let currentPage = previousViewControllers.first,                                     // Get the view controller of the page we are viewing
                let index = kitchenPages.firstIndex(of: currentPage as! KitchenViewController) {    // Get the index of the view controller
                self.pageIndex = index                                                              // Keep track of the index
                segmentControl.selectedSegmentioIndex = pageIndex                                   // Update the Segment Control UI
            }
        }
    }
}



extension KitchenPageViewController: KitchenCollectionViewCellDelegate {
    
    /// Segue's to the detail view of the Item the user selected
    ///
    /// - Parameter item: Item the user wants to edit
    func userSelectedItem(item: KitchenItem) {
        let detailVC = KitchenDetailViewController()                                               // Create the detail view
        detailVC.item = item                                                                // Set the Item the user wants to edit
        self.navigationController?.pushViewController(detailVC, animated: true)             // Show the detail view
    }
}
