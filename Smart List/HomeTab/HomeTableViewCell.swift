//
//  HomeTableViewCell.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit
import SwipeCellKit

class HomeTableViewCell: SwipeTableViewCell {
    
    //MARK: - UI Elements
    var nameText: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "tap here to start"
        textField.textAlignment = .left
        
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
        // Adding the UI elements to our cell
        addSubview(nameText)
        
        // Setting up the constraints
        NSLayoutConstraint.activate([
            nameText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameText.topAnchor.constraint(equalTo: topAnchor),
            nameText.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameText.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    //MARK: - My Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("editing textfield")
    }
    
}


extension HomeTableViewCell: UITextFieldDelegate {
    // This delegate method is called when the user hits 'Enter' when they're done typing in the item
    // Once they are done adding an item to the list it creates a new empty cell below it
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameText.resignFirstResponder() // Hide the keyboard
        addNewCell?(nameText.text!)       // Call the callback
        
        return true
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("editing ended")
//    }
    
    
}

extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
