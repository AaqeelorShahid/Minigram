//
//  AuthenticationService.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-13.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

struct AuthData {
    let email: String
    let password: String
    let name: String
    let username: String
    let profile: UIImage
}

struct AuthenticationService {
    static func loginUser(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    
    static func signupUser(withData data: AuthData, completion: @escaping(Error?) -> Void ) {
        ImageUploader.uploadImageToStorage(image: data.profile) { url in
            Auth.auth().createUser(withEmail: data.email, password: data.password){
                (result, error) in
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else {return}
                let data: [String: Any] = ["name": data.name,
                                           "username": data.username,
                                           "email": data.email,
                                           "profileUrl": url,
                                           "uid": uid]
                
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
            }
        }
    }
}
