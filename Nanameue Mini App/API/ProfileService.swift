//
//  ProfileService.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-14.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

typealias FirestoreCompletion = (Error?) -> Void

class ProfileService {
    static func fetchUserData(completion: @escaping (UserModel) -> Void) {
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else {return}
        COLLECTION_USERS.document(uid).getDocument { snapshot, err in
            
            guard let dic = snapshot?.data() else {return}
            let user = UserModel(dic: dic)
            if(err != nil) {
                print("User data fetching error")
            }
            completion(user)
        }
    }
    
    static func updateProfilePicture(image: UIImage, compeltion: @escaping (String) -> Void){
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else {return}
        ImageUploader.uploadImageToStorage(image: image, path: "/profile") { imageUrl in
            COLLECTION_USERS.document(uid).updateData(["profileUrl": imageUrl])
            compeltion(imageUrl)
        }
        
    }
}
