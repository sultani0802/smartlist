//
//  DetailView.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class DetailViewController: DetailVC {
    
    //MARK: - Data Source
    var item : Item?
    
    //MARK: - View Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = item?.name
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //TO-DO: move over
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Server.shared.getItemFullURL(item: self.item!.name!) { imageURL in                  // Set the image of the Item based of Nutritionix pic
            
            if imageURL != "" || !imageURL.isEmpty{
                self.topContainer.itemImageView.kf.setImage(with: URL(string: imageURL))    // Set detail view's image to downloaded image
            } else {
                self.topContainer.itemImageView.image = UIImage(named: "groceries")         // Else, set it to default 'groceries' image from assets
            }
        }
        
        loadQuantityPopUpModel()
        loadExpiryPopUpModel()
        
        self.midContainer.quantityButton.setTitle(UnitHelper.shared.abbreviateUnit(u: ((self.item?.quantity)!)), for: .normal)
        updateUnitDataSource()
        loadItemNotes()
        loadPurchaseStore()
    }

    
    
    //MARK: - Initializers
    override func setupModels() {
        // Populate the Units of measurement array
        originalUnits.append(contentsOf: Constants.Units.keys)
        workingUnits.append(contentsOf: originalUnits)
        
        // Set the name of the Item
        midContainer.nameLabel.text = item?.name
        // Set the quantity of the Item
        midContainer.quantityButton.setTitle(item?.quantity, for: .normal)
        
        // Set the dates for the Item
        setItemDates()
        
        // Set the image for the Item
        setItemImage()
    }
    
    
    
    //
    // MARK: - My Methods
    //
    /// Sets up the date elements of the Detail View
    override func setItemDates() {
        //
        // Item's Purchase Date property
        //
        if let purchaseDate = item?.purchaseDate {  // Get the Item's purchaseDate
            midContainer.purchaseDate.text = DateHelper.shared.getDateString(of: purchaseDate)
        } else { // If it hasn't been set, display a message
            midContainer.purchaseDate.text = "Not purchased yet"
        }
        
        //
        // The Item's Expiration Date property
        //
        if let expiryDate = item?.expiryDate {      // Get the Item's expiration date
            midContainer.expiryDate.setTitle(DateHelper.shared.getDateString(of: expiryDate), for: .normal)     // Get a readable, string version of the date if it was set
        } else {
            midContainer.expiryDate.setTitle("Tap to set expiry", for: .normal)         // If it wasn't set, display a message
        }
    }
    
    
    /// Set the image in the top container of detail view controller
    func setItemImage() {
        if self.item?.imageFullURL == nil || (self.item?.imageFullURL!.isEmpty)! {                      // If Item entity doesn't have the image URL
            Server.shared.getItemFullURL(item: self.item!.name!) { imageURL in                          // Set the image of the Item based of Nutritionix pic
                
                if imageURL != "" || !imageURL.isEmpty{
                    self.topContainer.itemImageView.kf.setImage(with: URL(string: imageURL))            // Set detail view's image to downloaded image
                } else {
                    self.topContainer.itemImageView.image = UIImage(named: "groceries")                 // Else, set it to default 'groceries' image from assets
                }
            }
        } else {
            self.topContainer.itemImageView.kf.setImage(with: URL(string: self.item!.imageFullURL!))    // Set the image to the Item entity's saved image URL
        }
    }
    
    
    /// Gets the data saved to the Item entity and populates the textfield
    /// and pickerview with the corresponding info
    override func loadQuantityPopUpModel() {
        // Scroll the pickerview to the corresponding unit of measurement in the pop up view
        guard let components = item?.quantity?.components(separatedBy: " ") else {return}   // Safely separate the quantity string from the Item entity into an array
        if components.count == 2 {                                                          // If there are 2 words in the array
            let unit = components[1]                                                        // grab the second index of the array (which should be the unit of measurement)
            guard let unitIndex = workingUnits.firstIndex(of: unit) else {return}           // Grab the index of the unit in the working model
            
            // Scroll pickerview to the corresponding unit
            quantityView.quantityTextField.text = components[0]                             // Change the text in the quantity textfield to what is saved in the Item entity
            quantityView.pickerView.selectRow(unitIndex, inComponent: 0, animated: true)    // Scroll to the appropriate index
        }
    }
    
    /// Gets the expiration date saved for the Item entity
    /// Scrolls the datepicker to the Data we just loaded
    override func loadExpiryPopUpModel() {
        guard let expiryDate : Date = self.item?.expiryDate else {return}
        
        expiryDateView.datePicker.setDate(expiryDate, animated: true)
    }
    
    /// Loads the Notes and is displayed onto the notes section
    override func loadItemNotes() {
        if let notes = self.item?.notes {
            self.midContainer.noteTextView.text = notes
        } else {
            self.midContainer.noteTextView.text = Constants.DetailView.notesPlaceholder
        }
    }
    
    override func loadPurchaseStore() {
        if let store = self.item?.store {
            midContainer.storeTextField.text = store
        }
    }
    
    
    
}
