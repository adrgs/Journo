//
//  PhotoCollectionViewCell.swift
//  Journo
//
//  Created by Dragos Albastroiu on 08.05.2022.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    public func configure(model: UserPost) {
        let thumbnailURL = model.thumbnailImage
        photoImageView.sd_setImage(with: URL(string:thumbnailURL), completed: nil)
    }
    
    public func configure(imageName: String) {
        photoImageView.image = UIImage(named: imageName)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
        accessibilityLabel = "User post image"
        accessibilityHint = "Double-tap to open post"
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder: not implemented")
    }
}
