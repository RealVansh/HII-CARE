//
//  ProfileViewController.swift
//  OnboardingScreens
//
//  Created by admin100 on 26/12/24.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currentProfile: Profile?

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var PersonImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var WhiteView: UIView!
    
    private let options = ProfileOption.options // Fetching data from the model
        
    override func viewDidLoad() {
    
        super.viewDidLoad()
        setupUI()
        Profile.fetchCurrentUser { [weak self] profile in
                guard let self = self else { return }
                if let profile = profile {
                    self.currentProfile = profile
                    
                    DispatchQueue.main.async {
                        // Update the UI elements
                        self.nameLabel.text = profile.name
                        self.detailLabel.text = profile.email
                        
                        self.PersonImageView.image = UIImage(named: profile.imageName)
                        self.PersonImageView.layer.cornerRadius = 50
                        self.PersonImageView.clipsToBounds = true
                        self.PersonImageView.contentMode = .scaleAspectFill
                    }
                } else {
                    print("No user is signed in.")
                }
            }

            // Setup TableView
            tableView.delegate = self
            tableView.dataSource = self
                
            // Register the custom cell
            tableView.register(UINib(nibName: "ProfileMainTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileMainTableViewCell")
            
            // Logout Button
            logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        }
    private func setupUI(){
        WhiteView.layer.cornerRadius = 20
        // Allow shadows
        WhiteView.layer.masksToBounds = false
        // Add shadow properties
        WhiteView.layer.shadowColor = UIColor.black.cgColor
        WhiteView.layer.shadowOpacity = 0.1
        WhiteView.layer.shadowOffset = CGSize(width: 0, height: 4)
        WhiteView.layer.shadowRadius = 10
        // Apply rounded corners
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: WhiteView.bounds, cornerRadius: 20).cgPath
        WhiteView.layer.mask = maskLayer

    }
    
    @objc func logoutTapped() {
        do{
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            print("Signed out")
            navigateToLogin()
        }
        catch let signOutError as NSError{
            print("Error signing outL %@", signOutError)
            
        }
    }
    func navigateToLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        self.view.window?.rootViewController = loginViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    // MARK: - UITableViewDataSource
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return options.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMainTableViewCell", for: indexPath) as? ProfileMainTableViewCell else {
                return UITableViewCell()
            }
            
            let option = options[indexPath.row]
            
            // Configure the cell
            cell.symbolImage.image = UIImage(systemName: option.symbolImageName)
            cell.symbolImage.tintColor = UIColor(hexCode: "2C14DD")
            cell.nameLabel.text = option.name
            cell.viewForSymbol.layer.cornerRadius = 15
            cell.viewForSymbol.backgroundColor = UIColor(hexCode: "2C14DD").withAlphaComponent(0.1)
            cell.viewForSymbol.layer.masksToBounds = true
            return cell
        }
        
    // MARK: - UITableViewDelegate

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
            let selectedOption = options[indexPath.row]
        
            if selectedOption.name == "My Account" {
            // Trigger the segue to MyAccountViewController
                performSegue(withIdentifier: "showMyAccount", sender: self)
            }
            else if selectedOption.name == "Settings"{
                performSegue(withIdentifier: "showSettings", sender: self)
            }
        }
        
        // Add spacing between cells
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return UIView()
        }
//        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//            return 100
//        }

    }

