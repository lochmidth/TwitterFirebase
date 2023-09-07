//
//  NotificationViewModel.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 7.09.2023.
//

import UIKit

struct NotificationViewModel {
    var notification: Notification
    let type: NotificationType
    var user: User
    
    private var timestampString: String {
        var calender = Calendar.current
        calender.locale = Locale(identifier: "en")
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        formatter.calendar = calender
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "2m"
    }
    
    private var notificationMessage: String {
        switch type {
        case .follow: return " started following you."
        case .like: return " liked your tweet."
        case .reply: return " replied to your tweet."
        case .retweet: return " retweeted your tweet."
        case .mention: return " mentioned you in a tweet."
        }
    }
    
    var notificationText: NSAttributedString? {
        let attributedText = NSMutableAttributedString(string: user.username,
                                                       attributes: [.font: UIFont.boldSystemFont(ofSize: 13)])
        attributedText.append(NSAttributedString(string: notificationMessage,
                                                 attributes: [.font: UIFont.systemFont(ofSize: 13)]))
        attributedText.append(NSAttributedString(string: " \(timestampString)",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    
    var profileImageUrl: URL? { return user.profileImageUrl }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonText: String {
        return notification.user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return notification.user.isFollowed ? .white : .twitterBlue
    }
    
    var followButtonTextColor: UIColor {
        return notification.user.isFollowed ? .twitterBlue : .white
    }
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
