//
//  DetailViewProtocol.swift
//  Smart List
//
//  Created by Haamed Sultani on Apr/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    //MARK: - Variables
    var originalUnits = [String]()
    var workingUnits = [String]()
    
    // This variable is used to keep track of the tab bar's height
    // so that when the user is finished editing, the insets for this view
    // are maintained properly
    public var tabBarHeight: CGFloat?
    
    var activeText: UIView?
    
    
    //MARK: - Views
    var scrollView: UIScrollView = {
        var view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Save the height of the tab bar
        self.tabBarHeight = self.tabBarController!.tabBar.frame.height
        
        view.backgroundColor = .white
        
        quantityView.quantityTextField.delegate = self
        // Detect each time the user types in the quantity textfield
        quantityView.quantityTextField.addTarget(self, action: #selector(userTypedInTextfield(textField:)), for: .editingChanged)
        
        midContainer.noteTextView.delegate = self
        midContainer.storeTextField.delegate = self
        
        setupViews()
        setupModels()
        
        
        // Listen for keyboard events that will adjust the view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Hide the keyboard if the user taps outside the keyboard
        self.hideKeyboardWhenTappedAround()
    }
    
    deinit {
        // Unregister for the keyboard notifications. Therefore, stop listening for the events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false             // Make navigation bar title small
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true              // Make navigation bar title big
    }
    
    func setupModels() {
        
    }
    
    func setupViews() {
        setupConstraints()
        
        quantityView.pickerView.dataSource = self
        quantityView.pickerView.delegate = self
        quantityView.quantityTextField.delegate = self
    }
    
    func setupConstraints() {
        // Scroll View
        view.addSubview(scrollView) // Add the scrollView to the view
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        scrollView.addSubview(topContainer) // Add the top container (image view) to the Scroll View
        scrollView.addSubview(midContainer) // Add the mid container (stackview) to the Scroll View
        
        NSLayoutConstraint.activate([
            
            topContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            topContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            topContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            topContainer.heightAnchor.constraint(equalTo: topContainer.widthAnchor),
            
            
            
            NSLayoutConstraint(item: midContainer, attribute: .top, relatedBy: .equal, toItem: topContainer, attribute: .bottom, multiplier: 1, constant: 30),
            midContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            midContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            
            midContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            midContainer.rightAnchor.constraint(equalTo: scrollView.rightAnchor)
            ])
        
        
        
        scrollView.addSubview(quantityView)
        scrollView.addSubview(expiryDateView)
        
        // Quantity Pop Up View
        NSLayoutConstraint.activate([
            quantityView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            quantityView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            quantityView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.3),
            quantityView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8)
            ])
        
        
        // Expiration Date Pop Up View
        NSLayoutConstraint.activate([
            expiryDateView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            expiryDateView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            expiryDateView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.3),
            expiryDateView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8)
            ])
    }
    
    
    
    
    
    //MARK: - My Methods
    
    @objc func doneButtonTapped() {
        self.resignFirstResponder()
        
    }
    
    
    /// Sets up the date elements of the Detail View
    func setItemDates() {
        // To be implemented by the subclasses
    }
    
    
    /// This method goes through the unit of measurements array,
    /// checks if the
    func updateUnitDataSource() {
        // Update the working model of the unit measurements to the correct form (plural/singular)
        self.workingUnits = originalUnits.map { unit in
            
            // Go through each unit in the working model
            
            if unit.last == "s" && quantityView.quantityTextField.text == "1"{              // if the unit of measurement is plural & the item's quantity is = 1
                return String(unit.dropLast())                                              // change the unit of measurement in the working model to singular form
            } else if unit.last != "s" && quantityView.quantityTextField.text != "1"{       // if the unit of measurement is singular & the item's quantity is != 1
                return unit + "s"                                                           // change the unit of measurement to plural
            } else {
                return unit                                                                 // otherwise just return what is already there
            }
        }
        
        // Reload pickerview with the newly updated working model for the datasource
        quantityView.pickerView.reloadAllComponents()
    }
    
    
    /// Gets the data saved to the Item entity and populates the textfield
    /// and pickerview with the corresponding info
    func loadQuantityPopUpModel() {
        // To be implemented by the subclasses
    }
    
    
    /// Gets the expiration date saved for the Item entity
    /// Scrolls the datepicker to the Data we just loaded
    func loadExpiryPopUpModel() {
        // To be implemented by the subclasses
    }
    
    

    
    
    /// Loads the Notes and is displayed onto the notes section
    func loadItemNotes() {
        // To be implemented by the subclasses
    }
    
    func loadPurchaseStore() {
        // To be implemented by the subclasses
    }
}
