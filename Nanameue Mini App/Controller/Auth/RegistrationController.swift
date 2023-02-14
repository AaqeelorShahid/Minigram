//
//  RegistrationController.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-12.
//

import Foundation
import UIKit

class RegistrationController: UIViewController, UIPickerViewDelegate{
    //MARK: - Properties
    
    var delegate: AuthenticationDelegate?
    private var viewModel = RegistationViewModel()
    private var profileImage: UIImage?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.defaultTitleStyle(titleString: "Create your account")
        return label
    }()
    
    private let profileImageView : UIButton =  {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "profile_image_placeholder"), for: .normal)
        button.tintColor = UIColor(named: "main_color")
        button.addTarget(self, action: #selector(profileSelectionBtn), for: .touchUpInside)
        return button
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
    
    private let nameField: UITextField = {
        let textField = CustomTextField(placeholderText: "Name")
        textField.keyboardType = .default
        return textField
    }()
    
    private let usernameField: UITextField = {
        let textField = CustomTextField(placeholderText: "Username")
        textField.keyboardType = .default
        return textField
    }()
    
    private let signupBtn: UIButton = {
        let button = UIButton(type: .system)
        button.defaultButtonStyle(title: "Sign Up", backgroundColorString: "sub_color")
        button.addTarget(self, action: #selector(signupBtnPressed), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let backToLoginBtn: UIButton = {
        let button = UIButton(type: .system)
        button.attributedText(firstString: "Already have an account? ", secondString: "Log In")
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(backToLoginPage), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        view.backgroundColor = .white
        initUI()
        setNotificationObserverInField()
    }
    
    //MARK: - Helper functions
    func initUI() {
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        view.addSubview(profileImageView)
        profileImageView.setDimensions(height: 100, width: 100)
        profileImageView.centerX(inView: view)
        profileImageView.anchor(top: titleLabel.bottomAnchor, paddingTop: 20)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, nameField, usernameField, signupBtn])
        stackView.spacing = 20
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.centerX(inView: view)
        stackView.anchor(top: profileImageView.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(backToLoginBtn)
        backToLoginBtn.centerX(inView: view)
        backToLoginBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 12)
    }
    

    func setNotificationObserverInField() {
        emailTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        nameField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        usernameField.addTarget(self, action: #selector(textChange), for: .editingChanged)
    }
    
    
    //MARK: - Actions
    
    @objc func textChange(sender: UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == nameField {
            viewModel.name = sender.text
        } else {
            viewModel.username = sender.text
        }
        
        signupBtn.backgroundColor = viewModel.btnBackgound
        signupBtn.isEnabled = viewModel.isValid
    }
    
    @objc func signupBtnPressed() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let name = nameField.text else {return}
        guard let username = usernameField.text?.lowercased() else {return}
        guard let profileImage = self.profileImage else {return}

        let data = AuthData(email: email, password: password, name: name, username: username, profile: profileImage)
        
        AuthenticationService.signupUser(withData: data) { err in
            if let error = err {
                print("Failed error \(error.localizedDescription)")
                return
            }
            
            self.delegate?.authenticationCompleted()
        }
    }
    
    @objc func backToLoginPage() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func profileSelectionBtn() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        profileImage = selectedImage
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.systemGray2.cgColor
        profileImageView.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
     
        self.dismiss(animated: true)
    }
}
