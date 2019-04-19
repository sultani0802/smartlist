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
        
//        cell.itemImageView.image = UIImage(named: item.imageName ?? "groceries")
        
//        func setItemImage() {
//            if self.item?.imageFullURL == nil || (self.item?.imageFullURL!.isEmpty)! {
//                Server.shared.getItemFullURL(item: self.item!.name!) { imageURL in                  // Set the image of the Item based of Nutritionix pic
//
//                    if imageURL != "" || !imageURL.isEmpty{
//                        self.topContainer.itemImageView.kf.setImage(with: URL(string: imageURL))    // Set detail view's image to downloaded image
//                    } else {
//                        self.topContainer.itemImageView.image = UIImage(named: "groceries")         // Else, set it to default 'groceries' image from assets
//                    }
//                }
//            } else {
//                self.topContainer.itemImageView.kf.setImage(with: URL(string: self.item!.imageFullURL!))
//            }
//        }
        
        if item.imageFullURL == nil || item.imageFullURL!.isEmpty {
            Server.shared.getItemFullURL(itemName: item.name!) { imageURL in                  // Set the image of the Item based of Nutritionix pic
                
                if imageURL != "" || !imageURL.isEmpty{
                    cell.itemImageView.kf.setImage(with: URL(string: imageURL))    // Set detail view's image to downloaded image
                } else {
                    cell.itemImageView.image = UIImage(named: "groceries")         // Else, set it to default 'groceries' image from assets
                }
            }
        } else {
            cell.itemImageView.kf.setImage(with: URL(string: item.imageFullURL!))
        }
        
        
        cell.nameLabel.text = item.name
        cell.deleteDelegate = self
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.isHidden = !editMode
        
        if let expiryDate = item.expiryDate {
            let date = DateHelper.shared.getDateString(of: expiryDate)
            
            if item.expiryDate != nil, item.expiryDate! > DateHelper.shared.getCurrentDateObject() {
                cell.expiryLabel.textColor = Constants.ColorPalette.SeaGreen
                cell.expiryLabel.text = "Expires \(date)"
            } else {
                cell.expiryLabel.textColor = Constants.ColorPalette.Crimson
                cell.expiryLabel.text = "Expired \(date)"
            }
            
        } else {
            cell.expiryLabel.text = "Set an expiration date"
            cell.expiryLabel.textColor = Constants.ColorPalette.BabyBlue
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
