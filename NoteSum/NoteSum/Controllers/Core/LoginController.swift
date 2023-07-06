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

class LoginController:UIViewController{
    
    private let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        loginView.Password.resignFirstResponder() // dismiss keyoard
        loginView.UserName.resignFirstResponder()
    }
    
    @objc func loginClick(_ sender:UIButton!){
        // clean up the user data
        let email = loginView.UserName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = loginView.Password.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        // Signing in the User
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
                print(error)
            } else {
                print("Login Successful")
                //let myViewController: UITabBarController? = NSTabViewController()
                //let myNavigationController = UINavigationController(rootViewController: myViewController!)
                //self.navigationController?.pushViewController(myNavigationController, animated: true)
                let vc = NSTabViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    @objc func signUpClick(_ sender:UIButton!){
        let vc = SignUpController()
        self.present(vc, animated:true, completion:nil)
    }
    
    private func setUpView() {
//        historyListView.delegate = self
        view.addSubview(loginView)
        loginView.LoginButton.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        loginView.SignUpButton.addTarget(self, action: #selector(signUpClick), for: .touchUpInside)
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loginView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            loginView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            loginView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
}
