//
//  RegisterViewController.swift
//  attempt 2(maybe main)
//
//  Created by admin100 on 07/01/25.
//


import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    // Activity Indicator
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldStyles()
        setupActivityIndicator()
        setupKeyboardToolbar()

        // Add tap gesture to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true) // This will dismiss the keyboard
    }
    private func setupKeyboardToolbar() {
        let textFields = [emailTextField, passwordTextField, confirmPasswordTextField] // Include all your text fields
        textFields.forEach { textField in
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
            toolbar.items = [doneButton]
            textField?.inputAccessoryView = toolbar
        }
    }



    @IBAction func signupClicked(_ sender: UIButton) {
        guard let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
              password == confirmPassword else {
            // Display error if passwords do not match
            displayErrorInConfirmPasswordField("Passwords do not match")
            return
        }

        guard let email = emailTextField.text, !email.isEmpty,
              let username = nameTextField.text, !username.isEmpty else {
            print("Email or Username cannot be empty")
            return
        }

        // Start the activity indicator
        activityIndicator.startAnimating()
        registerButton.isEnabled = false

        // Register the user
        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
            // Stop the activity indicator
            self.activityIndicator.stopAnimating()
            self.registerButton.isEnabled = true

            if let error = error as NSError? {
                // Handle specific Firebase error codes
                if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    // Highlight the email field with an error message
                    self.displayErrorInEmailTextField("Email already exists")
                } else {
                    print("Error creating user: \(error.localizedDescription)")
                }
                return
            }

            // Update the user's profile with their name
            if let user = Auth.auth().currentUser {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Error updating user profile: \(error.localizedDescription)")
                    } else {
                        print("User profile updated successfully")
                    }
                }
            }

            // Successfully registered, navigate to the home screen
            self.showHomeScreen()
        }
    }

    private func displayErrorInEmailTextField(_ message: String) {
        emailTextField.text = ""
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: message,
            attributes: [
                .foregroundColor: UIColor.red,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        emailTextField.layer.borderColor = UIColor.red.cgColor
        emailTextField.layer.borderWidth = 1
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

    private func displayErrorInConfirmPasswordField(_ message: String) {
        confirmPasswordTextField.text = ""
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(
            string: message,
            attributes: [
                .foregroundColor: UIColor.red,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
        confirmPasswordTextField.layer.borderWidth = 1
    }

    private func setupTextFieldStyles() {
        let textFields = [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField]
        textFields.forEach { textField in
            textField?.layer.cornerRadius = 15
            textField?.backgroundColor = UIColor(named: "F7F8F9") ?? UIColor(red: 247/255, green: 248/255, blue: 249/255, alpha: 1.0)

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
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
