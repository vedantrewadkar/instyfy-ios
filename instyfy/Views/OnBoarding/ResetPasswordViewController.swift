//
//  ResetPasswordViewController.swift
//  instyfy
//
//  Created by Vedant Rewadkar on 24/10/25.
//
import UIKit

class ResetPasswordViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var passField1: UITextField!
    @IBOutlet weak var passField2: UITextField!
    
    // MARK: - Properties
    var resetPasswordViewModel = ResetPasswordViewModel()
    var user: User?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Add border and corner radius (optional)
        passField1.layer.cornerRadius = 8
        passField2.layer.cornerRadius = 8
    }
    
    private func setupBindings() {
        resetPasswordViewModel.onLoading = { isLoading in
            // You can show a loader here if you want
            if isLoading {
                print("🔄 Updating password...")
            }
        }
        
        resetPasswordViewModel.onSuccess = { [weak self] message in
            DispatchQueue.main.async {
                self?.navigateToLoginView()
                self?.showAlert(title: "Success", message: message)
            }
        }
        
        resetPasswordViewModel.onFailure = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(title: "Error", message: error)
            }
        }
    }
    
    @IBAction func didTapResetButton(_ sender: Any) {
        guard let newPass1 = passField1.text, !newPass1.isEmpty,
              let newPass2 = passField2.text, !newPass2.isEmpty else {
            showAlert(message: "Please fill in both password fields.")
            return
        }
        
        guard newPass1 == newPass2 else {
            showAlert(message: "Passwords do not match.")
            return
        }
        
        guard let user = user else {
            self.showAlert(message: "User data not available.")
            return
        }
        
        // Call ViewModel to update password
        resetPasswordViewModel.resetPassword(for: user.mobile, newPassword: newPass1)
    }
}
