//
//  Tweet.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 25.08.2023.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    var likes: Int
    var timestamp: Date!
    var retweetCount: Int
    var user: User
    var didLike = false
    
    init(user: User, tweetID: String, dictionary: [String: Any]) {
        self.tweetID = tweetID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweetCount"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
    
}
