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
    
    static func uploadPostWithImage(postText: String, user: UserModel, postImage: UIImage, completion: @escaping (FirestoreCompletion)) {
        ImageUploader.uploadImageToStorage(image: postImage, path: "/posts") { imageUrl in
            
            let data = ["timeStamp" : Timestamp(date: Date()),
                        "postText" : postText,
                        "likes": 0,
                        "profilePicture": user.profileUrl,
                        "name": user.name,
                        "postImageUrl": imageUrl,
                        "postedBy": user.uid] as [String: Any]
            
            COLLECTION_POST.addDocument(data: data, completion: completion)
        }
    }
    
    static func uploadPost(postText: String, user: UserModel, completion: @escaping (FirestoreCompletion)) {
        
        let data = ["timeStamp" : Timestamp(date: Date()),
                    "postText" : postText,
                    "likes": 0,
                    "profilePicture": user.profileUrl,
                    "name": user.name,
                    "postImageUrl": "",
                    "postedBy": user.uid] as [String: Any]
        
        COLLECTION_POST.addDocument(data: data, completion: completion)
    }
    
    static func fetchPosts(completion: @escaping ([PostModel]) -> Void) {
        COLLECTION_POST.order(by: "timeStamp", descending: true).getDocuments { snapshot, err in
            guard let docs = snapshot?.documents else {return}
            
            let posts = docs.map({ PostModel(postId: $0.documentID, dic: $0.data())})
            completion(posts)
        }
    }
    
    static func fetchPosts(forUser userId: String , completion: @escaping ([PostModel]) -> Void) {
        COLLECTION_POST
            .whereField("postedBy", isEqualTo: userId)
            .getDocuments {
                snapshot, err in
                
            guard let docs = snapshot?.documents else {return}
            
            let posts = docs.map({ PostModel(postId: $0.documentID, dic: $0.data())})
            completion(posts)
        }
    }
    
}
