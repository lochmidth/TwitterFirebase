//
//  NotificationsController.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 23.08.2023.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {
    
    //MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet { tableView.reloadData() }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: - API
    
    func fetchNotifications() {
        refreshControl?.beginRefreshing()
        
        NotificationService.shared.fetchNotifications { notifications in
            self.refreshControl?.endRefreshing()
            
            self.notifications = notifications.sorted(by: {$0.timestamp > $1.timestamp })
            self.checkIfUserIsFollowed(notifications: self.notifications)
        }
    }
    
    func checkIfUserIsFollowed(notifications: [Notification]) {
        for (index, notification) in notifications.enumerated() {
            if case .follow = notification.type {
                let user = notification.user
                
                UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                    self.notifications[index].user.isFollowed = isFollowed
                }
            }
        }
    }
    
    //MARK: - Actions
    
    @objc func handleRefresh() {
        fetchNotifications()
        refreshControl?.endRefreshing()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
}

//MARK: - UITableViewDataSource

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        
        cell.isUserInteractionEnabled = true
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotificationsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else { return }
        
        TweetService.shared.fetchTweet(withTweetID: tweetID) { tweet in
            tableView.deselectRow(at: indexPath, animated: true)
            
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - NotificationCellDelegate

extension NotificationsController: NotificationCellDelegate {
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.viewModel?.notification.user else { return }
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapFollow(_ cell: NotificationCell) {
        guard let user = cell.viewModel?.notification.user else { return }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                if let error = error {
                    self.showMessage(withTitle: "Oops!", message: "Error while unfollowing the user \(user.username), \(error.localizedDescription)")
                }
                cell.viewModel?.notification.user.isFollowed = false
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error, ref in
                if let error = error {
                    self.showMessage(withTitle: "Oops!", message: "Error while following the user \(user.username), \(error.localizedDescription)")
                }
                cell.viewModel?.notification.user.isFollowed = true
            }
        }
        
    }
}
