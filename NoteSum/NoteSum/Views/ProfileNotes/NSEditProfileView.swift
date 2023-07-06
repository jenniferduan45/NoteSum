//
//  NSEditProfileView.swift
//  NoteSum
//
//  Created by Isabelle Arevalo on 4/13/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NSEditProfileView: UIView {
    
    let imageTextField: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Profile Image Url:"
        return label
    }()
    
    let imageBox: UITextField = {
        let username = UITextField()
        username.font = .systemFont(ofSize: 20, weight: .medium)
        username.placeholder = "Profile Image Url"
        username.textColor = .blue
        username.translatesAutoresizingMaskIntoConstraints = false
        username.borderStyle = .roundedRect
        username.isSecureTextEntry = false
        return username
    }()
    
    let nameTextField: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "User Name:"
        return label
    }()
    
    let usernameBox: UITextField = {
        let username = UITextField()
        username.font = .systemFont(ofSize: 20, weight: .medium)
        username.placeholder = "User Name"
        username.textColor = .blue
        username.translatesAutoresizingMaskIntoConstraints = false
        username.borderStyle = .roundedRect
        username.isSecureTextEntry = false
        return username
    }()
    
    let emailTextField: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Email:"
        return label
    }()
    
    let emailBox: UITextField = {
        let username = UITextField()
        username.font = .systemFont(ofSize: 20, weight: .medium)
        username.placeholder = "Email"
        username.textColor = .blue
        username.translatesAutoresizingMaskIntoConstraints = false
        username.borderStyle = .roundedRect
        username.isSecureTextEntry = false
        return username
    }()
    
    let passwordTextField: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Password:"
        return label
    }()
    
    let passwordBox: UITextField = {
        let username = UITextField()
        username.font = .systemFont(ofSize: 20, weight: .medium)
        username.placeholder = "Password"
        username.textColor = .blue
        username.translatesAutoresizingMaskIntoConstraints = false
        username.borderStyle = .roundedRect
        username.isSecureTextEntry = true
        return username
    }()
    
    let confirmPasswordTextField: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Password:"
        return label
    }()
    
    let confirmPasswordBox: UITextField = {
        let username = UITextField()
        username.font = .systemFont(ofSize: 20, weight: .medium)
        username.placeholder = "Confirm Password"
        username.textColor = .blue
        username.translatesAutoresizingMaskIntoConstraints = false
        username.borderStyle = .roundedRect
        username.isSecureTextEntry = true
        return username
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        addSubview(imageTextField)
        addSubview(imageBox)
        addSubview(nameTextField)
        addSubview(usernameBox)
        addSubview(emailTextField)
        addSubview(emailBox)
        addSubview(passwordTextField)
        addSubview(passwordBox)
        addSubview(confirmPasswordTextField)
        addSubview(confirmPasswordBox)
        addSubview(doneButton)
        addSubview(backButton)
        
        imageTextField.translatesAutoresizingMaskIntoConstraints = false
        imageBox.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameBox.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailBox.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordBox.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordBox.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            imageTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            imageTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),

            imageBox.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            imageBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 200),

            nameTextField.topAnchor.constraint(equalTo: imageTextField.bottomAnchor, constant: 50),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),

            usernameBox.topAnchor.constraint(equalTo: imageTextField.bottomAnchor, constant: 50),
            usernameBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 200),

            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),

            emailBox.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 50),
            emailBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 200),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 50),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            
            passwordBox.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 50),
            passwordBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 200),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            
            confirmPasswordBox.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            confirmPasswordBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 200),
            
            doneButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 50),
            doneButton.centerXAnchor.constraint(equalTo:centerXAnchor, constant: -75),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            doneButton.widthAnchor.constraint(equalToConstant: 100),
            
            backButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 50),
            backButton.centerXAnchor.constraint(equalTo:centerXAnchor, constant: 75),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 100),
        
        ])

        
    }
    
}
