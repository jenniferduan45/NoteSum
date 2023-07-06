//
//  NSProfileView.swift
//  NoteSum
//
//  Created by Isabelle Arevalo on 3/30/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

extension UIImageView {
    var url: URL? {
        get {
            return nil
        }
        set {
            guard let url = newValue else { return }
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}

class NSProfileView: UIView {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .black // placeholder color
        imageView.clipsToBounds = true
        return imageView
    }()


    let nameLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 5.0
        label.layer.backgroundColor = UIColor.white.cgColor
        label.paddingLeft = 60
        label.paddingRight = 60
        label.paddingTop = 10
        label.paddingBottom = 10
        return label
    }()
    
    let joinDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let statsView1: DisplayStatsView = {
        let statsView = DisplayStatsView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        statsView.label1.textAlignment = .center
        statsView.label1.font = UIFont.boldSystemFont(ofSize: 20)
        statsView.label2.text = "Documents Created"
        statsView.label2.textAlignment = .center
        statsView.label2.font = UIFont.systemFont(ofSize: 14)
        statsView.label2.textColor = .gray
        return statsView
    }()
    
    let accountInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Account Information"
        return label
    }()
    
    
    let nameTextField: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "username:"
        return label
    }()
    
    let usernameBox: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 5.0
        label.layer.backgroundColor = UIColor.white.cgColor
        label.paddingLeft = 77
        label.paddingRight = 77
        label.paddingTop = 8
        label.paddingBottom = 8
        return label
    }()
    
    let emailTextField: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "email:"
        return label
    }()
    
    let emailBox: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 5.0
        label.layer.backgroundColor = UIColor.white.cgColor
        label.paddingLeft = 40
        label.paddingRight = 40
        label.paddingTop = 8
        label.paddingBottom = 8
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
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
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(joinDateLabel)
        addSubview(statsView1)
        addSubview(accountInfoLabel)
        addSubview(nameTextField)
        addSubview(usernameBox)
        addSubview(emailTextField)
        addSubview(emailBox)
        addSubview(editButton)
        addSubview(logOutButton)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        joinDateLabel.translatesAutoresizingMaskIntoConstraints = false
        statsView1.translatesAutoresizingMaskIntoConstraints = false
        accountInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameBox.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailBox.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo:safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo:centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),

            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo:centerXAnchor),

            joinDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            joinDateLabel.centerXAnchor.constraint(equalTo:centerXAnchor),
                    
            statsView1.topAnchor.constraint(equalTo: joinDateLabel.bottomAnchor, constant: 30),
            statsView1.centerXAnchor.constraint(equalTo:centerXAnchor),
                    
                    
            accountInfoLabel.topAnchor.constraint(equalTo: statsView1.bottomAnchor, constant: 40),
            accountInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),

            nameTextField.topAnchor.constraint(equalTo: accountInfoLabel.bottomAnchor, constant: 25),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),

            usernameBox.topAnchor.constraint(equalTo: accountInfoLabel.bottomAnchor, constant: 20),
            usernameBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 150),

            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 25),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),

            emailBox.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            emailBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 150),
            
            editButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 50),
            editButton.centerXAnchor.constraint(equalTo:centerXAnchor, constant: -75),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.widthAnchor.constraint(equalToConstant: 100),
            
            logOutButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 50),
            logOutButton.centerXAnchor.constraint(equalTo:centerXAnchor, constant: 75),
            logOutButton.heightAnchor.constraint(equalToConstant: 50),
            logOutButton.widthAnchor.constraint(equalToConstant: 100),
        ])

        
    }
    
}
