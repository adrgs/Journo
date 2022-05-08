//
//  ProfileTabsCollectionReusableView.swift
//  Journo
//
//  Created by Dragos Albastroiu on 08.05.2022.
//

import UIKit

protocol ProfileTabsCollectionReusableViewDelegate: AnyObject {
    func didClickGridButtonTab()
    func didClickTaggedButtonTab()
}

class ProfileTabsCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileTabsCollectionReusableView"
    
    public weak var delegate: ProfileTabsCollectionReusableViewDelegate?
    
    private let gridButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .systemBlue
        button.setBackgroundImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        return button
    }()
    
    private let taggedButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .lightGray
        button.setBackgroundImage(UIImage(systemName: "tag"), for: .normal)
        return button
    }()
    
    struct Constants {
        static let padding: CGFloat = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(gridButton)
        addSubview(taggedButton)
        
        gridButton.addTarget(self, action: #selector(didClickGridButton), for: .touchUpInside)
        taggedButton.addTarget(self, action: #selector(didClickTaggedButton), for: .touchUpInside)
    }
    
    @objc private func didClickGridButton() {
        gridButton.tintColor = .systemBlue
        taggedButton.tintColor = .lightGray
        delegate?.didClickGridButtonTab()
    }
    @objc private func didClickTaggedButton() {
        gridButton.tintColor = .lightGray
        taggedButton.tintColor = .systemBlue
        delegate?.didClickTaggedButtonTab()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = height - (Constants.padding * 2)
        let gridButtonX = ((width/2)-size)/2
        
        gridButton.frame = CGRect(x: gridButtonX, y: Constants.padding, width: size, height: size)
        taggedButton.frame = CGRect(x: gridButtonX + (width/2), y: Constants.padding, width: size, height: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
