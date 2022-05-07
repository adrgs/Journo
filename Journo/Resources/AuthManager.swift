//
//  AuthManager.swift
//  Journo
//
//  Created by Dragos Albastroiu on 07.05.2022.
//

import Foundation
import FirebaseAuth

public class AuthManager {
    static let shared = AuthManager()
    
    public func registerNewUser(username: String, email: String, password: String) {
        
    }
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        } else if let username = username {
            print(username)
        }
    }
}
