//
//  ProfileInfoHeaderCollectionReusableView.swift
//  Journo
//
//  Created by Dragos Albastroiu on 08.05.2022.
//

import UIKit
import FirebaseAuth

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderDidClickPostsButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidClickFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidClickFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidClickEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView)
}

class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let postsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Posts\n1", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Following\n2", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Followers\n3", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        return button
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = Auth.auth().currentUser!.email!
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "First Account"
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private func addSubViews() {
        addSubview(profilePhotoImageView)
        addSubview(postsButton)
        addSubview(followersButton)
        addSubview(followingButton)
        addSubview(editProfileButton)
        addSubview(nameLabel)
        addSubview(bioLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        clipsToBounds = true
        addSubViews()
        addButtonActions()
    }
    
    private func addButtonActions() {
        followersButton.addTarget(self, action: #selector(didClickFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didClickFollowingButton), for: .touchUpInside)
        postsButton.addTarget(self, action: #selector(didClickPostsButton), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(didClickEditProfileButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let profilePhotoSize = width / 4.0
        let buttonHeight = profilePhotoSize / 2.0
        let countButtonWidth = (width - 10 - profilePhotoSize) / 3
        
        profilePhotoImageView.frame = CGRect(x: 5, y: 5, width: profilePhotoSize, height: profilePhotoSize).integral
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize / 2
        
        postsButton.frame = CGRect(x: profilePhotoImageView.right, y: 5, width: countButtonWidth, height: buttonHeight).integral
        followersButton.frame = CGRect(x: postsButton.right, y: 5, width: countButtonWidth, height: buttonHeight).integral
        followingButton.frame = CGRect(x: followersButton.right, y: 5, width: countButtonWidth, height: buttonHeight).integral
        
        editProfileButton.frame = CGRect(x: profilePhotoImageView.right, y: 5 + buttonHeight, width: countButtonWidth*3, height: buttonHeight).integral
        
        nameLabel.frame = CGRect(x: 5, y: 5 + profilePhotoImageView.bottom, width: width - 10, height: 50).integral
        
        let bioLabelSize = bioLabel.sizeThatFits(frame.size)
        
        bioLabel.frame = CGRect(x: 5, y: 5 + nameLabel.bottom, width: width - 10, height: bioLabelSize.height).integral
    }
    
    @objc private func didClickFollowersButton() {
        delegate?.profileHeaderDidClickFollowersButton(self)
    }
    @objc private func didClickFollowingButton() {
        delegate?.profileHeaderDidClickFollowingButton(self)
    }
    @objc private func didClickPostsButton() {
        delegate?.profileHeaderDidClickPostsButton(self)
    }
    @objc private func didClickEditProfileButton() {
        delegate?.profileHeaderDidClickEditProfileButton(self)
    }
}
