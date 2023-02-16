//
//  ProfileController.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-11.
//

import Foundation
import UIKit
import FirebaseAuth

private let cellIdentifier = "cell"
private let headerIdentifier = "cell"

class ProfileController: UICollectionViewController {
    
    //MARK: - Properties
    
    var model: UserModel {
        didSet{ collectionView.reloadData() }
    }
    
    var posts = [PostModel]()
    
    //MARK: - Lifecycle
    
    //Dependency Injection because this controller needs user object to initialize the UI
    init(model: UserModel) {
        self.model = model
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        initUI()
        fetchPosts()
    }
    
    //MARK: - Helper functions
    
    func initUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
    }
    
    func fetchPosts() {
        let uid = Auth.auth().currentUser?.uid
        guard let userId = uid else {return}
        showLoading(true)
        PostService.fetchPosts(forUser: userId) { posts in
            self.posts = posts
            self.showLoading(false)
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedCollectionViewCell
        cell.postViewModel = PostViewModel(post: posts[indexPath.row])
        cell.enableMenu = true
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerIdentifier,
            for: indexPath) as! ProfileHeader
        
        header.viewModel = model
        return header
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height: CGFloat!
        
        let currentPost = posts[indexPath.row]
        if (currentPost.postText.isEmpty) {
            // Image only post
            height = width + 105
            
        } else if (currentPost.postImageUrl.isEmpty) {
            // Text only post
            let textHeight = currentPost.postText.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 18))
            height = textHeight + 20 + 80
        } else {
            let textHeight = currentPost.postText.height(withConstrainedWidth: width - 24, font: UIFont.systemFont(ofSize: 16))
            height = textHeight + width + 120
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 325)
    }
}
