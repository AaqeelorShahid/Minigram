//
//  UserModel.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-14.
//

import Foundation

struct UserModel {
    let email: String
    let name: String
    let profileUrl: String
    let uid: String
    let username: String
    
    init(dic: [String: Any]) {
        self.email = dic["email"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.profileUrl = dic["profileUrl"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.username = dic["username"] as? String ?? ""
    }
}
