//
//  SignUpView.swift
//  Smart List
//
//  Created by Haamed Sultani on Jun/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class SignUpTopContainer: UIView {
    //MARK: - UI Elements
    var iconImageView : UIImageView = {
        var imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imgView.loadGif(name: "cook")
        
        return imgView
    }()
    
    
    var titleLabel : UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "Smart Kitchen"
        lbl.font = UIFont(name: Constants.Visuals.fontName, size: 28)
        lbl.textColor = Constants.ColorPalette.TealBlue
        lbl.adjustsFontSizeToFitWidth = true

        return lbl
    }()
    
    var subtitleLabel : UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "Your kitchen under control"
        lbl.font = UIFont(name: Constants.Visuals.fontName, size: 16)
        lbl.textColor = .gray
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    
    var textStack: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = UIStackView.Alignment.center
        view.distribution = UIStackView.Distribution.fillEqually
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(iconImageView)                       // Adding imageView to UIView
        textStack.addArrangedSubview(titleLabel)        // Adding title to stackView
        textStack.addArrangedSubview(subtitleLabel)     // Adding subtitle to stackView
        addSubview(textStack)                           // Adding stackView to UIView
        
        // Constraints for imageView
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            iconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.80)
            ])
        
        

        // Constraints for title stack view
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: textStack, attribute: .top, relatedBy: .equal, toItem: iconImageView, attribute: .bottom, multiplier: 1, constant: 0),
            textStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            textStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            textStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.20)
            ])
    }
}
