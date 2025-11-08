//
//  LoginViewModel.swift
//  instyfy
//
//  Created by Vedant Rewadkar on 17/10/25.
//

import Foundation
import FirebaseFirestore

class LoginViewModel {
    
    var emailOrPhoneOrUsername: String = ""
    var password: String = ""
    
    // Closures for binding
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    private let db = Firestore.firestore()
    
    func login() {
        // Validate input
        guard !emailOrPhoneOrUsername.isEmpty, !password.isEmpty else {
            onLoginFailure?("Please enter username/email/mobile and password")
            return
        }
        
        let usersRef = db.collection("Users")
        
        // 1️⃣ Try email first
        usersRef.whereField("email", isEqualTo: emailOrPhoneOrUsername).getDocuments { [weak self] (emailQuery, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.onLoginFailure?("Firestore error: \(error.localizedDescription)")
                return
            }
            
            if let doc = emailQuery?.documents.first {
                self.handleLogin(doc: doc)
            } else {
                // 2️⃣ Try username
                usersRef.whereField("userName", isEqualTo: self.emailOrPhoneOrUsername).getDocuments { (usernameQuery, error) in
                    if let error = error {
                        self.onLoginFailure?("Firestore error: \(error.localizedDescription)")
                        return
                    }
                    
                    if let doc = usernameQuery?.documents.first {
                        self.handleLogin(doc: doc)
                    } else {
                        // 3️⃣ Try mobile
                        usersRef.whereField("mobile", isEqualTo: self.emailOrPhoneOrUsername).getDocuments { (mobileQuery, error) in
                            if let error = error {
                                self.onLoginFailure?("Firestore error: \(error.localizedDescription)")
                                return
                            }
                            
                            if let doc = mobileQuery?.documents.first {
                                self.handleLogin(doc: doc)
                            } else {
                                self.onLoginFailure?("User not found")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Handle Login Result
    private func handleLogin(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        let storedPassword = data["password"] as? String ?? ""
        
        if storedPassword == password {
            onLoginSuccess?()
        } else {
            onLoginFailure?("Invalid password")
        }
    }
}
