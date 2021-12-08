//
//  ViewController.swift
//  ChitChat
//
//  Created by wingswift on 2021-12-05.
//

import UIKit

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
    
    //MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFieldsDelegate()
    }

    //MARK: - IBActions
    @IBAction func forgotPasswordPressed() {
        
    }
    
    @IBAction func resendEmailPressed() {
        
        
        
    }
    
    @IBAction func logInButtonPressed() {
        
    }
    
    @IBAction func signUpButtonPresssed(_ sender: UIButton) {
        configureUIFor(login: sender.titleLabel?.text == "Login")
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
    
}

