//
//  DetailMidContainer.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class DetailMidContainer: UIView {
    
    /****************************************/
    //MARK: - 1: Item Name And Quantity
    /****************************************/
    var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.text = "Tomato"
		label.textColor = Constants.Visuals.ColorPalette.TealBlue
        label.adjustsFontSizeToFitWidth = true
        
        if Constants.DeviceType.IS_IPHONE_5 {
            label.font = UIFont(name: Constants.Visuals.fontName, size: 28)
        } else {
            label.font = UIFont(name: Constants.Visuals.fontName, size: 35)
        }
        
        return label
    }()
    
    var quantityButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("tap here change quantity", for: .normal)
        button.sizeToFit()
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
        button.addTarget(self, action: #selector(DetailVC.quantityButtonTapped(_:)), for: .touchUpInside)
        
        if Constants.DeviceType.IS_IPHONE_5 {
            button.titleLabel?.font = UIFont(name: Constants.Visuals.fontName, size: 15)
        } else {
            button.titleLabel?.font = UIFont(name: Constants.Visuals.fontName, size: 20)
        }
        
        return button
    }()
    
    var titleStackView: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = UIStackView.Alignment.center
        view.distribution = .fill
        view.spacing = 0
        
        return view
    }()
    
    
    /****************************************/
    //MARK: - 2: Date Of Purchase And Store
    /****************************************/
    var purchasedLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Purchased"
        label.textAlignment = .left
		label.textColor = Constants.Visuals.ColorPalette.TealBlue
        
        if Constants.DeviceType.IS_IPHONE_5 {
            label.font = UIFont(name: Constants.Visuals.fontName, size: 20)
        } else {
            label.font = UIFont(name: Constants.Visuals.fontName, size: 28)
        }
        
        return label
    }()
    
    var purchaseDate: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Today"
        label.textAlignment = .left
		label.textColor = Constants.Visuals.ColorPalette.BabyBlue
        label.adjustsFontSizeToFitWidth = true
        
        if Constants.DeviceType.IS_IPHONE_5 {
            label.font = UIFont(name: Constants.Visuals.fontName, size: 15)
        }
        else {
            label.font = UIFont(name: Constants.Visuals.fontName, size: 20)
        }
        
        return label
    }()
    
    var storeTextField: UITextField = {
        var textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Store"
        textfield.textColor = .gray
        textfield.textAlignment = .center
        textfield.adjustsFontSizeToFitWidth = true
        textfield.returnKeyType = .done
        
        if Constants.DeviceType.IS_IPHONE_5 {
            textfield.font = UIFont(name: Constants.Visuals.fontName, size: 12)
        }
        else {
            textfield.font = UIFont(name: Constants.Visuals.fontName, size: 16)
        }
        
        return textfield
    }()
    
    var purchaseStackView: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .bottom
        view.distribution = .fill
        view.spacing = 8
        
        return view
    }()
    
    /****************************************/
    //MARK: - 3: Expiration Date
    /****************************************/
    var expiryLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Expires"
        label.textAlignment = .left
		label.textColor = Constants.Visuals.ColorPalette.TealBlue
        label.font = UIFont(name: Constants.Visuals.fontName, size: 28)

        return label
    }()
    
    var expiryDate: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tap to set expiry", for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont(name: Constants.Visuals.fontName, size: 20)
        button.addTarget(self, action: #selector(DetailVC.expiryButtonTapped(_:)), for: .touchUpInside)

        return button
    }()
    
    
    
    var expiryStackView: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .bottom
        view.distribution = .fill
        view.spacing = 4
        
        return view
    }()
    
    /****************************************/
    //MARK: - 4: Notes Section
    /****************************************/
    var notesLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notes"
        label.textAlignment = .left
		label.textColor = Constants.Visuals.ColorPalette.TealBlue
        label.font = UIFont(name: Constants.Visuals.fontName, size: 28)

        return label
    }()
    
    var noteTextView: UITextView = {
        var view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.sizeToFit()
        view.isEditable = true
        view.isScrollEnabled = false
        view.text = "Here is some text about this food"
        view.textAlignment = .left
        view.addDoneToolbar()
        
        // Draw border for the notes section
		view.borders(for: [.all], width: 0.5, color: Constants.Visuals.ColorPalette.TealBlue.withAlphaComponent(0.18))
        
        return view
    }()
    
    
    
    /****************************************/
    //MARK: - 5: Nutrition Section
    /****************************************/
    var nutriLabel : UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Nutrition Facts"
        
        return view
    }()
    
    /****************************************/
    //MARK: - Whole Stack View
    /****************************************/
    var stackView: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 7
        
        return view
    }()
    
    


    //MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Initializers
    func setupViews() {
        // 1
        titleStackView.addArrangedSubview(nameLabel)
        titleStackView.addArrangedSubview(quantityButton)
        stackView.addArrangedSubview(titleStackView)
        
        // 2
        purchaseStackView.addArrangedSubview(purchasedLabel)
        purchaseStackView.addArrangedSubview(purchaseDate)
        purchaseStackView.addArrangedSubview(storeTextField)
        stackView.addArrangedSubview(purchaseStackView)
        
        // 3
        expiryStackView.addArrangedSubview(expiryLabel)
        expiryStackView.addArrangedSubview(expiryDate)
        stackView.addArrangedSubview(expiryStackView)
        
        // 4
        stackView.addArrangedSubview(notesLabel)
        stackView.addArrangedSubview(noteTextView)
        
        

        // Whole Stack View
        addSubview(stackView)
        setupConstraints()
    }
    
    func setupConstraints() {
        // Constraints applied to the whole stack view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        // Constraints applied to each nested stack view to fill the width of whole stack view
        NSLayoutConstraint.activate([
            titleStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            purchaseStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            expiryStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            notesLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            noteTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
            ])
        
        titlePriority()
        purchasePriority()
        expiryPriority()
    }
    
    func titlePriority() {
        quantityButton.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
        quantityButton.widthAnchor.constraint(greaterThanOrEqualTo: titleStackView.widthAnchor, multiplier: 0.3).isActive = true
        quantityButton.setContentHuggingPriority(UILayoutPriority(995), for: .horizontal)
    }
    
    func purchasePriority() {
        purchaseDate.setContentHuggingPriority(UILayoutPriority(995), for: .horizontal)
        storeTextField.setContentHuggingPriority(UILayoutPriority(990), for: .horizontal)
        storeTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
    }
    
    func expiryPriority() {
        expiryLabel.setContentHuggingPriority(UILayoutPriority(990), for: .horizontal)
        expiryDate.setContentHuggingPriority(UILayoutPriority(995), for: .horizontal)
    }
}
