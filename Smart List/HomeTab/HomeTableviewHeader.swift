//
//  HomeTableviewHeader.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit
import SwipeCellKit

class HomeTableviewHeader: UITableViewHeaderFooterView {
    
    //MARK: - UI Elements
    var separatorView: UIView = {
        var view = UIView()
        
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let title: UILabel = {
        var lbl = UILabel()
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = Constants.ColorPalette.Charcoal
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        
        return lbl
    }()
    
    
    
    
    //MARK: - Init Methods
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupUI() {
        // Edit view's visual settings
        
        self.contentView.backgroundColor = .white
        
        // Adding the UI elements to our header
        addSubview(separatorView)
        addSubview(title)
        
        // Setting up the constraints
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.topAnchor.constraint(equalTo: self.topAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.2)
            ])
        
        // The reason why I had to create a variable for the leading anchor constraint
        // is because Swift was throwing a warning for conflicting layout constraints
        // I had to set the priority to fix the error
        let titleLeadingAnchorConstraint = title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18)
        titleLeadingAnchorConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            titleLeadingAnchorConstraint,
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        
    }
}
