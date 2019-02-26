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
    
    
    
    
    
    
    //MARK: - View Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize nav bar elements
        self.navigationItem.title = item?.name
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .white
        
        quantityView.quantityTextField.delegate = self
        
        setupViews()
        setupModels()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        abbreviateUnit(u: (item?.quantity)!)
        loadQuantityPopUpModel()
    }
    
    
    
    
    //MARK: - Initializers
    func setupModels() {
        // Populate the Units of measurement array
        units.append(contentsOf: Constants.Units.keys)
        
        // Set the name of the Item
        midContainer.nameLabel.text = item?.name
        // Set the quantity of the Item
        midContainer.quantityButton.setTitle(item?.quantity, for: .normal)
        
        // Set the dates for the Item
        setItemDates()
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
    
    
    
    
    
    
    //MARK: - My Methods
    
    /// Sets up the date elements of the Detail View
    func setItemDates() {
        if let date = item?.purchaseDate { // Get the Item's purchaseDate if it hasn't been set
            midContainer.purchaseDate.text = DateHelper.shared.getDateString(of: date)
        } else { // If it hasn't been set, display a message
            midContainer.purchaseDate.text = "Not purchased yet"
        }
    }
    
    func abbreviateUnit(u : String) {
        let components = u.components(separatedBy: " ") // Separate the numeral and unit
        let unit : String = components[1]               // Grab the unit
        let shortUnit : String = Constants.Units[unit]! // Grab the short-hand version of it
        
        let result = components[0] + " " + shortUnit    // Combine the numeral and short-hand unit
        self.midContainer.quantityButton.setTitle(result, for: .normal) // Change the view
    }
    
    func loadQuantityPopUpModel() {
        // Scroll the pickerview to the corresponding unit of measurement in the pop up view
        guard let components = item?.quantity?.components(separatedBy: " ") else {return}
        if components.count == 2 {
            let unit = components[1]
            guard let unitIndex = units.firstIndex(of: unit) else {return}

            quantityView.pickerView.selectRow(unitIndex, inComponent: 0, animated: true)
            quantityView.quantityTextField.text = components[0]
        }
    }
}
