//
//  ImageUploader.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 24.08.2023.
//

import FirebaseStorage

struct ImageUploader {
    static let shared = ImageUploader()
    
    func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData) { meta, error in
            if let error = error {
                print("DEBUG: Failed to upload image, \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else { return }
                completion(profileImageUrl)
                
            }
        }
    }
}
