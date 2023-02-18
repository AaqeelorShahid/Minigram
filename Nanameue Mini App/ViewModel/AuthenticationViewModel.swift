//
//  AuthenticationViewModel.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-12.
//

import Foundation
import UIKit

protocol AuthenticationViewModel {
    var isValid: Bool {get}
    var btnBackgound: UIColor {get}
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var isValid: Bool {
        return password?.isEmpty == false &&
        isValidPassword(password: password!) == true &&
        email?.isEmpty == false &&
        email?.contains("@") != false &&
        email?.doesContainsWhiteSpace() == false
    }
    
    var btnBackgound: UIColor {
        return isValid ? UIColor(named: "main_color")! : UIColor(named: "sub_color")!
    }
    
}


struct RegistationViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    var name: String?
    var username: String?
    
    var isValid: Bool {
        return password?.isEmpty == false &&
        isValidPassword(password: password!) == true &&
        email?.isEmpty == false &&
        email?.contains("@") != false &&
        email?.doesContainsWhiteSpace() == false &&
        name?.isEmpty == false &&
        username?.isEmpty == false &&
        username?.doesContainsWhiteSpace() == false
    }
    
    var btnBackgound: UIColor {
        return isValid ? UIColor(named: "main_color")! : UIColor(named: "sub_color")!
    }
    
}

private func isValidPassword(password: String) -> Bool {
    let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return passwordPredicate.evaluate(with: password)
}
