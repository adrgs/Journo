//
//  StorageManager.swift
//  Journo
//
//  Created by Dragos Albastroiu on 07.05.2022.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

public class StorageManager {
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    public func uploadMedia(image: UIImage, completion: @escaping (_ url: String?) -> Void) {

       let storageRef = Storage.storage().reference().child("\(Auth.auth().currentUser?.uid ?? "")\(randomString(length: 10)).png")
       if let uploadData = image.jpegData(compressionQuality: 0.5) {
           storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
               if error != nil {
                   print("error")
                   completion(nil)
               } else {

                   storageRef.downloadURL(completion: { (url, error) in

                       completion(url?.absoluteString)
                   })

                 //  completion((metadata?.downloadURL()?.absoluteString)!))
                   // your uploaded photo url.


               }
           }
       }
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
