//
//  TweetViewModel.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 26.08.2023.
//

import UIKit

struct TweetViewModel {
    
    var tweet: Tweet
    
    var profileImageUrl: URL? { return tweet.user.profileImageUrl }
    
    var captionText: String { return tweet.caption }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: tweet.user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(tweet.user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))

        title.append(NSAttributedString(string: " · \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return title
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
    
    
}
