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
        return password?.isEmpty == false && email?.isEmpty == false
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
        return
        password?.isEmpty == false &&
        (password!.count <= 6) == false &&
        email?.isEmpty == false &&
        email?.contains("@") != false &&
        name?.isEmpty == false &&
        username?.isEmpty == false
    }
    
    var btnBackgound: UIColor {
        return isValid ? UIColor(named: "main_color")! : UIColor(named: "sub_color")!
    }
    
}
