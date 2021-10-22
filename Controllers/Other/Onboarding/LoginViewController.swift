//
//  LoginViewController.swift
//  PedalNature
//
//  Created by Volkan on 24.09.2021.
//

import UIKit

struct Constants{
    static let cornerRadius = 8.0
}


class LoginViewController: UIViewController {

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
    
    private let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor(rgb: 0x5da973)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let headerView : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        let backgroundImageView = UIImageView(image: UIImage(named: "logoBackground"))
        view.addSubview(backgroundImageView)
        return view
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
    
    private let createAcountButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("No Account? Create an Account", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        emailField.delegate = self
        passwordField.delegate = self
        loginButton.addTarget(self,
                              action: #selector(didTapLoginButton),
                              for: .touchUpInside)
        createAcountButton.addTarget(self,
                                    action: #selector(didTapCreateAccountButton),
                                     for: .touchUpInside)
        privacyButton.addTarget(self,
                                action: #selector(didTapPrivacyLoginButton),
                                for: .touchUpInside)
        termsButton.addTarget(self,
                              action: #selector(didTapTermLoginButton),
                              for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //frames
        headerView.frame = CGRect(x: 0, y: view.top, width: view.width, height: view.width/1.5)
        emailField.frame = CGRect(x: 20, y: headerView.bottom + 20, width: view.width - 40, height: 52)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 20, width: view.width - 40, height: 52)
        loginButton.frame = CGRect(x: 20, y: passwordField.bottom + 20, width: view.width - 40, height: 52)
        createAcountButton.frame = CGRect(x: 20, y: loginButton.bottom + 20, width: view.width - 40, height: 52)
        privacyButton.frame = CGRect(x: 20, y: view.height - view.safeAreaInsets.bottom - 100, width: view.width - 40, height: 52)
        termsButton.frame = CGRect(x: 20, y: view.height - view.safeAreaInsets.bottom - 50, width: view.width - 40, height: 52)
        
        configureHeaderView()
    }
    
    private func addSubviews(){
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(createAcountButton)
        view.addSubview(headerView)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
    }
    
    private func configureHeaderView(){
        guard headerView.subviews.count == 1 else{
            return
        }
        
        guard let backgroundView = headerView.subviews.first else{
            return
        }
        
        backgroundView.frame = headerView.bounds
        
        let imageView = UIImageView(image: UIImage(named: "logo"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect(x: view.width/4, y: view.safeAreaInsets.top, width: view.width/2, height: view.width/2)
        
    }
    
    @objc private func didTapLoginButton(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let userEmail = emailField.text, !userEmail.isEmpty,
              let userPassword = passwordField.text, !userPassword.isEmpty, userPassword.count >= 8 else{
                  return
              }
        
        // Login functionality
        
        AuthManager.shared.loginUser(email: userEmail, password: userPassword) { success in
            DispatchQueue.main.async {
                if success{
                    self.dismiss(animated: true, completion: nil)
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
    
    @objc private func didTapTermLoginButton(){
        print("Terms")
        
    }
    
    @objc private func didTapPrivacyLoginButton(){
        print("Privacy")
        
    }
    
    @objc private func didTapCreateAccountButton(){
        let vc = RegisterViewController()
        //vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }

}

extension LoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }else{
            didTapLoginButton()
        }
        return true
    }
}
