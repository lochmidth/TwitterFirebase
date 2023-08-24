//
//  Constants.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 24.08.2023.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

