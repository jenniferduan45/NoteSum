//
//  ViewController.swift
//  NoteSum
//
//  Created by Yuxuan Wu on 3/19/23.
//

import UIKit
import Firebase
import FirebaseAuth

class NSTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //fakeLogin()
        setUpTabs()
        print(Auth.auth().currentUser!.uid)
    }
    
    private func fakeLogin(){
        // clean up the user data
        let email = "test1@abc.com"
        let password = "123456"

        // Signing in the User
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
                //print(error)
            } else {
                print("Login Successful")
                //self.present(NSTabViewController(), animated: true)
            }
        }
    }
    
    private func setUpTabs() {
        let notesVC = NSNotesViewController()
        let historyVC = NSHistoryViewController()
        let settingVC = NSSettingViewController()
        
        notesVC.navigationItem.largeTitleDisplayMode = .automatic
        historyVC.navigationItem.largeTitleDisplayMode = .automatic
        settingVC.navigationItem.largeTitleDisplayMode = .automatic

        
        let nav1 = UINavigationController(rootViewController: notesVC)
        let nav2 = UINavigationController(rootViewController: historyVC)
        let nav3 = UINavigationController(rootViewController: settingVC)
        
        // tabBarItem (Make sure it shows at the beginning comparing to not show at the beginning)
        nav1.tabBarItem = UITabBarItem(title: "Notes", image: UIImage(systemName: "square.and.pencil"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "globe"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "gear"), tag: 3)

        
        // make Large Title
        for nav in [nav1, nav2, nav3] {
            nav.navigationBar.prefersLargeTitles = true
        }
        setViewControllers([nav1, nav2, nav3], animated: true)
    }


}

