//
//  PostViewModel.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-16.
//

import Foundation
import FirebaseFirestore

struct PostViewModel {
    var post: PostModel
    
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
    
    var likeImage: UIImage? {
        return post.didLike ? UIImage(named: "like_selected") : UIImage(named: "like_selected")
    }
    
    var likeBtnTint: UIColor? {
        return post.didLike ? UIColor.red : UIColor.gray
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
