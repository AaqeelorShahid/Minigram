//
//  FeedCollectionViewCell.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-12.
//

import Foundation
import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    var postViewModel: PostViewModel? {
        didSet {initCell()}
    }
    
    var enableMenu: Bool? {
        didSet {
            guard let status = enableMenu else {return}
            if status {
                menuButton.isHidden = false
            } else {
                menuButton.isHidden = true
            }
        }
    }
    
    //MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "profile")
        return imageView
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Shahid", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(usernamePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "menu_icon"), for: .normal)
        button.tintColor = .black
//        button.isHidden = true
        button.addTarget(self, action: #selector(menuBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let postText: UILabel = {
        let label = UILabel()
        label.text = "Life is too short to waste time on things that don't make you happy. Focus on what brings joy and let go of the rest"
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = -1
        return label
    }()
    
    private let postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "profile")
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.tintColor = .systemGray2
        button.addTarget(self, action: #selector(likeBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let likeCountText: UILabel = {
        let label = UILabel()
        label.text = "122"
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = -1
        return label
    }()
    
    private let postedTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "6h ago"
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = -1
        return label
    }()
    
    private let separatorView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 12, paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
        addSubview(menuButton)
        menuButton.anchor(top: topAnchor, right: rightAnchor,
                                paddingTop: 16, paddingRight: 12)
        menuButton.setDimensions(height: 20, width: 20)
        
        addSubview(postText)
        postText.anchor(top: profileImageView.bottomAnchor ,left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        addSubview(postImage)
        postImage.anchor(top: postText.bottomAnchor ,left: leftAnchor, right: rightAnchor, paddingTop: 12)
        postImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        addSubview(likeButton)
        likeButton.anchor(top: postImage.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        likeButton.setDimensions(height: 25, width: 25)
        
        addSubview(likeCountText)
        likeCountText.centerY(inView: likeButton, leftAnchor: likeButton.rightAnchor, paddingLeft: 8)
        
        addSubview(postedTimeLabel)
        postedTimeLabel.anchor(top: postImage.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        
        addSubview(separatorView)
        separatorView.anchor(top: likeButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingBottom: 12, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper functions
    
    func initCell() {
        guard let viewModel = postViewModel else {return}
        
        if (viewModel.postText.isEmpty) {
            // Image only post
            postText.isHidden = true
            postImage.sd_setImage(with: URL(string: viewModel.imageUrl))
            
            postImage.anchor(top: profileImageView.bottomAnchor ,left: leftAnchor, right: rightAnchor, paddingTop: 12)
            postImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
            
        } else if (viewModel.imageUrl.isEmpty) {
            // Text only post
            postText.text = viewModel.postText
            postImage.image = nil
            postImage.isHidden = true
            
            likeButton.anchor(top: postText.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
            postedTimeLabel.anchor(top: postText.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
            
        } else {
            postText.text = viewModel.postText
            postImage.sd_setImage(with: URL(string: viewModel.imageUrl))
        }
        
        //Setting posted time
        let date = viewModel.timeStamp.dateValue()
        let postedTimeAgo = date.getTimeAgo()
        postedTimeLabel.text = postedTimeAgo
        
        //user details of the post
        profileImageView.sd_setImage(with: URL(string: viewModel.profilePicture))
        usernameButton.setTitle(viewModel.name, for: .normal)
        
        //like
        likeCountText.text = viewModel.likeLabelString
    }
    
    
    //MARK: - Actions
    
    @objc func usernamePressed() {
        print ("user name [ressed")
    }
    
    @objc func likeBtnPressed() {
        print ("like pressed")
    }
    
    @objc func menuBtnPressed() {
//        let alert = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//            // Handle cancel action
//        }
//
//        let deleteAction = UIAlertAction(title: "Delete Post", style: .destructive) { (action) in
//            // Handle delete action
//        }
//
//        alert.addAction(cancelAction)
//        alert.addAction(deleteAction)
//
//        present(alert, animated: true, completion: nil)
    }
}
