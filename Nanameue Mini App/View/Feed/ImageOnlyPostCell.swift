//
//  ImageOnlyPostCell.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-16.
//

import Foundation
import UIKit

class ImageOnlyPostCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    weak var delegate: CommonFeedCellDelegate?
    
    var postViewModel: PostViewModel? {
        didSet {configureCell()}
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
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "menu_icon"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(menuBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(likeBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let likeCountText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "lite_gray_2")
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = -1
        return label
    }()
    
    private let postedTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "lite_gray_2")
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = -1
        return label
    }()
    
    private let separatorView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(named: "lite_gray")
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
        
        
        addSubview(postImage)
        postImage.anchor(top: profileImageView.bottomAnchor ,left: leftAnchor, right: rightAnchor, paddingTop: 12)
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
    
    func configureCell() {
        guard let viewModel = postViewModel else {return}
        
        //Setting posted time
        let date = viewModel.timeStamp.dateValue()
        let postedTimeAgo = date.getTimeAgo()
        postedTimeLabel.text = postedTimeAgo
        
        //user details of the post
        profileImageView.sd_setImage(with: URL(string: viewModel.profilePicture), placeholderImage: UIImage(named: "profile_placeholder"))
        usernameButton.setTitle(viewModel.name, for: .normal)
        
        postImage.sd_setImage(with: URL(string: viewModel.imageUrl), placeholderImage: UIImage(named: "post_image_placeholder"))
        
        //like
        likeCountText.text = viewModel.likeLabelString
        likeButton.tintColor = viewModel.likeBtnTint
        likeButton.setImage(viewModel.likeImage, for: .normal)
    }
    
    
    //MARK: - Actions

    @objc func likeBtnPressed() {
        guard let postModel = postViewModel else {return}
        delegate?.cell(self, likedThisPost: postModel.post, from: FROM_IMAGE_ONLY_POST_CELL)
    }
    
    @objc func menuBtnPressed() {
        guard let postModel = postViewModel else {return}
        delegate?.cell(self, menuOpened: postModel.post, from: FROM_IMAGE_ONLY_POST_CELL)
    }
}
