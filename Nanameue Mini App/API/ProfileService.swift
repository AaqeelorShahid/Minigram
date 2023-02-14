//
//  ProfileService.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-14.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ProfileService {
    static func fetchUserData(completion: @escaping (UserModel) -> Void) {
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else {return}
        COLLECTION_USERS.document(uid).getDocument { snapshot, err in
            
            guard let dic = snapshot?.data() else {return}
            let user = UserModel(dic: dic)
            if(err != nil) {
                print("User data fetching error")
            }
            print(user)
        }
    }
}
