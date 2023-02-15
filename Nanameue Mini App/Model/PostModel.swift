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
    let likes: Int
    let postedBy: String
    var postText: String
    let postImageUrl: String

    
    init(postId:String, dic: [String: Any]) {
        self.postId = postId 
        self.postText = dic["postText"] as? String ?? ""
        self.postImageUrl = dic["postImageUrl"] as? String ?? ""
        self.timeStamp = dic["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.postedBy = dic["postedBy"] as? String ?? ""
        self.likes = dic["likes"] as? Int ?? 0
    }
}
