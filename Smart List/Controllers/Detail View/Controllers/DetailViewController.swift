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
    var originalUnits = [String]()
    var workingUnits = [String]()
    
    
    
    
    
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
    
    
    // Pop Up View that is activated by the quanityButton
    var quantityView: QuantityPopUpView = {
        var view = QuantityPopUpView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    // Pop Up View that is activated by the expiryDateButton
    var expiryDateView: ExpiryPopUpView = {
       var view = ExpiryPopUpView()
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
        // Detect each time the user types in the quantity textfield
        quantityView.quantityTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        
        
        setupViews()
        setupModels()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadQuantityPopUpModel()
        loadExpiryPopUpModel()
        abbreviateUnit(u: (item?.quantity)!)
        updateUnitDataSource()
    }
    
    
    
    
    //MARK: - Initializers
    func setupModels() {
        // Populate the Units of measurement array
        originalUnits.append(contentsOf: Constants.Units.keys)
        workingUnits.append(contentsOf: originalUnits)
        
        // Set the name of the Item
        midContainer.nameLabel.text = item?.name
        // Set the quantity of the Item
        midContainer.quantityButton.setTitle(item?.quantity, for: .normal)
        
        // Set the dates for the Item
        setItemDates()
    }
    
    
    

    
    
    func setupViews() {
        view.addSubview(topContainer)
        view.addSubview(midContainer)
        view.addSubview(quantityView)
        view.addSubview(expiryDateView)
        
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
        
        
        // Quantity Pop Up View
        NSLayoutConstraint.activate([
            quantityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quantityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            quantityView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            quantityView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
            ])
        
        
        // Expiration Date Pop Up View
        NSLayoutConstraint.activate([
            expiryDateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            expiryDateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            expiryDateView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            expiryDateView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
            ])
    }
    
    
    
    
    
    
    //MARK: - My Methods
    
    /// Sets up the date elements of the Detail View
    func setItemDates() {
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
            midContainer.expiryDate.setTitle("Tap to set expiry", for: .normal) // If it wasn't set, display a message
        }
    }
    
    
    /// Converts the long version of the units to their short-hand/abbreviated version
    /// and makes it get reflected in the Detail View's quantity button
    ///
    /// - Parameter u: The quantity that is saved to the Item's entity
    func abbreviateUnit(u : String) {
        let components = u.components(separatedBy: " ") // Separate the numeral and unit
        let unit : String = components[1]               // Grab the unit
        print(unit)
        var shortUnit : String = Constants.Units[unit]! // Grab the short-hand version of it in Costants
        
        // Change unit to singular form iff quantity equals 1
        if components[0] == "1" && shortUnit.last == "s" {
            shortUnit = String(shortUnit.dropLast())
        }
        
        let result = components[0] + " " + shortUnit    // Combine the numeral and short-hand unit
        
        // Update the Quantity Button to reflect the abbreviation
        self.midContainer.quantityButton.setTitle(result, for: .normal)
    }
    
    
    
    /// This method goes through the unit of measurements array,
    /// checks if the
    func updateUnitDataSource() {
        // Update the working model of the unit measurements to the correct form (plural/singular)
        self.workingUnits = originalUnits.map { unit in
            
            // Go through each unit in the working model
            
            if unit.last == "s" && quantityView.quantityTextField.text == "1"{ // if the unit of measurement is plural & the item's quantity is = 1
                return String(unit.dropLast()) // change the unit of measurement in the working model to singular form
            } else if unit.last != "s" && quantityView.quantityTextField.text != "1"{ // if the unit of measurement is singular & the item's quantity is != 1
                return unit + "s" // change the unit of measurement to plural
            } else {
                return unit     // otherwise just return what is already there
            }
        }
        
        // Reload pickerview with the newly updated working model for the datasource
        quantityView.pickerView.reloadAllComponents()
    }
    
    
    /// Gets the data saved to the Item entity and populates the textfield
    /// and pickerview with the corresponding info
    func loadQuantityPopUpModel() {
        // Scroll the pickerview to the corresponding unit of measurement in the pop up view
        guard let components = item?.quantity?.components(separatedBy: " ") else {return}  // Safely separate the quantity string from the Item entity into an array
        if components.count == 2 {      // If there are 2 words in the array
            let unit = components[1]    // grab the second index of the array (which should be the unit of measurement)
            guard let unitIndex = workingUnits.firstIndex(of: unit) else {return}       // Grab the index of the unit in the working model
            
            // Scroll pickerview to the corresponding unit
            quantityView.quantityTextField.text = components[0]     // Change the text in the quantity textfield to what is saved in the Item entity
            quantityView.pickerView.selectRow(unitIndex, inComponent: 0, animated: true)    // Scroll to the appropriate index
        }
    }
    
    
    /// Gets the expiration date saved for the Item entity
    /// Scrolls the datepicker to the Data we just loaded
    func loadExpiryPopUpModel() {
        guard let expiryDate : Date = self.item?.expiryDate else {return}
        
        expiryDateView.datePicker.setDate(expiryDate, animated: true)
    }
}
