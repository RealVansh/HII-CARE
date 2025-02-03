//
//  GoogleViewController.swift
//  attempt 2(maybe main)
//
//  Created by admin100 on 07/01/25.
//


import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class GoogleViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var togglePasswordButton: UIButton!
    var activityIndicator: UIActivityIndicatorView!
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        // Add your authentication logic here
        print("Login button clicked with email: \(email)")
    }
    // Variable to track password visibility
        private var isPasswordVisible = false


    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldStyles()
        setupActivityIndicator()

        // Add tap gesture to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        // Configure Google Sign-In
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("Missing clientID in GoogleService-Info.plist")
        }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

        // Add actions
        signInButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginWithEmail), for: .touchUpInside)
        // Set initial image for the password toggle button
        // By default, mask the password
                passwordTextField.isSecureTextEntry = true
                updateTogglePasswordButtonImage()
        passwordTextField.addTarget(self, action: #selector(handlePasswordVisibilityChange), for: .editingDidBegin)

    }
    @objc func dismissKeyboard() {
        view.endEditing(true) // This will dismiss the keyboard
    }
    private func setupKeyboardToolbar() {
        let textFields = [emailTextField, passwordTextField] // Include all your text fields
        textFields.forEach { textField in
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
            toolbar.items = [doneButton]
            textField?.inputAccessoryView = toolbar
        }
    }
    @objc func handlePasswordVisibilityChange() {
        let currentText = passwordTextField.text
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        passwordTextField.text = nil
        passwordTextField.insertText(currentText ?? "")
    }





    @objc func loginWithEmail() {
        guard let email = emailTextField.text, !email.isEmpty else {
            highlightTextField(emailTextField, withMessage: "Email cannot be empty")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            highlightTextField(passwordTextField, withMessage: "Password cannot be empty")
            return
        }

        // Start activity indicator
        activityIndicator.startAnimating()
        loginButton.isEnabled = false

        // Perform manual login
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            self.activityIndicator.stopAnimating()
            self.loginButton.isEnabled = true

            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                self.highlightTextField(self.passwordTextField, withMessage: "Invalid credentials")
                return
            }

            // Navigate to Home Screen
            self.showHomeScreen()
        }
    }

    @objc func signInWithGoogle() {
        print("Sign-in button tapped")
        activityIndicator.startAnimating()
        signInButton.isEnabled = false

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            self.activityIndicator.stopAnimating()
            self.signInButton.isEnabled = true

            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }

            guard let user = signInResult?.user, let idToken = user.idToken?.tokenString else {
                print("No user or idToken")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error authenticating: \(error.localizedDescription)")
                    return
                }

                guard let currentUser = Auth.auth().currentUser else {
                    print("Failed to fetch authenticated user.")
                    return
                }

                // Check if the user's displayName is empty
                
                    self.showHomeScreen()
               
            }
        }
    }

    

    func updateUserProfileWithName(name: String) {
        guard let user = Auth.auth().currentUser else { return }

        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
            } else {
                print("User profile updated successfully with name: \(name)")
                self.showHomeScreen()
            }
        }
    }

    func showHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTC") as? UITabBarController {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
            }
        }
    }

    private func highlightTextField(_ textField: UITextField, withMessage message: String) {
        textField.text = ""
        textField.attributedPlaceholder = NSAttributedString(
            string: message,
            attributes: [
                .foregroundColor: UIColor.red,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
    }

    private func setupTextFieldStyles() {
        let textFields = [emailTextField, passwordTextField]
        textFields.forEach { textField in
            textField?.layer.cornerRadius = 15
            textField?.backgroundColor = UIColor(named: "F7F8F9") ?? UIColor(red: 247/255, green: 248/255, blue: 249/255, alpha: 1.0)

            // Set the cursor (caret) color to blue
            textField?.tintColor = .blue

            if let placeholder = textField?.placeholder {
                textField?.attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [
                        .foregroundColor: UIColor.darkGray,
                        .font: UIFont.systemFont(ofSize: 16)
                    ]
                )
            }

            textField?.layer.masksToBounds = true
            textField?.layer.borderColor = UIColor.systemGray.cgColor
            textField?.layer.borderWidth = 1
        }
    }


    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    @IBAction func togglePasswordVisibility(_ sender: UIButton) {
        print("Toggle button clicked")
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        print("Password visibility is now: \(isPasswordVisible)")

        let currentText = passwordTextField.text
        passwordTextField.text = nil
        passwordTextField.insertText(currentText ?? "")

        updateTogglePasswordButtonImage()
        print("Updated button image")
    }





            
    private func updateTogglePasswordButtonImage() {
        let imageName = isPasswordVisible ? "eye.fill" : "eye.slash.fill"
        togglePasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

}
