//
//  LoginController.swift
//  NoteSum
//
//  Created by 唐溢知 on 4/4/23.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class SignUpController:UIViewController{
    
    private let signupView = SignUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        signupView.Password.resignFirstResponder() // dismiss keyoard
        signupView.UserName.resignFirstResponder()
        signupView.ConfirmPassword.resignFirstResponder()
        signupView.ConfirmUserName.resignFirstResponder()
    }
    
    @objc func signUpClick(_ sender:UIButton!){
        if(signupView.UserName.text! != signupView.ConfirmUserName.text! || signupView.Password.text! != signupView.ConfirmPassword.text!){
            print("Does Not Match")
        } else {
            let email = signupView.UserName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = signupView.Password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard let user = authResult?.user, error == nil else {
                    print("ERORR")
                    print(error)
                    return
                }
                print("SUCCESSFUL")
                print("\(user.email!) created")
                self.dismiss(animated: true, completion: nil)
              }
        }
        
    }
    
    
    
    private func setUpView() {
//        historyListView.delegate = self
        view.addSubview(signupView)
        signupView.SignUpButton.addTarget(self, action: #selector(signUpClick), for: .touchUpInside)
        NSLayoutConstraint.activate([
            signupView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signupView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            signupView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            signupView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
}
