//
//  LoginViewModel.swift
//  instyfy
//
//  Created by Vedant Rewadkar on 17/10/25.
//
import Foundation
import FirebaseFirestore

class LoginViewModel {
    
    var emailOrPhone: String = ""
    var password: String = ""
    
    // Closures for binding
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    private let db = Firestore.firestore()
    
    func login() {
        // Check if input is empty
        guard !emailOrPhone.isEmpty, !password.isEmpty else {
            onLoginFailure?("Please enter email/phone and password")
            return
        }
        
        // Fetch data from Firestore
        let docRef = db.collection("Users").document("registerUser")
        docRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.onLoginFailure?("Firestore error: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else {
                self.onLoginFailure?("User not found")
                return
            }
            
            // Get stored email, mobile, password
            let storedEmail = data["email"] as? String ?? ""
            let storedMobile = data["mobile"] as? String ?? ""
            let storedPassword = data["password"] as? String ?? ""
            
            if (self.emailOrPhone == storedEmail || self.emailOrPhone == storedMobile),
               self.password == storedPassword {
                self.onLoginSuccess?()
            } else {
                self.onLoginFailure?("Invalid credentials")
            }
        }
    }
}
