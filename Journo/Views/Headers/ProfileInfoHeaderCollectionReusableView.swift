//
//  ProfileInfoHeaderCollectionReusableView.swift
//  Journo
//
//  Created by Dragos Albastroiu on 08.05.2022.
//

import UIKit

class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
