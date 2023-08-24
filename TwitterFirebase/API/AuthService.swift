//
//  AuthService.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 24.08.2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        ImageUploader.shared.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let values = ["email": credentials.email,
                              "username": credentials.username,
                              "fullname": credentials.fullname,
                              "profileImageUrl": imageUrl]
                
                REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
            }
        }
        
        
    }
}
