//
//  ALTextField.swift
//  GHFollowers
//
//  Created by Jeff Morhous on 4/9/20.
//  Copyright © 2020 Jeff Morhous. All rights reserved.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //Custom code
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false //For autolayout
        
        layer.cornerRadius = 10 //Rounded
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        returnKeyType = .go
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no //Disable autocorrect
        placeholder = "Enter a username"
    }
}
