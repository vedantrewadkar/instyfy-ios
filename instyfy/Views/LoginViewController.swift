import UIKit

class LoginViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createNewAccountView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    // MARK: - Properties
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setTapGesture()
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToRegisterViewController))
        createNewAccountView.addGestureRecognizer(tapGesture)

        forgotPasswordLabel.isUserInteractionEnabled = true
        let tapGestureForgotButton = UITapGestureRecognizer(target: self, action: #selector(self.navigateOtpScreen))
        forgotPasswordLabel.addGestureRecognizer(tapGestureForgotButton)
    }

    // MARK: - UI Setup
    private func setupUI() {
        createNewAccountView.layer.cornerRadius = 24
        createNewAccountView.layer.borderWidth = 1
        createNewAccountView.layer.borderColor = UIColor.systemBlue.cgColor
        createNewAccountView.clipsToBounds = true
        loginBtn.layer.cornerRadius = 8
        loginBtn.clipsToBounds = true
    }
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] in
//            DispatchQueue.main.async {
//              self?.showAlert(title: "Success", message: "Login Successful ✅")
                self?.navigateToHome()
//            }
        }
        
        viewModel.onLoginFailure = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(title: "Error", message: error)
            }
        }
    }

    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.emailOrPhoneOrUsername = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        viewModel.login()
    }
    
    @objc func navigateToRegisterViewController() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterViewControllerID") as? RegisterViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - Helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    /// ✅ This version is safe for gestures (no parameters)
    @objc func navigateOtpScreen() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "OTPVerificationViewControllerID") as? OTPVerificationViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
