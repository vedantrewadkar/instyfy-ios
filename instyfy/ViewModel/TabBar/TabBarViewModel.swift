//
//  TabBarViewModel.swift
//  instyfy
//
//  Created by Vedant Rewadkar on 05/11/25.
//

import UIKit

class TabBarViewModel {
    
    // All tabs in the app
    let viewControllers: [UIViewController]
    
    // Feed tab should be the initial one
    let initialIndex: Int = 0
    
    init() {
        // Feed Tab
        let feedVC = FeedViewController()
        feedVC.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )
        
        // Placeholder tabs (you can replace them later)
        let exploreVC = ExploreViewController()
        exploreVC.view.backgroundColor = .systemGray6
        exploreVC.tabBarItem = UITabBarItem(
            title: "Explore",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1
        )
        
        // Placeholder tabs (you can replace them later)
        let createPostVC = CreatePostViewController()
        createPostVC.view.backgroundColor = .systemGray6
        createPostVC.tabBarItem = UITabBarItem(
            title: "Create Post",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1
        )
        
        let discoverVC = DiscoverViewController()
        discoverVC.view.backgroundColor = .systemGray5
        discoverVC.tabBarItem = UITabBarItem(
            title: "My Profile",
            image: UIImage(systemName: "person.fill"),
            tag: 2
        )
        
        let profileVC = MyProfileViewController()
        profileVC.view.backgroundColor = .systemGray5
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.fill"),
            tag: 2
        )
        
        self.viewControllers = [feedVC, exploreVC, profileVC]
    }
}
