//
//  NSEditProfileController.swift
//  NoteSum
//
//  Created by Isabelle Arevalo on 4/13/23.
//

import UIKit
import Firebase
import FirebaseAuth

class NSEditProfileController: UIViewController {
    
    private let EditProfileView = NSEditProfileView()
    
    @objc func doneClick(_ sender:UIButton!){
        print("Done clicked")
        
        var imageURL: String?
        var name: String?
        var email: String?
        var password: String?
        
        let trimmedImageURL = EditProfileView.imageBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedImageURL.isEmpty {
            imageURL = trimmedImageURL
        }

        let trimmedName = EditProfileView.usernameBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            name = trimmedName
        }

        let trimmedEmail = EditProfileView.emailBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedEmail.isEmpty {
            email = trimmedEmail
        }

        let trimmedPassword = EditProfileView.passwordBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirmPassword = EditProfileView.confirmPasswordBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedPassword.isEmpty && trimmedPassword == trimmedConfirmPassword {
            password = trimmedPassword
        }
        
        if let updatedURL = imageURL {
            // The name variable has been updated, so we can process it here
            print("Updated image url: \(updatedURL)")
            if let url = URL(string: updatedURL){
                if let user = Auth.auth().currentUser {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.photoURL = url
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("Error updating user profile: \(error.localizedDescription)")
                        } else {
                            print("Image url updated successfully.")
                            let vc = NSTabViewController()
                            vc.modalPresentationStyle = .fullScreen
                            //vc.selectedViewController = vc.viewControllers?[2]
                            self.present(vc, animated: true, completion: {
                                // Show a temporary alert after the view controller has been presented
                                let alert = UIAlertController(title: "Profile Update Completed", message: "Please see the profile tab to view your changes.", preferredStyle: .alert)
                                vc.present(alert, animated: true, completion: nil)

                                // Dismiss the alert after a delay
                                let delay = 3.0 // Delay in seconds
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                                    alert.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                    }
                }

            }
        }
        
        if let updatedName = name {
            // The name variable has been updated, so we can process it here
            print("Updated name: \(updatedName)")
            if let user = Auth.auth().currentUser {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = updatedName
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Error updating user profile: \(error.localizedDescription)")
                    } else {
                        print("User name updated successfully.")
                        let vc = NSTabViewController()
                        vc.modalPresentationStyle = .fullScreen
                        //vc.selectedViewController = vc.viewControllers?[2]
                        self.present(vc, animated: true, completion: {
                            // Show a temporary alert after the view controller has been presented
                            let alert = UIAlertController(title: "Profile Update Completed", message: "Please see the profile tab to view your changes.", preferredStyle: .alert)
                            vc.present(alert, animated: true, completion: nil)

                            // Dismiss the alert after a delay
                            let delay = 3.0 // Delay in seconds
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                                alert.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                }
            }
        }
        
        if let updatedEmail = email {
            // The email variable has been updated, so we can process it here
            print("Updated email: \(updatedEmail)")
            
            if let user = Auth.auth().currentUser {
                user.updateEmail(to: updatedEmail) { error in
                    if let error = error {
                        print("Error updating email: \(error.localizedDescription)")
                    } else {
                        print("Email updated successfully")
                        let vc = LoginController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: {
                            // Show a temporary alert after the view controller has been presented
                            let alert = UIAlertController(title: "Update Completed", message: "Please log back in with new credentials.", preferredStyle: .alert)
                            vc.present(alert, animated: true, completion: nil)

                            // Dismiss the alert after a delay
                            let delay = 3.0 // Delay in seconds
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                                alert.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                }
            }
        }
        
        if let updatedPass = password {
            // The phone variable has been updated, so we can process it here
            print("Updated password: \(updatedPass)")
            if let user = Auth.auth().currentUser {
                user.updatePassword(to: updatedPass) { error in
                    if let error = error {
                        print("Error updating password: \(error.localizedDescription)")
                    } else {
                        print("Password updated successfully")
                        let vc = LoginController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: {
                            // Show a temporary alert after the view controller has been presented
                            let alert = UIAlertController(title: "Update Completed", message: "Please log back in with new credentials.", preferredStyle: .alert)
                            vc.present(alert, animated: true, completion: nil)

                            // Dismiss the alert after a delay
                            let delay = 3.0 // Delay in seconds
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                                alert.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                }
            }
        }
    }
    
    @objc func backClick(_ sender:UIButton!){
        print("Back clicked")
        let vc = NSTabViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.selectedViewController = vc.viewControllers?[2]
        self.present(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Edit Profile"
        
        view.addSubview(EditProfileView)
        // dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        EditProfileView.doneButton.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
        EditProfileView.backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        NSLayoutConstraint.activate([
            EditProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            EditProfileView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            EditProfileView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            EditProfileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    @objc func handleTap() {
        EditProfileView.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
