//
//  UserCellViewModel.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 30.08.2023.
//

import UIKit

struct UserCellViewModel {
    var user: User
    
    var profileImageUrl: URL? { return user.profileImageUrl }
    
    var usernameString: String { return user.username }
    
    var fullnameString: String { return user.fullname }
    
    init(user: User) {
        self.user = user
    }
    
}
