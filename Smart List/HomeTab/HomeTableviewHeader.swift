//
//  HomeTableviewHeader.swift
//  Smart List
//
//  Created by Haamed Sultani on Jan/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class HomeTableviewHeader: UITableViewHeaderFooterView {
    
    //MARK: - UI Elements
    let title: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.black
        
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
        self.contentView.backgroundColor = .lightGray
        
        // Adding the UI elements to our header
        addSubview(title)
        
        // Setting up the constraints
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
}
