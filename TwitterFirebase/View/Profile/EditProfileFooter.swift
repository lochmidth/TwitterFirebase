//
//  EditProfileFooter.swift
//  TwitterFirebase
//
//  Created by Alphan Ogün on 12.09.2023.
//

import UIKit

protocol EditProfileFooterDelegate: AnyObject {
    func handleLogout()
}

class EditProfileFooter: UIView {
    
    //MARK: - Porperties
    
    weak var delegate: EditProfileFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16)
        logoutButton.setHeight(50)
        logoutButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    
    //MARK: - Actions
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
    
    //MARK: - Helpers
}
