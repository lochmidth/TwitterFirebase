//
//  User.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 24.08.2023.
//

import UIKit
import FirebaseAuth

struct User {
    let email: String
    var fullname: String
    var profileImageUrl: URL?
    var username: String
    let uid: String
    var bio: String?
    
    var isFollowed = false
    
    var stats: UserStats?
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}

struct UserStats {
    let followers: Int
    let following: Int
    let tweets: Int
}
