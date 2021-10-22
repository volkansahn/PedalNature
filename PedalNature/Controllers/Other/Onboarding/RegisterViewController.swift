//
//  RegisterViewController.swift
//  PedalNature
//
//  Created by Volkan on 24.09.2021.
//

import UIKit

class RegisterViewController: UIViewController {

    private let emailField : UITextField = {
        let field = UITextField()
        field.placeholder = "Email..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let passwordField : UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "Password..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
        
    }()
    
    private let signUpButton : UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor(rgb: 0x5da973)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let signUplabel : UILabel = {
        let label = UILabel()
        label.text = "Sign Up to PedalNature"
        label.numberOfLines = 2
        label.font = UIFont(name: "Georgia-Bold", size: 48.0)
        
        label.textColor = UIColor(rgb: 0x5da973)
        return label
    }()
    
    private let termsButton : UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Service", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let privacyButton : UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        emailField.delegate = self
        passwordField.delegate = self
        signUpButton.addTarget(self,
                              action: #selector(didTapSignUpButton),
                              for: .touchUpInside)
        privacyButton.addTarget(self,
                                action: #selector(didTapPrivacyLoginButton),
                                for: .touchUpInside)
        termsButton.addTarget(self,
                              action: #selector(didTapTermLoginButton),
                              for: .touchUpInside)
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //frames
        signUplabel.frame = CGRect(x: 20, y: view.top + 20, width: view.width - 40, height: view.width/1.5)
        emailField.frame = CGRect(x: 20, y: signUplabel.bottom + 20, width: view.width - 40, height: 52)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 20, width: view.width - 40, height: 52)
        signUpButton.frame = CGRect(x: 20, y: passwordField.bottom + 20, width: view.width - 40, height: 52)
        privacyButton.frame = CGRect(x: 20, y: view.height - view.safeAreaInsets.bottom - 100, width: view.width - 40, height: 52)
        termsButton.frame = CGRect(x: 20, y: view.height - view.safeAreaInsets.bottom - 50, width: view.width - 40, height: 52)
        
    }
    
    private func addSubviews(){
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(signUplabel)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
    }
    
    @objc private func didTapSignUpButton(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let userEmail = emailField.text, !userEmail.isEmpty,
              let userPassword = passwordField.text, !userPassword.isEmpty, userPassword.count >= 8 else{
                  return
              }
        
        // Create Account
     
        AuthManager.shared.registerUser(email: userEmail, password: userPassword) { success in
            DispatchQueue.main.async {
                if success{
                    self.dismiss(animated: true) {
                        AuthManager.shared.loginUser(email: userEmail, password: userPassword) { success in
                            DispatchQueue.main.async {
                                if success{
                                    self.dismiss(animated: true) {
                                        let vc = HomeViewController()
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                                else{
                                    let alert = UIAlertController(title: "Login Error",
                                                                  message: "Unable to Logged you in!", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }

                            }
                        }
                    }
                    
                   
                }
                else{
                    let alert = UIAlertController(title: "Register Error",
                                                  message: "Unable to Register you!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }

            }
        }
        
    }
    
    @objc private func didTapTermLoginButton(){
        print("Terms")
        
    }
    
    @objc private func didTapPrivacyLoginButton(){
        print("Privacy")
        
    }

}

extension RegisterViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }else{
            didTapSignUpButton()
        }
        return true
    }
}

