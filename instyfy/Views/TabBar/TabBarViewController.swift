//
//  TabBarViewController.swift
//  instyfy
//
//  Created by Vedant Rewadkar on 02/11/25.
//


import UIKit

enum TabItem: Int {
    case feed
    case explore
    case createPost
    case discover
    case profile
}

class TabBarViewController: UIViewController, CutomTabBarDelegate {
    
    @IBOutlet weak var customTabBarView: CustomTabBarView!
    
    private var controllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
    
    }
    
    func setUpControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "FeedViewControllerID") as! FeedViewController
        let exploreVC = storyboard.instantiateViewController(withIdentifier: "ExploreViewControllerID") as! ExploreViewController
        let createPostVC = storyboard.instantiateViewController(withIdentifier: "CreatePostViewControllerID") as! CreatePostViewController
        let discoverVC = storyboard.instantiateViewController(withIdentifier: "DiscoverViewControllerID") as! DiscoverViewController
        let profileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewControllerID") as! MyProfileViewController
        
        controllers = [homeVC, exploreVC, createPostVC, discoverVC, profileVC]
        showController(for: .feed)
        customTabBarView.customTabBarDelegate = self
        customTabBarView.updateSelection(index: TabItem.feed.rawValue)
    }
    
    func selectedTab(index: Int) {
        didSelectTab(at: index - 1)
    }

    func didSelectTab(at index: Int) {
        guard let selectedTab = TabItem(rawValue: index + 1) else { return }
        showController(for: selectedTab)
    }

    
    private func showController(for tab: TabItem) {
        print("🟢 Switching to tab:", tab)

        // 1️⃣ Remove existing children
        for child in children {
            print("Removing child:", type(of: child))
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        // 2️⃣ Pick correct controller
        let newController = controllers[tab.rawValue]
        print("Adding child:", type(of: newController))

        // 3️⃣ Add as child
        addChild(newController)
        view.addSubview(newController.view)


        // 5️⃣ Bring tab bar up
        view.bringSubviewToFront(customTabBarView)

        // 6️⃣ Complete the add
        newController.didMove(toParent: self)

        // 7️⃣ Debug
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("✅ Child frame:", newController.view.frame)
        }
        
        print("Parent view frame:", view.frame)
        print("Custom tab bar frame:", customTabBarView.frame)

    }



    
}
