//
//  RegisterViewModel.swift
//  instyfy
//
//  Created by Vedant Rewadkar on 21/10/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewModel {

    // MARK: - Properties
    var fullName: String = ""
    var userName: String = ""
    var email: String = ""
    var mobileNumber: String = ""
    var password: String = ""
    
    // Closures for UI updates
    var onRegisterSuccess: (() -> Void)?
    var onRegisterFailure: ((String) -> Void)?
    var onLoadingStatusChanged: ((Bool) -> Void)?
    
    // MARK: - Validation
    private func validateFields() -> Bool {
        let fields: [(String, String)] = [
            ("Full Name", fullName),
            ("Username", userName),
            ("Email", email),
            ("Mobile Number", mobileNumber),
            ("Password", password)
        ]
        
        for (name, value) in fields {
            if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                onRegisterFailure?("\(name) cannot be empty")
                return false
            }
        }
        
        if !isValidEmail(email) {
            onRegisterFailure?("Email is not valid")
            return false
        }
        
        // ✅ Mobile number validation for +91
        if !mobileNumber.hasPrefix("+91") {
            onRegisterFailure?("Mobile number must start with +91")
            return false
        }
        
        // Check if the remaining digits are numeric and exactly 10 digits
        let numberPart = mobileNumber.dropFirst(3) // remove +91
        if numberPart.count != 10 || !numberPart.allSatisfy({ $0.isNumber }) {
            onRegisterFailure?("Mobile number must have 10 digits after +91")
            return false
        }
        
        if password.count < 6 {
            onRegisterFailure?("Password must be at least 6 characters")
            return false
        }
        
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    // MARK: - Firebase Registration
    func registerUser() {
        guard validateFields() else { return }
        
        onLoadingStatusChanged?(true) // show loader
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().createUser(withEmail: trimmedEmail, password: trimmedPassword) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error as NSError? {
                print("Firebase createUser error: \(error), code: \(error.code), domain: \(error.domain)")
                self.onLoadingStatusChanged?(false)
                self.onRegisterFailure?(error.localizedDescription)
                return
            }
            
            self.saveUserInfoToFirestore()
        }

    }
    
    private func saveUserInfoToFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.onLoadingStatusChanged?(false)
            self.onRegisterFailure?("Unable to get user ID")
            return
        }
        
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "fullName": fullName,
            "userName": userName,
            "email": email,
            "mobileNumber": mobileNumber,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("Users").document(userId).setData(userData) { [weak self] error in
            guard let self = self else { return }
            self.onLoadingStatusChanged?(false)
            
            if let error = error {
                self.onRegisterFailure?("Failed to save user info: \(error.localizedDescription)")
            } else {
                self.onRegisterSuccess?()
            }
        }
    }
}
