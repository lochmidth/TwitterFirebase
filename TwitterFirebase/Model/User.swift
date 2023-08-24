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
    let fullname: String
    var profileImageUrl: URL?
    let username: String
    let uid: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}