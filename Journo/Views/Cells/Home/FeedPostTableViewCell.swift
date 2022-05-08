//
//  UserFollowTableViewCell.swift
//  Journo
//
//  Created by Dragos Albastroiu on 08.05.2022.
//

import UIKit
import SDWebImage

class FeedPostTableViewCell: UITableViewCell {

    static let identifier = "FeedPostTableViewCell"
    private var model: UserPost?
    
    weak var delegate: UserFollowTableViewCellDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleToFill
        imageView.image = nil
        
        return imageView
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
    
    public func configure(model: UserPost) {
        self.model = model
        nameLabel.text = model.username
        profileImageView.sd_setImage(with: URL(string:model.profileUrl ?? "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png"), completed: nil)
        photoImageView.sd_setImage(with: URL(string:model.thumbnailImage ?? "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png"), completed: nil)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(nameLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(photoImageView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: 3, y: 3, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 20
        
        
        nameLabel.frame = CGRect(x: profileImageView.right+5, y: 15, width: contentView.width-8, height: 15)
        
        photoImageView.frame = CGRect(x: 50, y: profileImageView.bottom+15, width: 200, height: 200)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
