import Foundation
import FirebaseAuth
import FirebaseFirestore


//testing pending
class ResetPasswordViewModel {
    
    private let db = Firestore.firestore()
    
    var onSuccess: ((String) -> Void)?
    var onFailure: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    // MARK: - Reset Password After OTP Verification
    func resetPassword(for mobile: String, newPassword: String) {
        onLoading?(true)

        db.collection("Users")
            .whereField("mobile", isEqualTo: mobile)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.onLoading?(false)
                    self.onFailure?("Error fetching user: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    self.onLoading?(false)
                    self.onFailure?("No user found with this mobile number.")
                    return
                }
                
                let data = document.data()
                
                guard let email = data["email"] as? String,
                      let oldPassword = data["password"] as? String else {
                    self.onLoading?(false)
                    self.onFailure?("User data incomplete in Firestore.")
                    return
                }

                Auth.auth().signIn(withEmail: email, password: oldPassword) { authResult, signInError in
                    if let signInError = signInError {
                        self.onLoading?(false)
                        self.onFailure?("Sign-in failed: \(signInError.localizedDescription)")
                        return
                    }
                    
                    guard let currentUser = Auth.auth().currentUser else {
                        self.onLoading?(false)
                        self.onFailure?("No user signed in after reauth.")
                        return
                    }
                    
                    if oldPassword == newPassword{
                        self.onLoading?(false)
                        self.onFailure?("New Password should be diffrent that previous one")
                    }
                    
                    currentUser.updatePassword(to: newPassword) { error in
                        if let error = error {
                            self.onLoading?(false)
                            self.onFailure?("Failed to update password in Auth: \(error.localizedDescription)")
                            return
                        }

                    document.reference.updateData(["password": newPassword]) { error in
                        self.onLoading?(false)
                        
                        if let error = error {
                            self.onFailure?("Password updated in Auth but failed in Firestore: \(error.localizedDescription)")
                        } else {
                            self.onSuccess?("Password updated successfully.")
                        }
                    }
                }
            }
        }
    }
}
