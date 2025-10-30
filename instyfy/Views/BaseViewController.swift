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
        if let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewControllerID") as? HomeViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToLoginView() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewControllerID") as? LoginViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    /// ✅ Use this version when you want to pass a `User` manually (from Register screen)
    func navigateToOtpScreen(with user: User) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "OTPVerificationViewControllerID") as? OTPVerificationViewController {
            vc.user = user
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
