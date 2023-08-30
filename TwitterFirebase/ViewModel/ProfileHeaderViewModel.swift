//
//  ProfileHeaderViewModel.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 29.08.2023.
//

import UIKit
import FirebaseAuth

enum ProfileFilterOptions: Int, CaseIterable {
case tweets
case replies
case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    var user: User
    
    var profileImageUrl: URL? { return user.profileImageUrl }
    
    var fullnameString: String { return user.fullname }
    
    var usernameString: String { return "@\(user.username)" }
    
    var bioString: String { return "Lorem Ipsum is simply dummy text of the printing and typesetting industry." }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var actionButtonBackgroundColor: UIColor {
        if user.isCurrentUser {
            return user.isCurrentUser ? .white : .twitterBlue
        } else {
            return user.isFollowed ? .white : .twitterBlue
        }
    }
    
    var actionButtonTextColor: UIColor {
        if user.isCurrentUser {
            return user.isCurrentUser ? .twitterBlue : .white
        } else {
            return user.isFollowed ? .twitterBlue : .white
        }
    }
    
    var followersStatText: NSAttributedString? {
        return attributedStatText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingStatText: NSAttributedString? {
        return attributedStatText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    init(user: User) {
        self.user = user
    }
    
    fileprivate func attributedStatText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
