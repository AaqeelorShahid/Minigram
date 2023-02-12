//
//  FeedCollectionViewCell.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-12.
//

import Foundation
import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
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
    
    private let postedTimeStamp: UILabel = {
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
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 12, paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
        addSubview(postText)
        postText.anchor(top: profileImageView.bottomAnchor ,left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 8, paddingRight: 8)
        
        addSubview(postImage)
        postImage.anchor(top: postText.bottomAnchor ,left: leftAnchor, right: rightAnchor, paddingTop: 12)
        postImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        addSubview(likeButton)
        likeButton.anchor(top: postImage.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 8)
        likeButton.setDimensions(height: 25, width: 25)
        
        addSubview(likeCountText)
        likeCountText.centerY(inView: likeButton, leftAnchor: likeButton.rightAnchor, paddingLeft: 8)
        
        addSubview(postedTimeStamp)
        postedTimeStamp.anchor(top: postImage.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 8)
        
        addSubview(separatorView)
        separatorView.anchor(top: likeButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, height: 1.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
    
    @objc func usernamePressed() {
        print ("user name [ressed")
    }
    
    @objc func likeBtnPressed() {
        print ("like pressed")
    }
    
    //MARK: - Helpers
    
    func initActionButtons() {
         
    }
}