//
//  ProfileController.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 28.08.2023.
//

import UIKit
import FirebaseAuth

private let cellIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    //MARK: Properties
    
    private var user: User
    
    private var selectedFilter: ProfileFilterOptions = .tweets {
        didSet { collectionView.reloadData() }
    }
    
    private var tweets = [Tweet]()
    private var likedTweets = [Tweet]()
    private var replies = [Tweet]()
    
    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets: return tweets
        case .replies: return replies
        case .likes: return likedTweets
        }
    }
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTweets()
        fetchLikedTweets()
        fetchReplies()
        configureUI()
        checkIfUserIsFollowed()
        fetchUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - API
    
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets.sorted(by: {$0.timestamp > $1.timestamp })
            self.checkIfUserLikedTweets()
            self.collectionView.reloadData()
        }
    }
    
    func fetchLikedTweets() {
        TweetService.shared.fetchLikes(forUser: user) { tweets in
            self.likedTweets = tweets.sorted(by: {$0.timestamp > $1.timestamp })
            self.checkIfUserLikedTweets()
        }
    }
    
    func fetchReplies() {
        TweetService.shared.fetchReplies(forUser: user) { tweets in
            self.replies = tweets.sorted(by: {$0.timestamp > $1.timestamp })
            self.checkIfUserLikedTweets()
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    func checkIfUserLikedTweets() {
        self.tweets.forEach { tweet in
            TweetService.shared.checkIfUserLikedTweet(tweet: tweet) { didLike in
                guard didLike == true else { return }
                
                if let index = self.tweets.firstIndex(where: {$0.tweetID == tweet.tweetID}) {
                    self.tweets[index].didLike = true
                }
            }
        }
    }
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    func configureUI() {
        
        collectionView.backgroundColor = .white
        
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(TweetCell.self,
                                forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
    }
}

//MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TweetCell
        
        cell.viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.delegate = self
        
        header.viewModel = ProfileHeaderViewModel(user: user)
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: currentDataSource[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: -  UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var height: CGFloat = 300
        
        if user.bio != nil {
            height += 50
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
        var height = viewModel.size(forWidth: view.frame.width).height + 72
        
        if currentDataSource[indexPath.row].isReply {
            height += 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
}

//MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        if user.isCurrentUser {
            let controller = EditProfileController(user: user)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
        
        else if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                self.user.isFollowed = false
                self.collectionView.reloadData()
                self.view.layoutIfNeeded()
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error, ref in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                self.view.layoutIfNeeded()
                
                NotificationService.shared.uploadNotification(toUser: self.user, type: .follow)
            }
        }
    }
    
    func handleDismissal(_ header: ProfileHeader) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - EditProfileControllerDelegate

extension ProfileController: EditProfileControllerDelegate {
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true)
            let controller = MainTabController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        } catch let error {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        
        self.user = user
        self.collectionView.reloadData()
    }
}
