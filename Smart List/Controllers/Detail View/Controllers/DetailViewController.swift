//
//  DetailView.swift
//  Smart List
//
//  Created by Haamed Sultani on Feb/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: - Variables
    var units = [String]()
    
    //MARK: - Views
    var topContainer: DetailTopContainer = {
        var view = DetailTopContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var midContainer: DetailMidContainer = {
        var view = DetailMidContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    // Pop Up View for quantity button
    var quantityView: QuantityPopUpView = {
        var view = QuantityPopUpView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    //MARK: - Data Source
    var item : Item?
    
    
    //MARK: - Constructors
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize nav bar elements
        self.navigationItem.title = item?.name
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .white
        
        setupViews()
        setupModels()
    }
    
    
    //MARK: - Initializers
    func setupModels() {
        // Populate the Units of measurement array
        units.append(contentsOf: Constants.Units.LiquidsPlural)
        units.append(contentsOf: Constants.Units.WeightsPlural)
        units.append(contentsOf: Constants.Units.Other)
        
        // Set the name of the Item
        midContainer.nameLabel.text = item?.name
        
        // Set the Expiry date to today's date
        if let date = item?.date {
            midContainer.expiryDate.setTitle(DateHelper.shared.getDateString(of: date), for: .normal)
        } else {
            midContainer.expiryDate.setTitle(DateHelper.shared.getCurrentDate(), for: .normal)
        }
    }
    
    
    
    var datePicker: UIDatePicker = {
        var picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        
        return picker
    }()
    
    
    func setupViews() {
        view.addSubview(topContainer)
        view.addSubview(midContainer)
        view.addSubview(datePicker)
        view.addSubview(quantityView)
        
        setupConstraints()
        
        quantityView.pickerView.dataSource = self
        quantityView.pickerView.delegate = self
        quantityView.quantityTextField.delegate = self
    }
    
    func setupConstraints() {
        // Top Container
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            topContainer.heightAnchor.constraint(greaterThanOrEqualTo: topContainer.widthAnchor, constant: 0)
            ])
        
        // Mid Container
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: midContainer, attribute: .top, relatedBy: .equal, toItem: topContainer, attribute: .bottom, multiplier: 1, constant: 30),
            midContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            midContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
            ])
        
        NSLayoutConstraint.activate([
            datePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 100)
            ])
        
        // Quantity Pop Up View
        NSLayoutConstraint.activate([
            quantityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quantityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            quantityView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            quantityView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
            ])
    }
    
}
