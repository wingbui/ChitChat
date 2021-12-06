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
        // Do any additional setup after loading the view.
    }

    //MARK: - IBActions
    @IBAction func forgotPasswordPressed() {
        
    }
    
    @IBAction func resendEmailPressed() {
        
    }
    
    @IBAction func logInButtonPressed() {
        
    }
    
    @IBAction func SignUpButtonPressed() {
        
    }

}

