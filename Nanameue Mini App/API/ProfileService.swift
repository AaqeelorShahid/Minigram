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
    static func fetchUserData(completion: @escaping (UserModel, Bool) -> Void) {
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else {return}
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dic = snapshot?.data() else {return}
            let user = UserModel(dic: dic)
            
            if let error = error {
                print (error.localizedDescription)
                completion(user, false)
            }
            
            completion(user, true)
        }
    }
    
    static func updateProfilePicture(image: UIImage, completion: @escaping (String, Error?) -> Void){
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else {return}
        ImageUploader.uploadImageToStorage(image: image, path: "/profile") { imageUrl, error in
            if let error = error {
                print ("Error in storing the image")
                completion("", error)
                return
            }
            COLLECTION_USERS.document(uid).updateData(["profileUrl": imageUrl]) { error in
                if let error = error {
                    print ("Error in update the image url")
                    completion("", error)
                    return
                }
                completion(imageUrl, error)
            }
           
        }
    }
}
