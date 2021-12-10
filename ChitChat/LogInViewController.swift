//
//  ViewController.swift
//  ChitChat
//
//  Created by wingswift on 2021-12-05.
//

import UIKit
import ProgressHUD

class LogInViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet private(set) var emailLabel: UILabel!
    @IBOutlet private(set) var emailTextField: UITextField!
    
    @IBOutlet private(set) var passwordLabel: UILabel!
    @IBOutlet private(set) var passwordTextField: UITextField!
    
    @IBOutlet private(set) var repeatPasswordLabel: UILabel!
    @IBOutlet private(set) var repeatPasswordTextField: UITextField!
    @IBOutlet private(set) var repeatPasswordLineView: UIView!
    
    @IBOutlet private(set) var resendEmailButton: UIButton!
    @IBOutlet private(set) var logInButton: UIButton!
    
    @IBOutlet private(set) var signUpLabel: UILabel!
    @IBOutlet private(set) var signUpButton: UIButton!
    
    // MARK: - Vars
    var isLogin = true
    
    //MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFieldsDelegate()
        setUpBackgroundTap()
        configureUIFor(login: isLogin)
    }
    
    //MARK: - IBActions
    @IBAction func forgotPasswordPressed() {
        if isDataInputFor(type: "password") {
            resetPassword()
        } else {
            ProgressHUD.showFailed("Email is required.")
        }
    }
    
    @IBAction func resendEmailPressed() {
        if isDataInputFor(type: "password") {
            resendEmail()
        } else {
            ProgressHUD.showFailed("Email is required.")
        }
    }
    
    @IBAction func logInButtonPressed() {
        if isDataInputFor(type: isLogin ? "login": "register") {
            isLogin ? loginUser() : registerUser()
        } else {
            ProgressHUD.showFailed("All fields required.")
        }
    }
    
    @IBAction func signUpButtonPresssed(_ sender: UIButton) {
        configureUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    private func setUpTextFieldsDelegate() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func configureUIFor(login: Bool) {
        logInButton.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signUpButton.setTitle(login ? "Sign up" : "Login", for: .normal)
        signUpLabel.text = login ? "Don't have an account" : "Have an account?"
        UIView.animate(withDuration: 0.3) {
            self.repeatPasswordLabel.isHidden = login
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            emailLabel.text = textField.hasText ? "Email" : ""
        case passwordTextField:
            passwordLabel.text = textField.hasText ? "Password" : ""
        default:
            passwordLabel.text = textField.hasText ? "Repeat Password" : ""
        }
    }
    
    private func isDataInputFor(type: String) -> Bool {
        switch type {
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "register":
            return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
        default:
            return emailTextField.text != ""
        }
    }
    
    private func setUpBackgroundTap() {
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(gestureTap)
    }
    
    @objc func backgroundTapped() {
        view.endEditing(false)
    }
    
    private func loginUser() {
        FirebaseUserListener.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { error, isEmailVerified in
            if error == nil {
                if isEmailVerified {
                    self.goToApplication()
                } else {
                    ProgressHUD.showFailed("Please verify email.")
                    self.resendEmailButton.isHidden = false
                }
                
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    private func registerUser() {
        if passwordTextField.text == repeatPasswordTextField.text {
            FirebaseUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error in
                if error == nil {
                    ProgressHUD.showSuccess("Verification email sent.")
                    self.resendEmailButton.isHidden = false
                } else {
                    ProgressHUD.showFailed(error?.localizedDescription)
                }
            }
        } else {
            ProgressHUD.showFailed("Passwords do not match, please try again")
        }
    }
    
    private func resendEmail() {
        FirebaseUserListener.shared.resendVerificationEmail(email: emailTextField.text!) { error in
            if error == nil {
                ProgressHUD.showSuccess("New verification email sent.")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    private func resetPassword() {
        FirebaseUserListener.shared.resetPasswordFor(email: emailTextField.text!) { error in
            if error == nil {
                ProgressHUD.showSuccess("Reset password link sent")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    private func goToApplication() {
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true)
    }
    
}

