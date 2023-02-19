//
//  MainFeedController.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-11.
//

import Foundation
import UIKit
import FirebaseAuth

private let imageOnlyCellIdentifier = "image_post_cell"
private let textOnlyCellIdentifier = "text_post_cell"
private let postCellIdentifier = "post_cell"

class MainFeedController: UICollectionViewController {
    
    //MARK: - Properties
    private var posts = [PostModel]() {
        didSet { collectionView.reloadData() }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        initUI()
        fetchPosts()
    }
    
    //MARK: - Helper functions
    
    func initUI() {
        collectionView.backgroundColor = .white
        
        navigationItem.title = "Minigram"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: postCellIdentifier)
        collectionView.register(TextOnlyPostCell.self, forCellWithReuseIdentifier: textOnlyCellIdentifier)
        collectionView.register(ImageOnlyPostCell.self, forCellWithReuseIdentifier: imageOnlyCellIdentifier)
        
        let UIRefresher = UIRefreshControl()
        UIRefresher.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        collectionView.refreshControl = UIRefresher
    }
    
    func fetchPosts() {
        showLoading(true, showText: false)
        PostService.fetchPosts { posts, error in
            self.posts = posts
            self.checkUsedLikedOrNot()
            self.showLoading(false, showText: false)
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkUsedLikedOrNot() {
        self.posts.forEach { item in
            PostService.checkUserLikedOrNot(post: item) { likeStatus, error in
                if let currentIndex = self.posts.firstIndex(where: {$0.postId == item.postId}){
                    self.posts[currentIndex].didLike = likeStatus
                }
            }
        }
    }
    
    //MARK: - Actions
    @objc func logout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
            
        } catch {
            print ("Error - logout")
        }
    }
    
    @objc func refreshFeed() {
        fetchPosts()
    }
    
    func handleLikeAction (post: PostModel) {
        if post.didLike {
            PostService.unlikePost(post: post) { error in
                if let error = error {
                    print("Error in unlike post api \(error)")
                }
                
                
            }
            //Set unlike animation to the button here

        } else {
            PostService.likePost(post: post) { error in
                if let error = error {
                    print("Error in like post api \(error)")
                }
            }
            
            //Set liked animation to the button here
        }
    }
}

// MARK: - UICollectionView Data Source

extension MainFeedController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentPost = posts[indexPath.row]
        if (currentPost.postText.isEmpty) {
            // Image only post
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageOnlyCellIdentifier, for: indexPath) as! ImageOnlyPostCell
            cell.postViewModel = PostViewModel(post: posts[indexPath.row])
            cell.enableMenu = false
            cell.delegate = self
            return cell
        } else if (currentPost.postImageUrl.isEmpty) {
            // Text only post
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textOnlyCellIdentifier, for: indexPath) as! TextOnlyPostCell
            cell.postViewModel = PostViewModel(post: posts[indexPath.row])
            cell.enableMenu = false
            cell.delegate = self
            return cell
        } else {
            // Regular post
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellIdentifier, for: indexPath) as! FeedCollectionViewCell
            cell.postViewModel = PostViewModel(post: posts[indexPath.row])
            cell.enableMenu = false
            cell.delegate = self
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
}

// MARK: - UICollectionViewFlowDelegate

extension MainFeedController: UICollectionViewDelegateFlowLayout {
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
        
        // Minimum space between post/cell
        return 10
    }
    
}

// MARK: - FeedCollectionViewDelegate

extension MainFeedController: CommonFeedCellDelegate {
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
    }
}
