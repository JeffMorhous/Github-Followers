//
//  UserInfoVCViewController.swift
//  GHFollowers
//
//  Created by Jeff Morhous on 8/16/20.
//  Copyright © 2020 Jeff Morhous. All rights reserved.
//

import UIKit

protocol UserInfoVCDelegate: class {
    func didTapGithubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let item1 = UIView()
    let item2 = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews = [UIView]()
    
    weak var delegate: FollowerListVCDelegate!
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureUIElements(with user: User){
        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate = self
        
        let followerItemVC = GFFollowerItemVC(user: user)
        followerItemVC.delegate = self
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        
        self.add(childVC: repoItemVC, to: self.item1)
        self.add(childVC: followerItemVC, to: self.item2)
        
        self.dateLabel.text = "Github Since: " + user.createdAt.convertToDisplayFormat()
    }
    
    func layoutUI() {
        itemViews = [headerView, item1, item2, dateLabel]
        
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            item1.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            item1.heightAnchor.constraint(equalToConstant: itemHeight),
            
            item2.topAnchor.constraint(equalTo: item1.bottomAnchor, constant: padding),
            item2.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: item2.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    

    @objc func dismissVC() {
        dismiss(animated: true)
    }
}


extension UserInfoVC: UserInfoVCDelegate {
    func didTapGithubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The URL attached to this user is invalid.", buttonTitle: "OK")
            return
        }
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No Followers", message: "This user has no followers", buttonTitle: "Much Sad")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
    
    
}
