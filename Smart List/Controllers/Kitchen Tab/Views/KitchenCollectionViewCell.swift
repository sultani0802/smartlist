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
		button.tintColor = Constants.Visuals.ColorPalette.Orange
        
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
		contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(expiryLabel)
        contentView.addSubview(deleteButton)
        
        setImageViewConstraints()
        setNameLabelConstraints()
        setExpiryLabelConstraints()
        setDeleteButtonConstraints()
		
		self.contentView.backgroundColor = .white
		self.contentView.layer.cornerRadius = 10.0
		self.contentView.layer.masksToBounds = true		// The views added to the content view conform to the cell's customized layer
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
		self.layer.shadowRadius = 1.0
		self.layer.shadowOpacity = 0.35
		self.layer.masksToBounds = false
		self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
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
