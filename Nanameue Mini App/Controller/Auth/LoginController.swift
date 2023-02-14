//
//  LoginController.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-12.
//

import Foundation
import UIKit

protocol AuthenticationDelegate {
    func authenticationCompleted()
}

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel =  LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let iconImageView: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "AppIcon"))
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.defaultTitleStyle(titleString: "Connect with friends and family like never before with Minigram")
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
        button.backgroundColor = UIColor(named: "sub_color")
        button.isEnabled = false
        button.setTitle("Log in", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 25
        button.setHeight(55)
        button.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let signupLabelButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedText(firstString: "Don't have an account? ", secondString: "Sign Up")
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(noAccountBtnPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        initUI()
        setNotificationObserverInField()
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
        signupLabelButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
    }
    
    
    func setNotificationObserverInField() {
        emailTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
    }
    
    //MARK: - Actions
    
    @objc func textChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = emailTextField.text
        } else {
            viewModel.password = passwordTextField.text
        }
        
        loginButton.backgroundColor = viewModel.btnBackgound
        loginButton.isEnabled = viewModel.isValid
    }
    
    @objc func loginBtnPressed() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        AuthenticationService.loginUser(withEmail: email, password: password) { result, err in
            
            if let error = err {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            self.delegate?.authenticationCompleted()
        }
    }
    
    @objc func noAccountBtnPressed() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
