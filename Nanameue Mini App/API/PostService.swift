//
//  PostService.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-16.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct PostService {
    
    static func uploadPostWithImage(postText: String, postImage: UIImage, completion: @escaping (FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        ImageUploader.uploadImageToStorage(image: postImage) { imageUrl in
            
            let data = ["timeStamp" : Timestamp(date: Date()),
                        "postText" : postText,
                        "likes": 0,
                        "postImageUrl": imageUrl,
                        "postedBy": uid] as [String: Any]
            
            COLLECTION_POST.addDocument(data: data, completion: completion)
        }
    }
    
    static func uploadPost(postText: String, completion: @escaping (FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let data = ["timeStamp" : Timestamp(date: Date()),
                    "postText" : postText,
                    "likes": 0,
                    "postImageUrl": "",
                    "postedBy": uid] as [String: Any]
        
        COLLECTION_POST.addDocument(data: data, completion: completion)
        
    }
    
}
