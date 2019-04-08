//
//  KitchenCollectionViewCell.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class KitchenCollectionViewCell: UICollectionViewCell {
    
    //
    // MARK: - UIViews
    //
    var itemImageView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "groceries")
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
        label.text = "Set an expiration date"
        
        return label
    }()
    
    var blurView: UIVisualEffectView = {
        var blur = UIBlurEffect(style: .dark)
        var view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var deleteButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.text = ""
        
        
        return button
    }()
    
    
    //
    // MARK: - Initializers
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        addSubview(blurView)
        
        setImageViewConstraints()
        setNameLabelConstraints()
        setExpiryLabelConstraints()
        setBlurConstraints()
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
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
    }
    
    func setExpiryLabelConstraints() {
        NSLayoutConstraint.activate([
            expiryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            expiryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            expiryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            expiryLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
    }
    
    func setBlurConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            blurView.heightAnchor.constraint(equalToConstant: 14),
            blurView.widthAnchor.constraint(equalToConstant: 14)
            ])
    }
}
