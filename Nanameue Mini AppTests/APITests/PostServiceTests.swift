//
//  PostServiceTests.swift
//  Nanameue Mini AppTests
//
//  Created by Shahid on 2023-02-19.
//

import XCTest
import FirebaseFirestore
import FirebaseAuth
@testable import Nanameue_Mini_App

final class PostServiceTests: XCTestCase {
    
    // !!! Please Login into the app before doing this test !!!
    ///     Since It requires user uid - please login

    
    func testUploadPostAPI() {
        let exp = self.expectation(description: "Waiting for async operation to finish - exp")
        
        // Test whether api is fetching the user data properly
        let userModelDictionary = [
            "email" : "shahid@gmail.com",
            "name" : "Shahid",
            "profileUrl": "https://firebasestorage.googleapis.com:443/v0/b/mim-98eff.appspot.com/o/profile%2F7F341323-D088-47CC-A475-BD09434838E2?alt=media&token=b3a8ccf1-0d4d-4eb9-8e9d-901239d88f3f",
            "uid": "sVPGxhwlP7XjeJvDEMflE58B9w23",
            "username": "shahid.aaqeel"]
    
        let userModel = UserModel(dic: userModelDictionary)
        
        PostService.uploadPost(postText: "This is unit test post", user: userModel) { error in
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testUploadPostWithImageAPI() {
        let exp = self.expectation(description: "Waiting for async operation to finish - exp")
        
        // Test whether api is fetching the user data properly
        let userModelDictionary = [
            "email" : "shahid@gmail.com",
            "name" : "Shahid",
            "profileUrl": "https://firebasestorage.googleapis.com:443/v0/b/mim-98eff.appspot.com/o/profile%2F7F341323-D088-47CC-A475-BD09434838E2?alt=media&token=b3a8ccf1-0d4d-4eb9-8e9d-901239d88f3f",
            "uid": "sVPGxhwlP7XjeJvDEMflE58B9w23",
            "username": "shahid.aaqeel"]
    
        let userModel = UserModel(dic: userModelDictionary)
        guard let postImage = UIImage(named: "test_post") else {return}
        
        PostService.uploadPostWithImage(postText: "This is unit text for post with Image", user: userModel, postImage: postImage) { error in
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testFetchPostsAPI() {
        let exp = self.expectation(description: "Waiting for async operation to finish - exp")
                
        PostService.fetchPosts { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testFetchPostsForSpecificUserIdAPI() {
        let exp = self.expectation(description: "Waiting for async operation to finish - exp")
                
        //Below give id is different user id who already posted has few posts
        let userId = "y5nCKu0y2zSdTpFxxBAXtRxjlfK2"
        PostService.fetchPosts(forUser: userId) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testRemovePostAPI() {
        // Since this api call need Post-ID I'm have implemented the fetch post api to get one.
        
        let exp = self.expectation(description: "Waiting for async operation to finish - exp")
        
        PostService.fetchPosts { data, error in
            if data.count > 0 {
                PostService.removePost(withId: data[0].postId) { error in
                    XCTAssertNil(error)
                    exp.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testLikePostAPI() {
        // Since this api call need Post-ID I'm have implemented the fetch post api to get one.
        
        let exp = self.expectation(description: "Waiting for async operation to finish - exp")
        
        PostService.fetchPosts { data, error in
            if data.count > 0 {
                PostService.likePost(post: data[0]) { error in
                    XCTAssertNil(error)
                    exp.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testUnlikePostAPI() {
        // Since this api call need Post-ID I'm have implemented the fetch post api to get one.
        
        let exp = self.expectation(description: "Waiting for async operation to finish - exp")
        
        PostService.fetchPosts{ data, error in
            if data.count > 0 {
                PostService.unlikePost(post: data[0]) { error in
                    XCTAssertNil(error)
                    exp.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testCheckUserLikedOrNotAPI() {
        // Since this api call need Post-ID I'm have implemented the fetch post api to get one.
        
        let exp = self.expectation(description: "Waiting for async operation to finish - exp")
        
        PostService.fetchPosts { data, error in
            if data.count > 0 {
                PostService.checkUserLikedOrNot(post: data[0]) { likeStatus, error in
                    XCTAssertNil(error)
                    exp.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    
    
    
    
}
