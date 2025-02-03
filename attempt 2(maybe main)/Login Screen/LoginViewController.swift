//
//  LoginViewController.swift
//  attempt 2(maybe main)
//
//  Created by admin100 on 07/01/25.
//


import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        navigationItem.hidesBackButton = true
        super.viewDidLoad()
        
        // Check if the user is already logged in
        if Auth.auth().currentUser != nil {
            transitionToHome()
        }
    }
    
    // Transition to the Home screen (TabBarController)
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instantiate the UITabBarController
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTC") as? UITabBarController {
            self.view.window?.rootViewController = tabBarController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    // Button actions to navigate programmatically
    @IBAction func goToLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func goToRegister(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    // Optional: Prepare for segue if you want to pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLogin" {
            if let destinationVC = segue.destination as? GoogleViewController {
                // Pass any data to GoogleViewController if needed
                //destinationVC.title = "GoogleVC"
            }
        } else if segue.identifier == "goToRegister" {
            if let destinationVC = segue.destination as? RegisterViewController {
                // Pass any data to RegisterViewController if needed
                //destinationVC.title = "RegisterVC"
            }
        }
    }
}
