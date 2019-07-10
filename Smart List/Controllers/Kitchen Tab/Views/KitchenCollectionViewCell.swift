//
//  KitchenCollectionViewCell.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit


protocol KitchenCellDeleteDelegate : class {
    func deleteKitchenItem(button: UIButton)
}


class KitchenCollectionViewCell: UICollectionViewCell {
    
    //
    // MARK: - PROPERTIES
    //
    var deleteDelegate : KitchenCellDeleteDelegate?
    var spinnerContainer = UIView()
    var spinner : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    //
    // MARK: - UIViews
    //
    var itemImageView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Groceries"
        
        return label
    }()
    
    var expiryLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .red
        label.text = "Set an expiration date"
        
        return label
    }()

    
    var deleteButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.text = ""
        button.imageView?.isHidden = false
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        button.tintColor = Constants.ColorPalette.Orange
        
        return button
    }()
    
    
    //
    // MARK: - Initializers
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //
    // MARK: - UIView initializers
    //
    func setupViews() {
        addSubview(itemImageView)
        addSubview(nameLabel)
        addSubview(expiryLabel)
        addSubview(deleteButton)
        
        setImageViewConstraints()
        setNameLabelConstraints()
        setExpiryLabelConstraints()
        setDeleteButtonConstraints()
    }
    
    //
    // MARK: - Constraints
    //
    func setImageViewConstraints() {
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: topAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor)
            ])
    }
    
    func setNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: expiryLabel.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
    }
    
    func setExpiryLabelConstraints() {
        NSLayoutConstraint.activate([
            expiryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            expiryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            expiryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            expiryLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
    }
    
    func setDeleteButtonConstraints() {
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),
            deleteButton.widthAnchor.constraint(equalToConstant: 20)
            ])
    }
    
    @objc func deleteButtonTapped() {
        self.deleteDelegate?.deleteKitchenItem(button: self.deleteButton)
    }
}
