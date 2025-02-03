//
//  addMedDetailsViewController.swift
//  attempt 2(maybe main)
//
//  Created by admin100 on 01/02/25.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class addMedDetailsViewController: UIViewController {
    
    @IBOutlet weak var insurerNameTextField: UITextField!
    @IBOutlet weak var insurerCompanyButton: UIButton!
    @IBOutlet weak var moneytextField: UITextField!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonOnKeyboard()
        insurerCompanyButton.setTitle("Select Company Name", for: .normal)
        insurerNameTextField.layer.cornerRadius = 10
        moneytextField.layer.cornerRadius = 10
    }
    private func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
            
        toolbar.items = [flexSpace, doneButton]
            
        // Set the toolbar as the input accessory view for the diagnosis text field
        insurerNameTextField.inputAccessoryView = toolbar
        moneytextField.inputAccessoryView = toolbar
    }
        
    
    @objc private func doneButtonAction() {
        insurerNameTextField.resignFirstResponder()
        moneytextField.resignFirstResponder()
    }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        var hasError = false
        ref = Database.database().reference()
        // Validate doctor name
        if let insurerName = insurerNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !insurerName.isEmpty {
            insurerNameTextField.layer.borderColor = UIColor.clear.cgColor
            insurerNameTextField.layer.borderWidth = 0
        } else {
            hasError = true
            insurerNameTextField.layer.borderColor = UIColor.red.cgColor
            insurerNameTextField.layer.borderWidth = 1.5
        }

        // Validate hospital name
        if let money = moneytextField.text, !money.isEmpty {
            moneytextField.layer.borderColor = UIColor.clear.cgColor
            moneytextField.layer.borderWidth = 0
        } else {
            hasError = true
            moneytextField.layer.borderColor = UIColor.red.cgColor
            moneytextField.layer.borderWidth = 1.5
        }
                
        // Validate specialization
        if let companyName = insurerCompanyButton.title(for: .normal), !companyName.isEmpty, companyName != "Select Specialization" {
            insurerCompanyButton.layer.borderColor = UIColor.clear.cgColor
            insurerCompanyButton.layer.borderWidth = 0
        } else {
            hasError = true
            insurerCompanyButton.layer.borderColor = UIColor.red.cgColor
            insurerCompanyButton.layer.borderWidth = 1.5
        }
        // Show error alert if validation fails
        if hasError {
            showAlert(message: "Please fill in all required fields.")
            return
        }
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    @IBAction func cancelButton(_ sender: Any) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true) // Go back to the previous screen
        } else {
            self.dismiss(animated: true) // Dismiss if presented modally
        }
    }
}
