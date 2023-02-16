//
//  MainFeedController.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-11.
//

import Foundation
import UIKit
import FirebaseAuth

private let cellIdentifier = "cell"

class MainFeedController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var posts = [PostModel]()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        view.backgroundColor = .white
        initUI()
        fetchPosts()
    }
    
    //MARK: - Helper functions
    
    func initUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        navigationItem.title = "Minigram"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        let UIRefresher = UIRefreshControl()
        UIRefresher.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        collectionView.refreshControl = UIRefresher
    }
    
    func fetchPosts() {
        showLoading(true)
        PostService.fetchPosts { posts in
            self.posts = posts
            self.showLoading(false)
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
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
}

// MARK: - UICollectionView Data Source

extension MainFeedController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedCollectionViewCell
        cell.postViewModel = PostViewModel(post: posts[indexPath.row])
        cell.enableMenu = false
        return cell
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
        return 10
    }

}
