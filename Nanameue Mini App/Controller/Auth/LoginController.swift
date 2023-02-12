//
//  LoginController.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-12.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private let iconImageView: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "AppIcon"))
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Connect with friends and family like never before with Minigram"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = -1
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = CustomTextField(placeholderText: "Email")
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = CustomTextField(placeholderText: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "main_color")
        button.setTitle("Log in", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 25
        button.isUserInteractionEnabled = true
        button.setHeight(55)
        return button
    }()
    
    private let signupLabelButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray2, .font: UIFont.systemFont(ofSize: 16)]
        
        let attributedFirstText = NSMutableAttributedString(string: "Don't have an account? ", attributes: attribute)
        
        let boldAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray, .font: UIFont.boldSystemFont(ofSize: 16)]
        
        attributedFirstText.append(NSMutableAttributedString(string: "Sign Up", attributes: boldAttribute))
       
        button.setAttributedTitle(attributedFirstText, for: .normal)
        
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
         initUI()
    }
    
    //MARK: - Helper functions
    
    func initUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view)
        iconImageView.setDimensions(height: 50, width: 50)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
         
        view.addSubview(titleLabel)
        titleLabel.anchor(top: iconImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 48, paddingLeft: 16, paddingRight: 16)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 48, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(signupLabelButton)
//        view.centerX(inView: view)
        signupLabelButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
    }
    
}
