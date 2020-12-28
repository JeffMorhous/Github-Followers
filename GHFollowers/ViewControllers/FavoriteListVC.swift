//
//  FavoriteListVC.swift
//  GHFollowers
//
//  Created by Jeff Morhous on 4/7/20.
//  Copyright © 2020 Jeff Morhous. All rights reserved.
//

import UIKit

class FavoriteListVC: UIViewController {

    
    
    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        getFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let favorites):
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "You don't have any favorites!\n", in: self.view)
                } else {
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something Went Wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

}


extension FavoriteListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let fav = favorites[indexPath.row]
        cell.set(favorite: fav)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fav = favorites[indexPath.row]
        let destVC = FollowerListVC()
        destVC.username = fav.login
        destVC.title = fav.login
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let fav = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        PersistenceManager.updateWith(favorite: fav, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            
            self.presentGFAlertOnMainThread(title: "Unable To Remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
