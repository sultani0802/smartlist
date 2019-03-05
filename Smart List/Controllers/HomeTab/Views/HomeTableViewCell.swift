//
//  HomeTableViewCell.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.

import UIKit
import SwipeCellKit

class HomeTableViewCell: SwipeTableViewCell {
    
    var completed: Bool = false
    
    //MARK: - UI Elements
    var nameText: UITextField = {
        var textField = UITextField()
        textField.returnKeyType = .done // Change the return key to "Done" instead of "return"
        textField.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
        textField.textAlignment = .left
        textField.textColor = Constants.ColorPalette.DarkGray
        textField.setRightPaddingPoints(55) // Add padding to the right side
        textField.attributedPlaceholder = NSAttributedString(string: "tap here to start",
                                                             attributes: [
                                                                NSAttributedString.Key.foregroundColor: Constants.ColorPalette.BabyBlue]) // Set placeholder text for the cell
        
        return textField
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
        addSubview(nameText)
        
        // Setting up the constraints
        NSLayoutConstraint.activate([
            nameText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            nameText.topAnchor.constraint(equalTo: topAnchor),
            nameText.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameText.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}





extension HomeTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(completed)
        self.accessoryType = .detailDisclosureButton
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(completed)
        self.accessoryType = self.completed ? .checkmark : .none
    }
    
    // This delegate method is called when the user hits 'Enter' when they're done typing in the item
    // Once they are done adding an item to the list it creates a new empty cell below it
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameText.resignFirstResponder() // Hide the keyboard
        addNewCell?(nameText.text!)       // Call the callback
        
        return true
    }
    
    /// Limits the number of characters the user can type (24)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        
        return newLength <= 18
    }
}
