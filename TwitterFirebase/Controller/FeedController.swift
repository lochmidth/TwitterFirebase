//
//  FeedController.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 23.08.2023.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {
    
    //MARK: - Properties
    
    var user: User? {
        didSet {
//            print("DEBUG: Did set User in feed controller. \n \(user?.profileImageUrl)")
        }
    }
    
    //MARK: - Lifecycle
    
    init(user: User? = nil) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        configureLeftBarButton()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(height: 32, width: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
