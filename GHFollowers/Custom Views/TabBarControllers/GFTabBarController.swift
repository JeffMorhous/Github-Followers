//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Jeff Morhous on 12/27/20.
//  Copyright © 2020 Jeff Morhous. All rights reserved.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().tintColor = .systemGreen
        self.viewControllers = [createSearchNC(), createFavoritesNC()]

    }

    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0 )
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC = FavoriteListVC()
        favoritesListVC.title = "Favorites"
        favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1 )
        
        return UINavigationController(rootViewController: favoritesListVC)
    }
}
