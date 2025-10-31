//
//  RegisterViewController.swift
//  instyfy
//
//  Created by Vedant Rewadkar on 16/10/25.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    private let registerVM = RegisterViewModel()
    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTapGestures()
        registerButton.layer.cornerRadius = 8
    }
    
    private func setupBindings() {
        registerVM.onRegisterFailure = { [weak self] error in
            self?.showAlert(message: error)
        }

        registerVM.onUserExistenceChecked = { [weak self] exists, message in
            guard let self = self else { return }
            if exists {
                self.showAlert(message: message ?? "User already exists.")
            } else  {
                if let user = self.user {
                    self.navigateToOtpScreen(with: user)
                }
            }
        }
    }
    
    private func setupTapGestures() {
        loginLabel.isUserInteractionEnabled = true
        loginLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToLogin)))
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard
            let fullName = fullNameTextField.text, !fullName.isEmpty,
            let username = userNameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let mobile = mobileNumberTextField.text, !mobile.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty
        else {
            showAlert(message: "Please fill all fields.")
            return
        }

        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match.")
            return
        }
        
        user = User(email: email, password: password, username: username, fullName: fullName, mobile: mobile)
        
        if let user = user {
            guard registerVM.validateFields(user: user) else { return }
            registerVM.checkUserExistence(user: user)
        }

    }
    
    @objc private func navigateToLogin() {
        navigationController?.popViewController(animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Registration", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
