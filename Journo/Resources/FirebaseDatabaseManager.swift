//
//  FirebaseDatabaseManager.swift
//  Journo
//
//  Created by Dragos Albastroiu on 07.05.2022.
//

import Foundation
import FirebaseDatabase

public class FirebaseDatabaseManager {
    static let shared = FirebaseDatabaseManager()
    
    private let database = Database.database().reference()
    
    public func canCreateNewUser(email: String, username: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    public func insertNewUser(email: String, username: String, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).setValue(["username": username], withCompletionBlock: { error, _ in
            if error == nil {
                completion(true)
                return
            } else {
                completion(false)
                return
            }
        })
    }
}
