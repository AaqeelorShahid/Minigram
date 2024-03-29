//
//  CustomTextField.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-12.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    init(placeholderText: String) {
        super.init(frame: .zero)
        setHeight(50)
        
        let innerPadding = UIView()
        innerPadding.setDimensions(height: 50, width: 12)
        leftView = innerPadding
        leftViewMode = .always
        
        borderStyle = .none
        keyboardAppearance = .dark
        textColor = .black
        autocapitalizationType = .none
        
        layer.cornerRadius = 12
        layer.borderColor = UIColor(named: "lite_gray_2")!.cgColor
        layer.borderWidth = 1
        
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: UIColor(named: "lite_gray_2")])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
