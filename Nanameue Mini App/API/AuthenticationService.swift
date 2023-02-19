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
    
    static func signupUser(withData data: AuthData, completion: @escaping(Error?, Bool) -> Void ) {
        ImageUploader.uploadImageToStorage(image: data.profile, path: "/profile") { url, error  in
            Auth.auth().createUser(withEmail: data.email, password: data.password){
                (result, error) in
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(error, false)
                    return
                }
                
                guard let uid = result?.user.uid else {return}
                let data: [String: Any] = ["name": data.name,
                                           "username": data.username,
                                           "email": data.email,
                                           "profileUrl": url,
                                           "uid": uid]
                
                Firestore.firestore().collection("users").document(uid).setData(data){ error in
                    if let error = error {
                        completion(error, false)
                        return
                    }
                    completion(error, true)
                }
            }
        }
    }
    
}
