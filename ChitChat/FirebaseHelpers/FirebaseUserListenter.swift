//
//  FirebaseUserListenter.swift
//  ChitChat
//
//  Created by wingswift on 2021-12-08.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseUserListener {
    
    static let shared = FirebaseUserListener()
    private init() {}
    
    func loginUserWithEmail(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailedVerified: Bool) -> Void ) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error == nil && authResult!.user.isEmailVerified {
                FirebaseUserListener.shared.getUserFromDatabase(userId: authResult!.user.uid, email: email)
                completion(error, true)
            } else {
                print("Email is not verified");
                completion(error, false)
            }
        }
    }
    
    func registerUserWith(email: String,  password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(error)
            
            if error == nil {
                authResult?.user.sendEmailVerification(completion: { error in
                    if error != nil {
                        print("Error sent email verification: ", "\(String(describing: error?.localizedDescription))")
                    }
                })
                
                if authResult?.user != nil {
                    let user = User(id: authResult!.user.uid, email: email, username: email, pushId: "", avatarLink: "", status: "Hey there, I'm using ChitChat now")
                    
                    saveUserLocally(user)
                    self.saveUserToDatabase(user)
                }
            }
        }
    }
    
    func resendVerificationEmail(email: String, completion: @escaping(_ error: Error?) -> Void) {
        Auth.auth().currentUser?.reload(completion: { error in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    
    func resetPasswordFor(email: String, completion: @escaping(_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    // MARK: - CRUDs with database
    func saveUserToDatabase(_ user: User) {
        do {
            try firebaseReference(.User).document(user.id).setData(from: user)
        } catch {
            print("Error saving user to db", error.localizedDescription)
        }
    }
    
    func getUserFromDatabase(userId: String, email: String? = nil) {
        firebaseReference(.User).document(userId).getDocument { snapshot, error in
            guard let document = snapshot else {
                print("No document for user")
                return
            }
            
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                } else {
                    print("Document does not exist.")
                }
            case .failure(let error):
                print("Error decoding error", error)
            }
        }
    }
}
