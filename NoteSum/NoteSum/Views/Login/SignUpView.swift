//
//  LoginView.swift
//  NoteSum
//
//  Created by 唐溢知 on 4/4/23.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth


class SignUpView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(Password, ConfirmPassword, UserName, ConfirmUserName, SignUpButton)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    public let UserName: UITextField = {
        let username = UITextField()
        username.autocapitalizationType = .none
        username.font = .systemFont(ofSize: 20, weight: .medium)
        username.placeholder = "Enter Username"
        username.textColor = .blue
        username.translatesAutoresizingMaskIntoConstraints = false
        username.borderStyle = .roundedRect
        username.isSecureTextEntry = false
        return username
    }()
    
    public let ConfirmUserName: UITextField = {
        let username = UITextField()
        username.autocapitalizationType = .none
        username.font = .systemFont(ofSize: 20, weight: .medium)
        username.placeholder = "Please Confirm Your Username"
        username.textColor = .blue
        username.translatesAutoresizingMaskIntoConstraints = false
        username.borderStyle = .roundedRect
        username.isSecureTextEntry = false
        return username
    }()
    
    public let Password: UITextField = {
        let password = UITextField()
        password.autocapitalizationType = .none
        password.font = .systemFont(ofSize: 20, weight: .medium)
        password.textColor = .blue
        password.placeholder = "Enter Password"
        password.translatesAutoresizingMaskIntoConstraints = false
        password.borderStyle = .roundedRect
        password.isSecureTextEntry = true
        return password
    }()
    
    public let ConfirmPassword: UITextField = {
        let password = UITextField()
        password.autocapitalizationType = .none
        password.font = .systemFont(ofSize: 20, weight: .medium)
        password.textColor = .blue
        password.placeholder = "Please Confirm Password"
        password.translatesAutoresizingMaskIntoConstraints = false
        password.borderStyle = .roundedRect
        password.isSecureTextEntry = true
        return password
    }()
    
    
    
    public let SignUpButton: UIButton = {
        let signup = UIButton()
        signup.backgroundColor = .blue
        signup.setTitle("Sign Up", for: .normal)
        signup.translatesAutoresizingMaskIntoConstraints = false
        return signup
    }()
    
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            Password.centerXAnchor.constraint(equalTo: centerXAnchor),
            Password.centerYAnchor.constraint(equalTo: centerYAnchor),
            Password.heightAnchor.constraint(equalToConstant: 50),
            Password.widthAnchor.constraint(equalToConstant: 250),
            
            ConfirmUserName.centerXAnchor.constraint(equalTo: centerXAnchor),
            ConfirmUserName.centerYAnchor.constraint(equalTo: Password.centerYAnchor, constant: -100),
            ConfirmUserName.heightAnchor.constraint(equalToConstant: 50),
            ConfirmUserName.widthAnchor.constraint(equalToConstant: 250),
            
            UserName.centerXAnchor.constraint(equalTo: centerXAnchor),
            UserName.centerYAnchor.constraint(equalTo: ConfirmUserName.centerYAnchor, constant: -100),
            UserName.heightAnchor.constraint(equalToConstant: 50),
            UserName.widthAnchor.constraint(equalToConstant: 250),
            
            ConfirmPassword.centerXAnchor.constraint(equalTo: centerXAnchor),
            ConfirmPassword.centerYAnchor.constraint(equalTo: Password.centerYAnchor, constant: 100),
            ConfirmPassword.heightAnchor.constraint(equalToConstant: 50),
            ConfirmPassword.widthAnchor.constraint(equalToConstant: 250),
            
            SignUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            SignUpButton.centerYAnchor.constraint(equalTo: ConfirmPassword.centerYAnchor, constant: 100),
            SignUpButton.heightAnchor.constraint(equalToConstant: 50),
            SignUpButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }

}

