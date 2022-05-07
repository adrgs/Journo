//
//  StorageManager.swift
//  Journo
//
//  Created by Dragos Albastroiu on 07.05.2022.
//

import Foundation
import FirebaseStorage

public class StorageManager {
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    public func uploadUserPost(model: UserPost, completion: (Result<URL, Error>) -> Void) {
        
    }
    
    public enum StorageManagerError: Error {
        case failedToDownload
    }
    
    public func downloadImage(reference: String, completion: @escaping (Result<URL, StorageManagerError>) -> Void) {
        bucket.child(reference).downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(.failedToDownload))
                return
            }
            completion(.success(url))
        }
    }
}

public enum UserPostType {
    case photo, video
}

public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postUR: URL
    let caption: String?
    let likeCount: [PostLikes]
    let comments: [PostComment]
    let createdDate: Date
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
