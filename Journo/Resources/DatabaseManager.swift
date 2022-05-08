//
//  DatabaseManager.swift
//  Journo
//
//  Created by Dragos Albastroiu on 07.05.2022.
//

import Foundation
import SQLite

public class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var db: Connection?
    
    public func initDatabase() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!

            db = try Connection("\(path)/db.sqlite")
            
            let posts = Table("posts")
            let idPost = Expression<Int64>("idPost")
            let idUser = Expression<Int64>("idUser")
            let imgUrl = Expression<String>("imgUrl")
            
            try db!.run(posts.create { t in
                t.column(idPost, primaryKey: true)
                t.column(idUser)
                t.column(imgUrl)
            })
            
            let relationships = Table("relationships")
            let idFollower = Expression<Int64>("idFollower")
            let idFollowing = Expression<Int64>("idFollowing")
            
            try db!.run(relationships.create { t in
                t.column(idFollower)
                t.column(idFollowing)
            })

            let users = Table("users")
            let id = Expression<Int64>("id")
            let username = Expression<String?>("username")
            let email = Expression<String>("email")
            let website = Expression<String?>("website")
            let bio = Expression<String?>("bio")
            let phone = Expression<String?>("phone")
            let gender = Expression<String?>("gender")
            let pictureUrl = Expression<String?>("pictureUrl")
            
            try db!.run(users.create { t in
                t.column(id, primaryKey: true)
                t.column(username)
                t.column(email, unique: true)
                t.column(website)
                t.column(bio)
                t.column(phone)
                t.column(gender)
                t.column(pictureUrl)
            })
        } catch {
            print (error)
        }
    }
    
    public func getId(email: String) -> Int64 {
        let users = Table("users")
        let emailCol = Expression<String>("email")
        let id = Expression<Int64>("id")
        
        do {
            for user in try db!.prepare(users.filter(emailCol == email)) {
                return user[id]
            }
        } catch {
            print("Get Id Error")
            print(error)
        }
        
        return -1
    }
    
    public func getEmail(uid: Int64) -> String {
        let users = Table("users")
        let emailCol = Expression<String>("email")
        let id = Expression<Int64>("id")
        
        do {
            for user in try db!.prepare(users.filter(id == uid)) {
                return user[emailCol]
            }
        } catch {
            print("Get Id Error")
            print(error)
        }
        
        return "invalid email"
    }
    
    public func getProfilePicture(uid: Int64) -> String? {
        let users = Table("users")
        let id = Expression<Int64>("id")
        let pictureUrl = Expression<String?>("pictureUrl")
        
        do {
            for user in try db!.prepare(users.filter(id == uid)) {
                return user[pictureUrl]
            }
        } catch {
            print("Get Id Error")
            print(error)
        }
        
        return nil
    }
    
    
    public func getUsers(uid: Int64) -> [UserRelationship] {
        var userRelationships: [UserRelationship] = []
        
        let users = Table("users")
        let username = Expression<String?>("username")
        let email = Expression<String>("email")
        let id = Expression<Int64>("id")
        let pictureUrl = Expression<String?>("pictureUrl")

        do {
            for user in try db!.prepare(users.filter(id != uid)) {
                userRelationships.append(UserRelationship(id: user[id], email: user[email], pictureUrl: user[pictureUrl], username: user[username] ?? user[email], name: user[email], type: .not_following))
            }
        } catch {
            print(error)
        }
        
        return userRelationships
    }
    
    public func getFollowers(uid: Int64) -> [UserRelationship] {
        let relationships = Table("relationships")
        let users = Table("users")
        let username = Expression<String?>("username")
        let email = Expression<String>("email")
        let id = Expression<Int64>("id")
        let idFollowerC = Expression<Int64>("idFollowing")
        let pictureUrl = Expression<String?>("pictureUrl")
        
        let query = users.join(relationships, on: idFollowerC == users[id])
        
        var userRelationships: [UserRelationship] = []
        
        do {
            for user in try db!.prepare(query.filter(id == uid)) {
                userRelationships.append(UserRelationship(id: user[id], email: user[email], pictureUrl: user[pictureUrl], username: user[username] ?? user[email], name: user[username] ?? user[email], type: .not_following))
            }
        } catch {
            print("Get Id Error")
            print(error)
        }
        
        return userRelationships
    }
    
    public func getFollowing(id: Int64) -> [UserRelationship] {
        let relationships = Table("relationships")
        let users = Table("users")
        let username = Expression<String?>("username")
        let email = Expression<String>("email")
        let id = Expression<Int64>("id")
        let idFollowerC = Expression<Int64>("idFollowing")
        let pictureUrl = Expression<String?>("pictureUrl")
        
        let query = users.join(relationships, on: idFollowerC == users[id])
        
        var userRelationships: [UserRelationship] = []
        
        do {
            for user in try db!.prepare(query) {
                userRelationships.append(UserRelationship(id: user[id], email: user[email], pictureUrl: user[pictureUrl], username: user[username] ?? user[email], name: user[username] ?? user[email], type: .following))
            }
        } catch {
            print("Get Id Error")
            print(error)
        }
        
        return userRelationships
    }
    
    public func follow(idFollower: Int64, idFollowing: Int64) {
        let relationships = Table("relationships")
        let idFollowerC = Expression<Int64>("idFollower")
        let idFollowingC = Expression<Int64>("idFollowing")
        
        do {
            let insert = relationships.insert(idFollowerC <- idFollower, idFollowingC <- idFollowing)
            try db!.run(insert)
        } catch {
            print("Follow User Error")
            print(error)
        }
        
    }
    
    public func unfollow(idFollower: Int64, idFollowing: Int64) {
        let relationships = Table("relationships")
        let idFollowerC = Expression<Int64>("idFollower")
        let idFollowingC = Expression<Int64>("idFollowing")
        
        do {
            let relation = relationships.filter(idFollowerC == idFollower && idFollowingC == idFollowing)
            try db!.run(relation.delete())
        } catch {
            print("Unfollow User Error")
            print(error)
        }
    }
    
    public func getAllPosts() -> [UserPost] {
        var s: [UserPost] = []
        
        do {
            let posts = Table("posts")
            let idUser = Expression<Int64>("idUser")
            let imgUrl = Expression<String>("imgUrl")
            
            for post in try db!.prepare(posts) {
                s.append(
                    UserPost(username: getEmail(uid: post[idUser]), pictureUrl: post[imgUrl], imageUrl: post[imgUrl], thumbnailImage: post[imgUrl])
                )
            }
        } catch {
            print("Register User Error")
            print(error)
        }
        
        return s
    }
    
    public func getPosts(uid: Int64) -> [UserPost] {
        var s: [UserPost] = []
        
        do {
            let posts = Table("posts")
            let idUser = Expression<Int64>("idUser")
            let imgUrl = Expression<String>("imgUrl")
            
            for post in try db!.prepare(posts.filter(idUser == uid)) {
                s.append(
                    UserPost(username: getEmail(uid: post[idUser]), pictureUrl: post[imgUrl], imageUrl: post[imgUrl], thumbnailImage: post[imgUrl])
                )
            }
        } catch {
            print("Register User Error")
            print(error)
        }
        
        return s
    }
    
    public func createPost(uid: Int64, url: String) -> Int64 {
        do {
            let posts = Table("posts")
            let idUser = Expression<Int64>("idUser")
            let imgUrl = Expression<String>("imgUrl")
            
            let insert = posts.insert(idUser <- uid, imgUrl <- url)
            let rowid = try db!.run(insert)
            
            return rowid
        } catch {
            print("Register User Error")
            print(error)
        }
        return -1
    }
    
    public func registerUser(username: String?, email: String, website: String?, bio: String?, phone: String?, gender: String?, pictureUrl: String?) -> Int64 {
        do {
            let users = Table("users")
            let usernameC = Expression<String?>("username")
            let emailC = Expression<String>("email")
            let websiteC = Expression<String?>("website")
            let bioC = Expression<String?>("bio")
            let phoneC = Expression<String?>("phone")
            let genderC = Expression<String?>("gender")
            let pictureUrlC = Expression<String?>("pictureUrl")
            
            let insert = users.insert(usernameC <- username, emailC <- email, websiteC <- website, bioC <- bio, phoneC <- phone, genderC <- gender, pictureUrlC <- pictureUrl)
            let rowid = try db!.run(insert)
            
            return rowid
        } catch {
            print("Register User Error")
            print(error)
        }
        return -1
    }
    
    
}
