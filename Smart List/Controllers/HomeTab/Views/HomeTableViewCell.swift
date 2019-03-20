//
//  HomeTableViewCell.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.

import UIKit
import SwipeCellKit



protocol HomeTableViewCellDelegate: class {
    
    // Called when the user finished typing
    func didEndEditing(onCell cell: HomeTableViewCell)
}




class HomeTableViewCell: SwipeTableViewCell {
    
    // Variable used to keep track of whether the user purchased the Item
    // With this variable, the cell's accessory type is defined and set to either a checkmark or none
    var completed: Bool = false
    
    // The delegate class (the HomeTableViewController)
    // This will be set in cellForRowAt()
    weak var textDelegate: HomeTableViewCellDelegate?
    
    
    
    //MARK: - UI Elements
    var nameText: UITextField = {
        var textField = UITextField()
        textField.returnKeyType = .done                                 // Change the return key to "Done" instead of "return"
        textField.translatesAutoresizingMaskIntoConstraints = false     // Use Auto Layout
        textField.textAlignment = .left
        textField.adjustsFontSizeToFitWidth = true
        textField.font = UIFont(name: Constants.Visuals.fontName, size: 20)
        textField.textColor = Constants.ColorPalette.TealBlue
        textField.setRightPaddingPoints(55)                             // Add padding to the right side
        textField.attributedPlaceholder = NSAttributedString(string: "tap here to start",
                                                             attributes: [
                                                                NSAttributedString.Key.foregroundColor: Constants.ColorPalette.BabyBlue]) // Set placeholder text for the cell
        
        return textField
    }()
    
    var itemImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    var quantityLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.text = ""
        label.borders(for: [.left], width: 0.5, color: .black)
        
        if DeviceType.IS_IPHONE_5 {
            label.font = UIFont(name: Constants.Visuals.fontName, size: 15)
        }
        else {
            label.font = UIFont(name: Constants.Visuals.fontName, size: 20)
        }
        
        return label
    }()
    
    
    
    //MARK: - Callbacks
    // This is called when the user hits 'Enter' on the keyboard
    var addNewCell: ((_ text: String) -> Void)?
    
    
    //MARK: - Init Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameText.delegate = self
        
        // Configure UI elements
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func setupUI() {
        // Customize View visual
        self.backgroundColor = .white
        
        // Adding the UI elements to our cell
        addSubview(itemImageView)
        addSubview(nameText)
        
        // Setting up the constraints
        NSLayoutConstraint.activate([
            
            // Item's image
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            itemImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            itemImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            itemImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            
            
            // Item's name textfield
            nameText.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 4),
            nameText.topAnchor.constraint(equalTo: topAnchor),
            nameText.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameText.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}
