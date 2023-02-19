//
//  ProfileController.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-11.
//

import Foundation
import UIKit
import FirebaseAuth
import YPImagePicker

private let imageOnlyCellIdentifier = "image_post_cell"
private let textOnlyCellIdentifier = "text_post_cell"
private let postCellIdentifier = "post_cell"
private let headerIdentifier = "header_cell"

class ProfileController: UICollectionViewController {
    
    //MARK: - Properties

    var model: UserModel {
        didSet{ collectionView.reloadData() }
    }
    
    var posts = [PostModel]() {
        didSet{ collectionView.reloadData() }
    }
    
    var enableMenuSatus: Bool = true
    
    var likedPosts = [PostModel]()
    var index: Int = 0
    
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
        
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: postCellIdentifier)
        collectionView.register(TextOnlyPostCell.self, forCellWithReuseIdentifier: textOnlyCellIdentifier)
        collectionView.register(ImageOnlyPostCell.self, forCellWithReuseIdentifier: imageOnlyCellIdentifier)
        collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
    }
    
    func fetchPosts() {
        let uid = Auth.auth().currentUser?.uid
        guard let userId = uid else {return}
        showLoading(true, showText: false)
        PostService.fetchPosts(forUser: userId) { posts in
            self.posts = posts
            self.checkUsedLikedOrNot()
            self.showLoading(false, showText: false)
        }
    }
    
    func checkUsedLikedOrNot() {
        self.posts.forEach { item in
            PostService.checkUserLikedOrNot(post: item) { likeStatus in
                if let currentIndex = self.posts.firstIndex(where: {$0.postId == item.postId}){
                    self.posts[currentIndex].didLike = likeStatus
                }
            }
        }
    }
    
    func fetchAllPosts() {
        showLoading(true, showText: true, description: "This might take several seconds")
        PostService.fetchPosts() { posts in
            self.posts = posts
            self.fetchAllLikedPosts()
        }
    }
    
    func fetchAllLikedPosts() {
        if index < self.posts.count {
            PostService.checkUserLikedOrNot(post: self.posts[index]) { likeStatus in
                if likeStatus {
                    self.posts[self.index].didLike = true
                    self.likedPosts.append(self.posts[self.index])
                }
                self.index += 1
                self.fetchAllLikedPosts()
            }
        } else {
            self.posts = likedPosts
            showLoading(false, showText: false)
        }
    }
    
    func handleLikeAction (post: PostModel) {
        if post.didLike {
            PostService.unlikePost(post: post) { error in
                if let error = error {
                    print("Error in unlike post api \(error)")
                    self.showErrorMessage(showErorText: true, error: error.localizedDescription)
                }
            }

        } else {
            PostService.likePost(post: post) { error in
                if let error = error {
                    print("Error in like post api \(error)")
                    self.showErrorMessage(showErorText: true, error: error.localizedDescription)
                }
            }
        }
    }
    
    
    func finishedPickingThePhoto(_ picker: YPImagePicker){
        picker.didFinishPicking { items, cancelled in
            picker.dismiss(animated: true) {
                guard let image = items.singlePhoto?.image else {return}
                self.showLoading(true, showText: false)
                ProfileService.updateProfilePicture(image: image) { imageUrl, error in
                    self.model.profileUrl = imageUrl
                    self.showLoading(false, showText: false)
                }
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentPost = posts[indexPath.row]
        if (currentPost.postText.isEmpty) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageOnlyCellIdentifier, for: indexPath) as! ImageOnlyPostCell
            cell.postViewModel = PostViewModel(post: posts[indexPath.row])
            cell.enableMenu = enableMenuSatus
            cell.delegate = self
            return cell
        } else if (currentPost.postImageUrl.isEmpty) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textOnlyCellIdentifier, for: indexPath) as! TextOnlyPostCell
            cell.postViewModel = PostViewModel(post: posts[indexPath.row])
            cell.enableMenu = enableMenuSatus
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellIdentifier, for: indexPath) as! FeedCollectionViewCell
            cell.postViewModel = PostViewModel(post: posts[indexPath.row])
            cell.enableMenu = enableMenuSatus
            cell.delegate = self
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerIdentifier,
            for: indexPath) as! ProfileHeader
        header.delegate = self
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
        return CGSize(width: view.frame.width, height: 290)
    }
}

// MARK: - FeedCollectionViewDelegate

extension ProfileController: CommonFeedCellDelegate {
    func cell(_ cell: UICollectionViewCell, likedThisPost post: PostModel, from: Int) {
        if (from == FROM_REGULAR_POST_CELL) {
            
            let currentCell = cell as! FeedCollectionViewCell
            currentCell.postViewModel?.post.didLike.toggle()
            
            guard let like = currentCell.postViewModel?.likeCount else {return}
            currentCell.postViewModel?.post.likes = post.didLike ? like - 1 : like + 1
            
            handleLikeAction(post: post)
            
            
        } else if (from == FROM_TEXT_ONLY_POST_CELL){
            
            let currentCell = cell as! TextOnlyPostCell
            currentCell.postViewModel?.post.didLike.toggle()
            
            guard let like = currentCell.postViewModel?.likeCount else {return}
            currentCell.postViewModel?.post.likes = post.didLike ? like - 1 : like + 1

            handleLikeAction(post: post)
            
        } else if (from == FROM_IMAGE_ONLY_POST_CELL){
            
            let currentCell = cell as! ImageOnlyPostCell
            currentCell.postViewModel?.post.didLike.toggle()
            
            guard let like = currentCell.postViewModel?.likeCount else {return}
            currentCell.postViewModel?.post.likes = post.didLike ? like - 1 : like + 1

            handleLikeAction(post: post)
        }
    }
    
    func cell(_ cell: UICollectionViewCell, menuOpened post: PostModel, from: Int) {
        let alert = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true)
        }
        let deleteAction = UIAlertAction(title: "Delete Post", style: .destructive) { (action) in
            self.showLoading(true, showText: false)
            PostService.removePost(withId: post.postId) { error in
                if let error = error {
                    print ("Error in removing post: \(error)")
                    self.showErrorMessage(showErorText: true, error: error.localizedDescription)
                }
            }
            
            self.showLoading(false, showText: false)
            self.fetchPosts()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileController: ProfileHeaderProtocol {
    func cell(_ selectedBtn: Int) {
        if selectedBtn == OWN_POST_BUTTON {
            fetchPosts()
            enableMenuSatus = true
        } else if selectedBtn == LIKED_POST_BUTTON {
            fetchAllPosts()
            enableMenuSatus = false
        } else {
            Utils.openPhotoGallery(controller: self) { picker in
                self.finishedPickingThePhoto(picker)
            }
        }
    }
}
