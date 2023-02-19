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
    
    weak var delegate: AuthenticationDelegate?
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
    
    private let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Email is invalid"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = CustomTextField(placeholderText: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Email is invalid"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .red
        label.isHidden = true
        return label
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
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, emailErrorLabel, passwordTextField, passwordErrorLabel, nameField, usernameField, signupBtn])
        stackView.spacing = 15
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
    
    func getMissingValidation(password: String) -> [String] {
        var errors: [String] = []
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)){
            errors.append("Password should contain least one uppercase")
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)){
            errors.append("Password should contain least one digit")
        }

        if(!NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: password)){
            errors.append("Password should contain least one symbol")
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)){
            errors.append("Password should contain least one lowercase")
        }
        
        if(password.count < 8){
            errors.append("Password should be minimun 8 characters")
        }
        return errors
    }
    
    
    //MARK: - Actions
    
    @objc func textChange(sender: UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
            if (!emailTextField.text!.isEmpty) {
                if (!emailTextField.text!.contains("@")){
                    emailTextField.showError()
                    emailErrorLabel.text = "email should contain @"
                    emailErrorLabel.isHidden = false
                } else if (emailTextField.text!.doesContainsWhiteSpace()){
                    emailTextField.showError()
                    emailErrorLabel.text = "email shouldn't contain white space"
                    emailErrorLabel.isHidden = false
                } else {
                    emailTextField.removeError()
                    emailErrorLabel.isHidden = true
                }
            } else {
                emailTextField.removeError()
                emailErrorLabel.isHidden = true
            }
            
        } else if sender == passwordTextField {
            viewModel.password = sender.text
            
            let error = getMissingValidation(password: passwordTextField.text!)
            
            if (!passwordTextField.text!.isEmpty){
                if (error.count > 0){
                    passwordTextField.showError()
                    passwordErrorLabel.isHidden = false
                    passwordErrorLabel.text = error[0]
                } else {
                    passwordTextField.removeError()
                    passwordErrorLabel.isHidden = true
                }
            } else {
                passwordTextField.removeError()
                passwordErrorLabel.isHidden = true
            }
            
            
        } else if sender == nameField {
            viewModel.name = sender.text
        } else {
            viewModel.username = sender.text
            
            if (usernameField.text!.doesContainsWhiteSpace()){
                usernameField.showError()
            } else {
                usernameField.removeError()
            }
        }
        
        signupBtn.backgroundColor = viewModel.btnBackgound
        signupBtn.isEnabled = viewModel.isValid
    }
    
    @objc func signupBtnPressed() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let name = nameField.text else {return}
        guard let username = usernameField.text?.lowercased() else {return}
        
        var profileImage: UIImage!
        if (self.profileImage != nil){
            profileImage = self.profileImage
        } else {
            profileImage = UIImage(named: "profile_placeholder")
        }
       
        let data = AuthData(email: email, password: password, name: name, username: username, profile: profileImage)
        showLoading(true, showText: false)
        
        AuthenticationService.signupUser(withData: data) { err, status in
            if let error = err {
                print("Failed error \(error.localizedDescription)")
                self.showErrorMessage(showErorText: true, error: error.localizedDescription)
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

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = selectedImage
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor(named: "lite_gray_2")?.cgColor
        profileImageView.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true)
    }
}
