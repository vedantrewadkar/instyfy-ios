//
//  RegisterViewController.swift
//  instyfy
//
//  Created by Vedant Rewadkar on 16/10/25.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    
    let registerVM = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTapGestures()
    }
    
    private func setupBindings() {
        registerVM.onRegisterSuccess = { [weak self] in
            print("Registration successful!")
            // Navigate to Home screen
            self?.navigateToHome()
        }
        
        registerVM.onRegisterFailure = { [weak self] errorMsg in
            self?.showAlert(message: errorMsg)
        }
        
        registerVM.onLoadingStatusChanged = { isLoading in
            // Show/hide loader
            print(isLoading ? "Loading..." : "Done")
        }
    }
    
    func setupTapGestures() {
        loginLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateTOLogin))
        loginLabel.addGestureRecognizer(tapGesture)
    }

    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        
        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match")
            return
        }
        
        registerVM.fullName = fullNameTextField.text ?? ""
        registerVM.userName = userNameTextField.text ?? ""
        registerVM.email = emailTextField.text ?? ""
        registerVM.mobileNumber = mobileNumberTextField.text ?? ""
        registerVM.password = password
        registerVM.registerUser()
    }

    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Registration", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToHome() {
        // Navigate to Home screen or main app
    }
    
    @objc private func navigateTOLogin() {
        navigationController?.popViewController(animated: true)
    }
}
