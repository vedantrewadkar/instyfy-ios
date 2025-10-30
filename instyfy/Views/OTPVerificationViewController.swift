//
//  OTPVerificationViewController.swift
//  instyfy
//
//  Created by Vedant Rewadkar on 22/10/25.
//

import UIKit

class OTPVerificationViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var otpField1: UITextField!
    @IBOutlet weak var otpField2: UITextField!
    @IBOutlet weak var otpField3: UITextField!
    @IBOutlet weak var otpField4: UITextField!
    @IBOutlet weak var otpField5: UITextField!
    @IBOutlet weak var otpField6: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var otpScreenLabel: UILabel!
    @IBOutlet weak var subtitleOtpScreen: UILabel!
    
    var user: User?
    private let otpVM = OtpViewModel()
    private let registerVM = RegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupOtpVMBindings()
        setupScreenLabel()
        mobileNumberTextField.text = user?.mobile
        otpView.isHidden = true
    }

    private func setupDelegates() {
        [otpField1, otpField2, otpField3, otpField4, otpField5, otpField6].forEach {
            $0?.delegate = self
            $0?.keyboardType = .numberPad
        }
    }

    private func setupScreenLabel() {
        if let prevVC = getPreviousController(), prevVC is LoginViewController {
            otpScreenLabel.text = "Trouble Logging In?"
            subtitleOtpScreen.text = "Enter your mobile number to get OTP and recover your account."
            continueBtn.setTitle("Send OTP to login", for: .normal)
        }
    }

    private func setupOtpVMBindings() {
        otpVM.onOtpSent = { [weak self] _ in
            DispatchQueue.main.async {
                self?.otpView.isHidden = false
            }
        }

        otpVM.onVerificationFailure = { [weak self] errorMsg in
            DispatchQueue.main.async {
                self?.otpView.isHidden = true
            }
        }

        otpVM.onVerificationSuccess = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let user = self.user else {
                    return
                }
//                navigae teot create password or register form otp screen
//                if self.getPreviousController()?.isKind(of: LoginViewController.t) {
//                    
//                }else{
//                    self.registerVM.registerUser(user: user)
//                }
            }
        }
        
        registerVM.onRegisterSuccess = { [weak self] in
            self?.navigateToLoginView()
        }
    
    }

    @IBAction func continueBtnTapped(_ sender: UIButton) {
        let mobile = user?.mobile ?? mobileNumberTextField.text ?? ""
        otpVM.sendOtp(to: mobile)
    }

    @IBAction func confirmBtnTapped(_ sender: UIButton) {
        let otp = [otpField1, otpField2, otpField3, otpField4, otpField5, otpField6].compactMap { $0?.text }.joined()
        otpVM.verifyOtp(otp)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.count <= 1 else { return false }
        if let text = textField.text {
            let newLength = text.count + string.count - range.length
            if newLength == 1 {
                textField.text = string
                switch textField {
                case otpField1: otpField2.becomeFirstResponder()
                case otpField2: otpField3.becomeFirstResponder()
                case otpField3: otpField4.becomeFirstResponder()
                case otpField4: otpField5.becomeFirstResponder()
                case otpField5: otpField6.becomeFirstResponder()
                case otpField6: otpField6.resignFirstResponder()
                    confirmBtn.isHidden = false
                default: break
                }
                return false
            } else if newLength == 0 {
                textField.text = ""
                switch textField {
                case otpField2: otpField1.becomeFirstResponder()
                case otpField3: otpField2.becomeFirstResponder()
                case otpField4: otpField3.becomeFirstResponder()
                case otpField5: otpField4.becomeFirstResponder()
                case otpField6: otpField5.becomeFirstResponder()
                     confirmBtn.isHidden = true
                default: break
                }
                return false
            }
        }
        return true
    }
}
