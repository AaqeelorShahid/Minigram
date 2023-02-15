//
//  PostViewModel.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-16.
//

import Foundation

struct PostViewModel {
    private let post: PostModel
    
    var imageUrl: String {
        return post.postImageUrl
    }
    
    var postText: String {
        return post.postText
    }
    
    init(post: PostModel){
        self.post = post
    }
}
