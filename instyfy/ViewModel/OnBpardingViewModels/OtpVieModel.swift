//
//  OtpViewModel.swift
//  instyfy
//
//  Created by Vedant Rewadkar on 22/10/25.
//

import Foundation
import FirebaseAuth

class OtpViewModel {

    var onOtpSent: ((String) -> Void)?
    var onVerificationSuccess: (() -> Void)?
    var onVerificationFailure: ((String) -> Void)?
    var onLoadingStatusChanged: ((Bool) -> Void)?
    
    private var verificationID: String?

    // MARK: - Send OTP
    func sendOtp(to phoneNumber: String) {
        onLoadingStatusChanged?(true)
        let numberToVerify = phoneNumber
        PhoneAuthProvider.provider().verifyPhoneNumber(numberToVerify, uiDelegate: nil) { [weak self] verificationID, error in
            guard let self = self else { return }
            self.onLoadingStatusChanged?(false)

            if let error = error {
                self.onVerificationFailure?("Send OTP failed: \(error.localizedDescription)")
                return
            }

            guard let verificationID = verificationID else {
                self.onVerificationFailure?("Failed to get verification ID")
                return
            }

            self.verificationID = verificationID
            self.onOtpSent?(verificationID)
        }
    }

    // MARK: - Verify OTP
    func verifyOtp(_ otp: String) {
        guard let verificationID = verificationID else {
            onVerificationFailure?("Verification ID not found")
            return
        }

        onLoadingStatusChanged?(true)

        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: otp
        )

            Auth.auth().signIn(with: credential) { authResult, error in
                self.onLoadingStatusChanged?(false)

                if let error = error {
                    if error.localizedDescription.contains("Client does not match API key") {
                        self.onVerificationFailure?("⚠️ Simulator cannot verify real numbers. Use Firebase test numbers only.")
                    } else {
                        self.onVerificationFailure?("Verification failed: \(error.localizedDescription)")
                    }
                } else {
                    self.onVerificationSuccess?()
                }
            }
        
    }

}
