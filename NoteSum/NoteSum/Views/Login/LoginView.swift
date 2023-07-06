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

class LoginView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(UserName, Password, LoginButton, SignUpButton)
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
        username.translatesAutoresizingMaskIntoConstraints = false
        username.textColor = .blue
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
    
    
    
    public let LoginButton: UIButton = {
        let login = UIButton()
        login.backgroundColor = .blue
        login.setTitle("Login", for: .normal)
        login.translatesAutoresizingMaskIntoConstraints = false
        return login
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
            
            UserName.centerXAnchor.constraint(equalTo: centerXAnchor),
            UserName.centerYAnchor.constraint(equalTo: Password.centerYAnchor, constant: -100),
            UserName.heightAnchor.constraint(equalToConstant: 50),
            UserName.widthAnchor.constraint(equalToConstant: 250),
            
            LoginButton.leftAnchor.constraint(equalTo: Password.leftAnchor),
            LoginButton.centerYAnchor.constraint(equalTo: Password.centerYAnchor, constant: 100),
            LoginButton.heightAnchor.constraint(equalToConstant: 50),
            LoginButton.widthAnchor.constraint(equalToConstant: 100),
            
            SignUpButton.rightAnchor.constraint(equalTo: Password.rightAnchor),
            SignUpButton.centerYAnchor.constraint(equalTo: Password.centerYAnchor, constant: 100),
            SignUpButton.heightAnchor.constraint(equalToConstant: 50),
            SignUpButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }

}

