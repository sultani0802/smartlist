//
//  ProfileTableViewCell.swift
//  Smart List
//
//  Created by Haamed Sultani on Jun/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    //MARK: - UI Elements
    var titleLabel : UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false               // Label uses auto-layout
        lbl.textAlignment = .left                                           // Text aligned to the left
        lbl.adjustsFontSizeToFitWidth = true                                // Adjust font size to fit cell
        lbl.font = UIFont(name: Constants.Visuals.fontName, size: 20)       // Set font
        lbl.textColor = Constants.ColorPalette.Charcoal                     // Set color
        
        return lbl
    }()
    
    var contentLabel: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false               // Label uses auto-layout
        lbl.textAlignment = .left                                           // Text aligned to the left
        lbl.adjustsFontSizeToFitWidth = true                                // Adjust font size to fit cell
        lbl.font = UIFont(name: Constants.Visuals.fontName, size: 18)       // Set font
        lbl.textColor = Constants.ColorPalette.BabyBlue                      // Set color
        
        return lbl
    }()
    
    
    //MARK: - UIView Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - UI Setup
    func setupUI() {
        self.backgroundColor = .white                                                   // Set background color to white
        
        addSubview(titleLabel)                                                          // Add title to view
        addSubview(contentLabel)
        
        NSLayoutConstraint.activate([                                                   // Set constraints for title
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([                                                   // Set constraints for label
            NSLayoutConstraint(item: contentLabel, attribute: .left, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 8),
            contentLabel.topAnchor.constraint(equalTo: topAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}
