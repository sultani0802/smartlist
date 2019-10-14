//
//  HomeTableViewCell.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.

import UIKit
import SwipeCellKit


// This protocol is used to pass information from the viewController
// that contains the tableView in which this Cell is a part of
//
// The tableView conforms to this protocol so that it the
// viewController can set the closure 'addNewCell'
protocol HomeTableViewCellDelegate: class {
    
    // Called when the user finished typing
    func didEndEditing(onCell cell: HomeTableViewCell)
}

protocol ScannerDelegate : class {
    func scanBarcode(cell: HomeTableViewCell)
}


class HomeTableViewCell: SwipeTableViewCell {
    
    // Variable used to keep track of whether the user purchased the Item
    // With this variable, the cell's accessory type is defined and set to either a checkmark or none
    var completed: Bool = false
    
    // The delegate class (the HomeTableViewController)
    // This will be set in cellForRowAt()
    weak var textDelegate : HomeTableViewCellDelegate?
    weak var scannerDelegate : ScannerDelegate?
    
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
    
    var scannerButton : UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "barcode"), for: .normal)
        button.isHidden = true
        button.sizeToFit()
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        
        return button
    }()
    
    
    //MARK: - Callbacks
    // This is called when the user hits 'Enter' on the keyboard
    var addNewCell : ((_ text: String) -> Void)?
    var scannerTapped : (() -> ())?
    
    
    //MARK: - Init Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameText.delegate = self
        scannerButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        
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
//        addSubview(scannerButton)
        
        // Setting up the constraints
        NSLayoutConstraint.activate([
            
            // Item's image
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            itemImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            itemImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            itemImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            
            // Scanner Button
//            scannerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
//            scannerButton.topAnchor.constraint(equalTo: topAnchor, constant: 15),
//            scannerButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
//            scannerButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            
            // Item's name textfield
            nameText.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 4),
            nameText.topAnchor.constraint(equalTo: topAnchor),
            nameText.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameText.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    
    @objc func scanButtonTapped() {
        scannerDelegate?.scanBarcode(cell: self)
    }
}
