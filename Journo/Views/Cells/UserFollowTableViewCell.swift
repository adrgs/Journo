//
//  UserFollowTableViewCell.swift
//  Journo
//
//  Created by Dragos Albastroiu on 08.05.2022.
//

import UIKit
import SDWebImage

protocol UserFollowTableViewCellDelegate : AnyObject {
    func didClickFollowUnfollowButton(model: UserRelationship)
}

enum FollowState {
    case following, not_following
}

public struct UserRelationship {
    let id: Int64?
    let email: String?
    let pictureUrl: String?
    let username: String
    let name: String
    let type: FollowState
}

class UserFollowTableViewCell: UITableViewCell {

    static let identifier = "UserFollowTableViewCell"
    private var model: UserRelationship?
    
    weak var delegate: UserFollowTableViewCellDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    public func configure(model: UserRelationship) {
        self.model = model
        nameLabel.text = model.name
        usernameLabel.text = "@" + model.username
        profileImageView.sd_setImage(with: URL(string:model.pictureUrl ?? "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png"), completed: nil)
        if model.type == .not_following {
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.label, for: .normal)
            followButton.backgroundColor = .link
            followButton.layer.borderWidth = 0
        } else {
            followButton.setTitle("Unfollow", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = .systemBackground
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(followButton)
        
        followButton.addTarget(self, action: #selector(didClickFollowButton), for: .touchUpInside)
    }
    
    @objc private func didClickFollowButton() {
        guard let model = model else {
            return
        }
        delegate?.didClickFollowUnfollowButton(model: model)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height-6, height: contentView.height-6)
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        let buttonWidth = contentView.width > 500 ? 220.0 : contentView.width/3
        followButton.frame = CGRect(x: contentView.width-5-buttonWidth, y: 10, width: buttonWidth, height: 40)
        
        let labelHeight = contentView.height/2
        nameLabel.frame = CGRect(x: profileImageView.right+5, y: 0, width: contentView.width-8-profileImageView.width - buttonWidth, height: labelHeight)
        usernameLabel.frame = CGRect(x: profileImageView.right+5, y: nameLabel.bottom, width: contentView.width-8-profileImageView.width - buttonWidth, height: labelHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
