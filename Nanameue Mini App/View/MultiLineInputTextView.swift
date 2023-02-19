//
//  MultiLineInputTextView.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-15.
//

import Foundation
import UIKit

class MultiLineInputTextView: UITextView {
    
    //MARK: - Properties
    
    var placeHolderText: String? {
        didSet {placeHolderLabel.text = placeHolderText}
    }
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "lite_gray_2")
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 6)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MultiLineTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func MultiLineTextChange() {
        placeHolderLabel.isHidden = !text.isEmpty
    }
    
}
