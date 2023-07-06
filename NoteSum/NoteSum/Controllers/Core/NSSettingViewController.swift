//
//  NSSettingViewController.swift
//  NoteSum
//
//  Created by Yuxuan Wu on 3/19/23.
//
import Foundation
import UIKit
import Firebase
import FirebaseAuth

class NSSettingViewController: UIViewController {
    
    func getInfo() -> (String, String, Date, URL) {
        print("getInfo")
        let photoUrl: URL? = URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/15/Cat_August_2010-4.jpg")
        var email = ""
        var displayName = ""
        var creationDate = Date()
        var url: URL?
        
        if let currentUser = Auth.auth().currentUser {
            email = currentUser.email ?? "None"
            displayName = currentUser.displayName ?? "None"
            creationDate = currentUser.metadata.creationDate ?? Date()
            url = currentUser.photoURL
        } else {
            print("No user signed in.")
        }
        
        return (email, displayName, creationDate, url ?? photoUrl ?? URL(fileURLWithPath: ""))
    }
    
    func numDocs(completion: @escaping (Int) -> Void) {
        let user = Auth.auth().currentUser
        if let user = user {
            let currentUserUID = user.uid
            print("user id: ", currentUserUID)
            
            let db = Firestore.firestore()
            
            db.collection("notes").whereField("user_id", isEqualTo: currentUserUID).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching notes: \(error.localizedDescription)")
                    completion(0) // Return 0 if there's an error
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No notes found for the user")
                        completion(0) // Return 0 if there are no documents
                        return
                    }
                    completion(documents.count) // Return the document count
                }
            }
        }
    }

    
    @objc func editClick(_ sender:UIButton!){
        print("Edit clicked")
        let vc = NSEditProfileController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func logOutClick(_ sender:UIButton!){
        print("Log Out clicked")
        let vc = LoginController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private let ProfileView = NSProfileView()
    
    override dynamic func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        let (email,displayName,creationDate,photoUrl) = getInfo()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateString = dateFormatter.string(from: creationDate)
        
        ProfileView.nameLabel.text = displayName
        ProfileView.joinDateLabel.text = "Member since \(dateString)"
        ProfileView.usernameBox.text = displayName
        ProfileView.emailBox.text = email
        ProfileView.profileImageView.url = photoUrl
        numDocs { count in
            print("Profile document count: \(count)")
            self.ProfileView.statsView1.label1.text = String(count)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profile"
        
        view.addSubview(ProfileView)
        ProfileView.editButton.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        ProfileView.logOutButton.addTarget(self, action: #selector(logOutClick), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            ProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ProfileView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            ProfileView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            ProfileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        // Do any additional setup after loading the view.
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
