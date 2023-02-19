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
        ImageUploader.uploadImageToStorage(image: postImage, path: "/posts") { imageUrl, error in
            
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
    
    static func fetchPosts(forUser userId: String, completion: @escaping ([PostModel]) -> Void) {
        COLLECTION_POST
            .whereField("postedBy", isEqualTo: userId)
            .getDocuments {
                snapshot, error in
                
                guard let docs = snapshot?.documents else {return}
                if let error = error {
                    print ("error in \(error)")
                }
                
                var posts = docs.map({ PostModel(postId: $0.documentID, dic: $0.data())})
            
                posts.sort{ (post1, post2) -> Bool in
                    return post1.timeStamp.seconds > post2.timeStamp.seconds
                }
                
                completion(posts)
            }
    }
    
    static func removePost(withId postId: String, completion: @escaping FirestoreCompletion) {
        COLLECTION_POST.document(postId).delete() { error in
            if let error = error {
                completion(error)
            }
        }
    }
    
    static func likePost(post: PostModel, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_POST.document(post.postId).updateData(["likes": post.likes + 1])
        
        COLLECTION_POST.document((post.postId)).collection("liked-users").document(uid).setData([:]) { _ in
            COLLECTION_USERS.document(uid).collection("liked-posts").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(post: PostModel, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard post.likes > 0 else {return}
        
        COLLECTION_POST.document(post.postId).updateData(["likes": post.likes - 1])
        
        COLLECTION_POST.document((post.postId)).collection("liked-users").document(uid).delete() { _ in
            COLLECTION_USERS.document(uid).collection("liked-posts").document(post.postId).delete(completion: completion)
        }
    }
    
    static func checkUserLikedOrNot(post: PostModel, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_USERS.document(uid).collection("liked-posts").document(post.postId).getDocument() { snapshot, error in
            
            if let error = error {
                print ("error in like check \(error)")
            }
            guard let likeStatus = snapshot?.exists else {return}
            
            completion(likeStatus)
        }
    }
    
}
