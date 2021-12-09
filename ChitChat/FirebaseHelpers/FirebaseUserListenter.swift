//
//  FirebaseUserListenter.swift
//  ChitChat
//
//  Created by wingswift on 2021-12-08.
//

import Foundation
import Firebase

class FirebaseUserListener {
    
    static let shared = FirebaseUserListener()
    private init() {}
    
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
    
    // MARK: - CRUDs with database
    func saveUserToDatabase(_ user: User) {
        do {
           try firebaseReference(.User).document(user.id).setData(from: user)
        } catch {
            print("Error saving user to db", error.localizedDescription)
        }
    }
}
