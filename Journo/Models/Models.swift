//
//  Models.swift
//  Journo
//
//  Created by Dragos Albastroiu on 08.05.2022.
//

import Foundation

public enum Gender {
    case male, female, other
}

public struct User {
    let username: String
    let name: (first: String, last: String)
    let birthDate: Date
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
}

public struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

public enum UserPostType {
    case photo, video
}

public struct PostLikes {
    let username: String
    let postIdentifier: String
}

public struct CommentLike {
    let username: String
    let commentIdentifier: String
}

public struct PostComment {
    let identifier: String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}
