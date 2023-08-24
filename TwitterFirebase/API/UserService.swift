//
//  UserService.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 24.08.2023.
//

import UIKit
import FirebaseAuth

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    static let shared = UserService()
    
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot, error  in
            guard let dictionary = snapshot.value else { return }
            let user = User(uid: uid, dictionary: dictionary as! [String : Any])
            completion(user)
        }
    }
}
