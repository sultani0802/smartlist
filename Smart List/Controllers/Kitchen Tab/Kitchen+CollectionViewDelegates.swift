//
//  Kitchen+CollectionViewDelegates.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

extension KitchenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellID.KitchenCollectionViewCellID, for: indexPath) as! KitchenCollectionViewCell
        let item = self.model[indexPath.row]
        
        cell.itemImageView.image = UIImage(named: item.imageName ?? "groceries")
        cell.nameLabel.text = item.name
        if let expiryDate = item.expiryDate {
            let date = DateHelper.shared.getDateString(of: expiryDate)
            
            if item.expiryDate != nil, item.expiryDate! > DateHelper.shared.getCurrentDateObject() {
                cell.expiryLabel.textColor = .black
                cell.expiryLabel.text = "Expires \(date)"
            } else {
                cell.expiryLabel.textColor = .red
                cell.expiryLabel.text = "Expired \(date)"
            }
            
        } else {
            cell.expiryLabel.text = "Set an expiration date"
            cell.expiryLabel.textColor = .blue
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = ScreenSize.SCREEN_WIDTH/2 - 5
        
        return CGSize(width: size, height: size)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = model[indexPath.row]                                 // The Item the user selected
        
        self.kitchenCellDelegate?.userSelectedItem(item: item)          // Call the delegate to segue
    }
}
