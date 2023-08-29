//
//  TweetService.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 25.08.2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "caption": caption,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0] as [String : Any]
        
        let ref = REF_TWEETS.childByAutoId()
        
        ref.updateChildValues(values) { error, ref in
            guard let tweetID = ref.key else { return }
            
            REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
        }
    }
    
//    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
//        var tweets = [Tweet]()
//        
//        
//    }
    
    func fetchTweets(forUser user: User? = nil, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        if let user = user {
            REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
                let tweetID = snapshot.key
                
                REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                    guard let dictionary = snapshot.value as? [String: Any] else { return }
                    guard let uid = dictionary["uid"] as? String else { return }
                    let tweetID = snapshot.key
                    
                    UserService.shared.fetchUser(withUid: uid) { user in
                        let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                        tweets.append(tweet)
                        completion(tweets)
                    }
                }
            }
        } else {
            REF_TWEETS.observe(.childAdded) { snapshot, _  in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                let tweetID = snapshot.key
                
                UserService.shared.fetchUser(withUid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
}
