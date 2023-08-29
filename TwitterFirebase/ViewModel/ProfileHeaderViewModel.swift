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
        } else {
            return "Follow"
        }
    }
    
    var actionButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? .white : .twitterBlue
    }
    
    var actionButtonTextColor: UIColor {
        return user.isCurrentUser ? .twitterBlue : .white
    }
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: 2, text: "Followers")
    }
    
    var followingsString: NSAttributedString? {
        return attributedText(withValue: 0, text: "Followings")
    }
    
    init(user: User) {
        self.user = user
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
