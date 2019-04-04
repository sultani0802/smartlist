//
//  QuantityPopUpView.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class QuantityPopUpView: PopUpCardView {
    
    /****************************************/
    //MARK: - 1: Title Section
    /****************************************/
    var viewTitleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Quantity"
        label.textColor = Constants.ColorPalette.Orange
        label.font = UIFont(name: Constants.Visuals.fontName, size: 20)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        
        return label
    }()
    
    var saveButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.setTitleColor(Constants.ColorPalette.Charcoal, for: .normal)
        button.titleLabel!.font = UIFont(name: Constants.Visuals.fontName, size: 20)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(DetailVC.doneButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    var titleStackView: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 0
        
        return view
    }()
    
    
    /****************************************/
    //MARK: - 2: Quantity Section
    /****************************************/
    var quantityTextField: UITextField = {
        var textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.keyboardType = .decimalPad
        textfield.text = "0"
        textfield.font = UIFont(name: Constants.Visuals.fontName, size: 40)
        textfield.textColor = Constants.ColorPalette.Orange
        textfield.textAlignment = .center
        textfield.adjustsFontSizeToFitWidth = true
        textfield.borders(for: [.top, .right], width: 1, color: Constants.ColorPalette.Charcoal.withAlphaComponent(0.3))
        textfield.addDoneToolbar()
        
        
        return textfield
    }()
    
    
    
    /****************************************/
    //MARK: - 3: Picker View Section
    /****************************************/
    var pickerView: UIPickerView = {
        var picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.borders(for: [.top], width: 1, color: Constants.ColorPalette.Charcoal.withAlphaComponent(0.3))
        
        return picker
    }()
    
    
    
    //MARK: - Setup Methods
    override func setupUIComponents() {
        
        // Title Stack View
        titleStackView.addArrangedSubview(viewTitleLabel)   // Add 'Quantity' title to stack
        titleStackView.addArrangedSubview(saveButton)       // Add SAVE button to stack
        addSubview(titleStackView)                          // Add the stack to the view
        
        // Button's height = 'Quantity' label height
        saveButton.heightAnchor.constraint(equalTo: viewTitleLabel.heightAnchor).isActive = true
        // Set the width of the stack's components
        saveButton.widthAnchor.constraint(equalTo: titleStackView.widthAnchor, multiplier: 0.3).isActive = true
        viewTitleLabel.widthAnchor.constraint(equalTo: titleStackView.widthAnchor, multiplier: 0.7).isActive = true
        // Activate the constraints on the stackview
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15)
            ])
        
        
        // Quantity Field
        addSubview(quantityTextField)                   // Add the textfield to the view
        
        // Activate the textfield constraints
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: quantityTextField, attribute: .top, relatedBy: .equal, toItem: titleStackView, attribute: .bottom, multiplier: 1.0, constant: 0),
            quantityTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            quantityTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            quantityTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
            ])
        
        // Picker View
        addSubview(pickerView)                          // Add the pickerview to the view
        
        // Activate the pickerview constraints
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: pickerView, attribute: .top, relatedBy: .equal, toItem: titleStackView, attribute: .bottom, multiplier: 1, constant: 0),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            NSLayoutConstraint(item: pickerView, attribute: .leading, relatedBy: .equal, toItem: quantityTextField, attribute: .trailing, multiplier: 1, constant: 0)
            ])
    }
}
