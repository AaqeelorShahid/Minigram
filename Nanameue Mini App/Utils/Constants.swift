//
//  Constants.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-14.
//

import Foundation
import FirebaseFirestore

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_POST = Firestore.firestore().collection("posts")

let FROM_REGULAR_POST_CELL = 0
let FROM_TEXT_ONLY_POST_CELL = 1
let FROM_IMAGE_ONLY_POST_CELL = 2

let OWN_POST_BUTTON = 0
let LIKED_POST_BUTTON = 1


