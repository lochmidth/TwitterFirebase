//
//  MainTabController.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 23.08.2023.
//

import UIKit
import FirebaseAuth

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
            configureUI()
        }
    }
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        logUserOut()
//        view.backgroundColor = .white
        fetchUser()
        authenticateUserAndConfigureUI()
        
    }
    
    //MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false)
            }
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Actions
    
    @objc func handleActionButtonTapped() {
        guard let user = user else { return }
        let controller = UINavigationController(rootViewController: UploadTweetController(user: user))
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers(withUser user: User) {
        
        let feed = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: FeedController(user: user))
        
        let explore = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: ExploreController())
        
        let notifications = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: NotificationsController())
        
        let conversations = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: ConversationsController())
        
        viewControllers = [feed, explore, notifications, conversations]
        
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.tintColor = .white
        return nav
    }
}

//MARK: - AuthenticationDelegate

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        //        showLoader(false)
        fetchUser()
        self.dismiss(animated: true)
    }
}
