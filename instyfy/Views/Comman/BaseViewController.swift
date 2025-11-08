//
//  BaseViewController.swift
//  instyfy
//
//  Created by Vedant Rewadkar on 24/10/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Previous VC Helper
    func getPreviousController() -> UIViewController? {
        guard let vcs = navigationController?.viewControllers, vcs.count >= 2 else { return nil }
        return vcs[vcs.count - 2]
    }
    
    // MARK: - Navigation Helpers
    func navigateToHome() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewControllerID") as? FeedViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToLoginView() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewControllerID") as? LoginViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func navigateToOtpScreen(with user: User) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "OTPVerificationViewControllerID") as? OTPVerificationViewController {
            vc.user = user
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateTOResetPasswordScreen(with user: User) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewControllerID") as? ResetPasswordViewController {
            navigationController?.pushViewController(vc, animated: false)
            vc.user = user
        }
    }
    
    func navigateToSelectedTab(selectedIndex: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewControllerID") as? TabBarViewController {
//            tabBarController.selectedIndex = selectedIndex

            // Get the current window
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                
                // Replace rootViewController with UITabBarController
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
                
                // Optional animation for smooth transition
                UIView.transition(with: window,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: nil,
                                  completion: nil)
            }
        }
    }
    
    
    // MARK: - Helpers
    func showAlert(title: String = "Alert", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

}
