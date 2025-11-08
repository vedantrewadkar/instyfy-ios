import UIKit

class LoginViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createNewAccountView: UIView!
    @IBOutlet weak var loginBtn: UIButton!

    // MARK: - Properties
    private var viewModel = LoginViewModel()
    private var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setTapGesture()
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToRegisterViewController))
        createNewAccountView.addGestureRecognizer(tapGesture)
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
                self?.navigateToSelectedTab(selectedIndex: 0)
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
        user = User(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", username: "", fullName: "", mobile: "")
        viewModel.login()
    }
    
    @objc func navigateToRegisterViewController() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterViewControllerID") as? RegisterViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func forgotButtonPressed(_ sender: Any) {
        if let user = user {
            navigateToOtpScreen(with: user)
        }
    }
    
}
