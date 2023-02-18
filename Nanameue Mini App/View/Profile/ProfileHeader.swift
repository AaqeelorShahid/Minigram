//
//  ProfileHeader.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-13.
//

import Foundation
import UIKit
import SDWebImage

protocol ProfileHeaderProtocol: AnyObject {
    func cell(_ selectedBtn: Int)
}

class ProfileHeader: UICollectionReusableView {
    // MARK: - Properties
    
    weak var delegate: ProfileHeaderProtocol?
    
    var viewModel: UserModel? {
        didSet{initHeaderUI()}
    }
    
    let profilePicture: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var editProfileBtn: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "main_color")
        button.setTitle("Change Profile", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 15
        button.setHeight(40)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(editProfileBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeSectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.setTitle("Likes", for: .normal)
        button.tintColor = UIColor.black
        button.setTitleColor(.black, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(likeSectionBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var postSectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.on.square.intersection.dashed"), for: .normal)
        button.setTitle("Posts", for: .normal)
        button.tintColor = UIColor(named: "main_color")
        button.setTitleColor(.black, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(postSectionBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let separatorView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let separatorViewBottom: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profilePicture)
        profilePicture.centerX(inView: self)
        profilePicture.setDimensions(height: 100, width: 100)
        profilePicture.layer.cornerRadius = 50
        profilePicture.clipsToBounds = true
        
        addSubview(nameLabel)
        nameLabel.centerX(inView: profilePicture)
        nameLabel.anchor(top: profilePicture.bottomAnchor, paddingTop: 8)
        
        addSubview(usernameLabel)
        usernameLabel.centerX(inView: nameLabel)
        usernameLabel.anchor(top: nameLabel.bottomAnchor, paddingTop: 8)
        
        addSubview(editProfileBtn)
        editProfileBtn.centerX(inView: usernameLabel)
        editProfileBtn.setDimensions(height: 40, width: 180)
        editProfileBtn.anchor(top: usernameLabel.bottomAnchor, paddingTop: 12)
        
        addSubview(separatorView)
        separatorView.anchor(top: editProfileBtn.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, height: 1)
        
        let profilSectionStack = UIStackView(arrangedSubviews: [postSectionButton, likeSectionButton])
        addSubview(profilSectionStack)
        profilSectionStack.distribution = .fillEqually
        profilSectionStack.anchor(top: separatorView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12)
        
        addSubview(separatorViewBottom)
        separatorViewBottom.anchor(top: profilSectionStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, height: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper function
    
    func attributedText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    func initHeaderUI() {
        guard let viewModel = viewModel else {return}
        
        nameLabel.text = viewModel.name
        usernameLabel.text = viewModel.username
        profilePicture.sd_setImage(with: URL(string: viewModel.profileUrl), for: .normal)
    }
    
    func handleSelectedBtnColor(selected: Int){
        if (selected == 0){
            postSectionButton.tintColor = UIColor(named: "main_color")
            likeSectionButton.tintColor = UIColor(named: "sub_color")
        } else {
            postSectionButton.tintColor = UIColor(named: "sub_color")
            likeSectionButton.tintColor = UIColor(named: "main_color")
        }
    }
    
//    MARK: - Actions
    @objc func editProfileBtnPressed() {
        delegate?.cell(PROFILE_SELECTION_BUTTON)
    }
    
    @objc func postSectionBtnPressed() {
        handleSelectedBtnColor(selected: OWN_POST_BUTTON)
        delegate?.cell(OWN_POST_BUTTON)
    }
    
    @objc func likeSectionBtnPressed() {
        handleSelectedBtnColor(selected: LIKED_POST_BUTTON)
        delegate?.cell(LIKED_POST_BUTTON)
    }
}
