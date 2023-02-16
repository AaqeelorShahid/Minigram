//
//  PostViewModel.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-16.
//

import Foundation
import FirebaseFirestore

struct PostViewModel {
    private let post: PostModel
    
    var imageUrl: String {
        return post.postImageUrl
    }
    
    var profilePicture: String {
        return post.profilePicture
    }
    
    var name: String {
        return post.name
    }
    
    var postText: String {
        return post.postText
    }
    
    var timeStamp: Timestamp {
        return post.timeStamp
    }
    
    var likeCount: Int {
        return post.likes
    }
    
    var likeLabelString: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }
    
    init(post: PostModel){
        self.post = post
    }
}
