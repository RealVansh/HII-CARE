//
//  DisplayViewController.swift
//  attempt 2(maybe main)
//
//  Created by admin100 on 30/10/24.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class DisplayViewController: UIViewController {
    
    @IBOutlet weak var DoctorButton: UIButton!
    @IBOutlet weak var diagnosisButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var UploadButton: UIView!
    @IBOutlet weak var DescTextField: UITextField!
    
    var ref: DatabaseReference! //Firebase Database reference
    var doctors: [String] = []
    var selectedImage: UIImage?
    var diagnosisList = DoctorModel.getDiagnoses()
    var isAddingNewDiagnosis = false // Track if the user is adding a new diagnosis
    var diagnosisTextField: UITextField? // Dynamically create a text field for adding a new diagnosis
    var progressOverlay: UIView!
    var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupProgressOverlay()
        setupNotificationObserver()
        loadDoctors()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDoctors), name: NSNotification.Name("DoctorAdded"), object: nil)
        ref = Database.database().reference()
    }
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadDoctors), name: NSNotification.Name("DoctorAdded"), object: nil)
    }
    @objc private func loadDoctors() {
        DoctorModel.fetchDoctors { [weak self] (fetchedDoctors: [String]) in
            DispatchQueue.main.async {
                self?.doctors = fetchedDoctors
                self?.getDoctors() // Update button menu
            }
        }
    }

    @objc func refreshDoctors() {
           // Refresh the doctor list
        doctors = DoctorModel.getDoctors()
        getDoctors() // Rebuild the menu for the DoctorButton
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("DoctorAdded"), object: nil)
    }
       
    fileprivate func setup() {
        doctors = DoctorModel.getDoctors()
        diagnosisButton.setTitle("Select Diagnosis", for: .normal)
        DoctorButton.setTitle("Select Doctor", for: .normal)
           
        addDoneButtonOnKeyboard()
        configureDiagnosisButton()
        getDoctors()
           
        // Set the current date as default
        datePicker.date = Date()
           
        DescTextField.layer.cornerRadius = 10
           
        UploadButton.layer.cornerRadius = 10
        UploadButton.layer.shadowColor = UIColor.black.cgColor
        UploadButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        UploadButton.layer.shadowOpacity = 0.3
        UploadButton.layer.shadowRadius = 4
    }
       
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("test")
        setup()
    }

    func getDoctors(){
        var menuItems: [UIAction] = []
                   
           // Create a menu item for each doctor in the list
        doctors.append("Add new Doctor")
        for doctor in doctors {
            let action = UIAction(title: doctor) { [weak self] action in
                // Update the button title to the selected doctor
                self?.DoctorButton.setTitle(doctor, for: .normal)
                print("Selected doctor: \(doctor)")
                if(doctor == "Add new Doctor"){
                    print("redirecting to add doctor")
                    if let advc = self?.storyboard?.instantiateViewController(withIdentifier: "add_doctor") {
                           self?.present(advc, animated: true)
                    }
                }
            }
            menuItems.append(action)
        }
           // Assign the menu to the DoctorButton
        DoctorButton.menu = UIMenu(title: "Choose Doctor", options: .displayInline, children: menuItems)
        DoctorButton.showsMenuAsPrimaryAction = true // Show menu immediately on tap
        DoctorButton.layer.cornerRadius = 10
    }
       
    private func configureDiagnosisButton() {
        var menuItems: [UIAction] = []
        // Add "Add new Diagnosis" only if it doesn't already exist in the list
        if !diagnosisList.contains("Add new Diagnosis") {
            diagnosisList.append("Add new Diagnosis")
        }
           // Add diagnoses to the menu
        for diagnosis in diagnosisList {
            let action = UIAction(title: diagnosis) { [weak self] action in
                self?.handleDiagnosisSelection(diagnosis)
            }
            menuItems.append(action)
        }
           
           // Assign the menu to the DiagnosisButton
        diagnosisButton.menu = UIMenu(title: "Choose Diagnosis", options: .displayInline, children: menuItems)
        diagnosisButton.showsMenuAsPrimaryAction = true // Show menu immediately on tap
           diagnosisButton.layer.cornerRadius = 10
    }

           
    private func handleDiagnosisSelection(_ diagnosis: String) {
        if diagnosis == "Add new Diagnosis" {
        // Convert the button into a text field for new diagnosis entry
            isAddingNewDiagnosis = true
               addDiagnosisTextField()
        } else {
               // Set the button title to the selected diagnosis
            diagnosisButton.setTitle(diagnosis, for: .normal)
            isAddingNewDiagnosis = false
            removeDiagnosisTextField()
        }
    }
           
    private func addDiagnosisTextField() {
        // Ensure we don't add the text field multiple times
        guard diagnosisTextField == nil else { return }

        // Create the new diagnosis text field
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        textField.placeholder = "Enter new diagnosis"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.cornerRadius = 10

           // Add a Done button to dismiss the keyboard
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexSpace, doneButton]
           textField.inputAccessoryView = toolbar

        diagnosisTextField = textField

           // Add the text field to the diagnosis stack view
        if let diagnosisStackView = diagnosisButton.superview as? UIStackView {
               diagnosisStackView.addArrangedSubview(textField) // Add it below the button
        }
        // Hide the diagnosis button to prevent duplication
        diagnosisButton.isHidden = true
    }
    
    private func removeDiagnosisTextField() {
           // Remove the text field and bring back the button
        diagnosisTextField?.removeFromSuperview()
        diagnosisTextField = nil
        diagnosisButton.isHidden = false
    }
    
    var progressBar: UIProgressView!
    private func setupProgressOverlay() {
        // Create a blurred background
        let blurEffect = UIBlurEffect(style: .systemMaterial) // Apple’s default alert background style
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Create the overlay container
        progressOverlay = UIView(frame: self.view.bounds)
        progressOverlay.addSubview(blurEffectView)
        
        // Add a vibrant content view (similar to alerts)
        let contentView = UIView()
        contentView.backgroundColor = UIColor.secondarySystemBackground // Matches the alert card
        contentView.layer.cornerRadius = 12
        contentView.translatesAutoresizingMaskIntoConstraints = false
        progressOverlay.addSubview(contentView)
        
        // Add a label for the progress title
        let titleLabel = UILabel()
        titleLabel.text = "Uploading in Progress"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline) // Use dynamic text style
        titleLabel.textColor = UIColor.label // Adaptable for light/dark mode
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Add a progress bar
        progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progressTintColor = UIColor.systemBlue // Default Apple blue
        progressBar.trackTintColor = UIColor.systemGray5 // Subtle track color
        progressBar.layer.cornerRadius = 4
        progressBar.clipsToBounds = true
        progressBar.setProgress(0.0, animated: false)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(progressBar)
        
        // Add a label for the progress percentage
        progressLabel = UILabel()
        progressLabel.text = "0%"
        progressLabel.font = UIFont.preferredFont(forTextStyle: .subheadline) // Use dynamic text style
        progressLabel.textColor = UIColor.secondaryLabel // Adaptable for light/dark mode
        progressLabel.textAlignment = .center
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(progressLabel)
        
        // Layout constraints for the content view
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: progressOverlay.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: progressOverlay.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 250),
            contentView.heightAnchor.constraint(equalToConstant: 120),
            
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Progress bar constraints
            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 8),
            
            // Progress label constraints
            progressLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8),
            progressLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        // Initially hide the overlay
        progressOverlay.isHidden = true
        self.view.addSubview(progressOverlay)
    }

        private func showProgressOverlay() {
            progressOverlay.isHidden = false
        }
        
        private func hideProgressOverlay() {
            progressOverlay.isHidden = true
        }

        // Update the percentage in the progress overlay
    private func updateProgressOverlay(percentage: Double) {
        progressBar.setProgress(Float(percentage / 100), animated: true)
        progressLabel.text = String(format: "%.0f%%", percentage)
    }


    func uploadPicture(completion: @escaping (_ url: String?) -> Void) {
            guard let selectedImage = selectedImage else {
                completion(nil)
                return
            }
            let fileName = "image_\(UUID().uuidString).png"
            let storageRef = Storage.storage().reference().child(fileName)
            if let uploadData = selectedImage.jpegData(compressionQuality: 0.8) {
                let uploadTask = storageRef.putData(uploadData, metadata: nil) { (_, error) in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                        completion(nil)
                    } else {
                        storageRef.downloadURL { url, _ in
                            completion(url?.absoluteString)
                        }
                    }
                }
                
                // Show the progress overlay
                showProgressOverlay()
                
                uploadTask.observe(.progress) { snapshot in
                    guard let progress = snapshot.progress else { return }
                    let percentComplete = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                    DispatchQueue.main.async {
                        self.updateProgressOverlay(percentage: percentComplete * 100)
                    }
                }

                uploadTask.observe(.success) { _ in
                    DispatchQueue.main.async {
                        self.hideProgressOverlay()
                    }
                }
                        
                uploadTask.observe(.failure) { _ in
                    DispatchQueue.main.async {
                        self.hideProgressOverlay()
                        self.showAlert(message: "Failed to upload image. Please try again.")
                    }
                }
            } else {
                completion(nil)
            }
        }

    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        var hasError = false
        ref = Database.database().reference()
        
        // Validate diagnosis
        let diagnosisText = isAddingNewDiagnosis ? diagnosisTextField?.text : diagnosisButton.title(for: .normal)
        if let diagnosis = diagnosisText, !diagnosis.isEmpty, diagnosis != "Select Diagnosis" {
            diagnosisButton.layer.borderColor = UIColor.clear.cgColor
            diagnosisButton.layer.borderWidth = 0
            diagnosisTextField?.layer.borderColor = UIColor.clear.cgColor
            diagnosisTextField?.layer.borderWidth = 0
        } else {
            hasError = true
            if isAddingNewDiagnosis {
                diagnosisTextField?.layer.borderColor = UIColor.red.cgColor
                diagnosisTextField?.layer.borderWidth = 1.5
            } else {
                diagnosisButton.layer.borderColor = UIColor.red.cgColor
                diagnosisButton.layer.borderWidth = 1.5
            }
        }
        
        // Validate doctor
        if let selectedDoctor = DoctorButton.title(for: .normal), selectedDoctor != "Select Doctor" {
            DoctorButton.layer.borderColor = UIColor.clear.cgColor
            DoctorButton.layer.borderWidth = 0
        } else {
            hasError = true
            DoctorButton.layer.borderColor = UIColor.red.cgColor
            DoctorButton.layer.borderWidth = 1.5
        }
        
        // Validate description
        if let description = DescTextField.text, !description.isEmpty {
            DescTextField.layer.borderColor = UIColor.clear.cgColor
            DescTextField.layer.borderWidth = 0
        } else {
            hasError = true
            DescTextField.layer.borderColor = UIColor.red.cgColor
            DescTextField.layer.borderWidth = 1.5
        }
        
        // Show error alert if validation fails
        if hasError {
            showAlert(message: "Please fill in all required fields.")
            return
        }
        
        uploadPicture() { url in
                guard let url = url else {
                    print("Image upload failed.")
                    self.showAlert(message: "Failed to upload image. Please try again.")
                    return
                }
                print("Image uploaded, URL: \(url)")

                // Save to Database
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let formattedDate = dateFormatter.string(from: self.datePicker.date)
                let item: [String: Any] = [
                    "Doctor Name": self.DoctorButton.title(for: .normal) ?? "",
                    "Diagnosis": diagnosisText ?? "",
                    "Date": formattedDate,
                    "Description": self.DescTextField.text ?? "",
                    "Image URL": url
                ]
                self.ref.child("items").childByAutoId().setValue(item) { error, _ in
                    if let error = error {
                        print("Error saving to database: \(error.localizedDescription)")
                        self.showAlert(message: "Failed to save data. Please try again.")
                    } else {
                        print("Successfully saved to database!")
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Success", message: "Upload completed!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    private func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexSpace, doneButton]
        
        DescTextField.inputAccessoryView = toolbar
    }

    @objc private func doneButtonTapped() {
        view.endEditing(true) // Dismiss the keyboard
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true) // Go back to the previous screen
        } else {
            self.dismiss(animated: true) // Dismiss if presented modally
        }
    }
}
