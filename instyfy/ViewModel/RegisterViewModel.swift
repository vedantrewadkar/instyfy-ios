import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewModel {
    var onRegisterFailure: ((String) -> Void)?
    var onUserExistenceChecked: ((Bool, String?) -> Void)?
    var onRegisterSuccess: (() -> Void)?
    var onLoadingStatusChanged: ((Bool) -> Void)?
    
    // MARK: - Validate Fields
    func validateFields(user: User) -> Bool {
        let fields: [(String, String)] = [
            ("Full Name", user.fullName),
            ("Username", user.username),
            ("Email", user.email),
            ("Mobile Number", user.mobile),
            ("Password", user.password)
        ]
        
        for (name, value) in fields where value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onRegisterFailure?("\(name) cannot be empty")
            return false
        }
        
        if !isValidEmail(user.email) {
            onRegisterFailure?("Invalid email format")
            return false
        }
        
        if !user.mobile.hasPrefix("+91") {
            onRegisterFailure?("Mobile number must start with +91")
            return false
        }
        
        let numberPart = user.mobile.dropFirst(3)
        if numberPart.count != 10 || !numberPart.allSatisfy({ $0.isNumber }) {
            onRegisterFailure?("Mobile number must have 10 digits after +91")
            return false
        }
        
        if user.password.count < 6 {
            onRegisterFailure?("Password must be at least 6 characters")
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    // MARK: - Sequential Firestore Check
    func checkUserExistence(user: User) {
        let db = Firestore.firestore()
        let usersRef = db.collection("Users")
        
        onLoadingStatusChanged?(true)
        
        // 1️⃣ Check by mobile
        usersRef.whereField("mobile", isEqualTo: user.mobile).getDocuments { snapshot, error in
            if let error = error {
                self.onLoadingStatusChanged?(false)
                self.onUserExistenceChecked?(false, "Error checking mobile: \(error.localizedDescription)")
                return
            }
            if let snapshot = snapshot, !snapshot.documents.isEmpty {
                self.onLoadingStatusChanged?(false)
                self.onUserExistenceChecked?(true, "Mobile number already registered.")
                return
            }
            
            // 2️⃣ Check by email
            usersRef.whereField("email", isEqualTo: user.email).getDocuments { snapshot, error in
                if let error = error {
                    self.onLoadingStatusChanged?(false)
                    self.onUserExistenceChecked?(false, "Error checking email: \(error.localizedDescription)")
                    return
                }
                if let snapshot = snapshot, !snapshot.documents.isEmpty {
                    self.onLoadingStatusChanged?(false)
                    self.onUserExistenceChecked?(true, "Email is already in use.")
                    return
                }
                
                // 3️⃣ Check by username
                usersRef.whereField("userName", isEqualTo: user.username).getDocuments { snapshot, error in
                    self.onLoadingStatusChanged?(false)
                    
                    if let error = error {
                        self.onUserExistenceChecked?(false, "Error checking username: \(error.localizedDescription)")
                        return
                    }
                    if let snapshot = snapshot, !snapshot.documents.isEmpty {
                        self.onUserExistenceChecked?(true, "Username already taken.")
                        return
                    }
                    
                    // ✅ All checks passed
                    self.onUserExistenceChecked?(false, nil)
                }
            }
        }
    }
    
    
    // MARK: - Register User
    func registerUser(user: User) {
        self.onLoadingStatusChanged?(true)
        
        // Step 1: Create user with email + password
        Auth.auth().createUser(withEmail: user.email, password: user.password) { result, error in
            if let error = error {
                self.onLoadingStatusChanged?(false)
                print(error.localizedDescription)
                self.onRegisterFailure?("Registration failed: \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else {
                self.onLoadingStatusChanged?(false)
                self.onRegisterFailure?("Failed to retrieve user ID.")
                return
            }

            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "uid": uid,
                "fullName": user.fullName,
                "userName": user.username,
                "email": user.email,
                "mobile": user.mobile,
                "password": user.password,
                "createdAt": FieldValue.serverTimestamp()
            ]
            
            db.collection("Users").document(uid).setData(userData, merge: true) { error in
                self.onLoadingStatusChanged?(false)
                if let error = error {
                    self.onRegisterFailure?("Error saving user: \(error.localizedDescription)")
                    return
                }
                
                self.onRegisterSuccess?()
            }
        }
    }
}

