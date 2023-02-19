//
//  PostModel.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-16.
//

import FirebaseFirestore

struct PostModel {
    let postId: String
    let timeStamp: Timestamp
    let profilePicture: String
    let name: String
    let postedBy: String
    let postImageUrl: String
    var postText: String
    var didLike = false
    var likes: Int
    
    init(postId:String, dic: [String: Any]) {
        self.postId = postId 
        self.postText = dic["postText"] as? String ?? ""
        self.postImageUrl = dic["postImageUrl"] as? String ?? ""
        self.profilePicture = dic["profilePicture"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.timeStamp = dic["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.postedBy = dic["postedBy"] as? String ?? ""
        self.likes = dic["likes"] as? Int ?? 0
    }
}
