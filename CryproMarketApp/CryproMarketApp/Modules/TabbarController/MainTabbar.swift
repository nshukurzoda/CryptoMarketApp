//
//  MainTabbar.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//

import UIKit

final class MainTabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs(){
        let marketVC = CryptoListViewController()
        let favoriteVC = FavoritesViewController()
        
        let marketNavigation = UINavigationController(rootViewController: marketVC)
        let favoritesNavigation = UINavigationController(rootViewController: favoriteVC)
        
        marketNavigation.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        favoritesNavigation.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        viewControllers = [
            marketNavigation,
            favoritesNavigation
        ]
    }
         func setupAppearance() {
            tabBar.tintColor = .systemBlue
            tabBar.unselectedItemTintColor = .secondaryLabel
            tabBar.backgroundColor = .systemBackground
        }
    }

