//
//  AddDoctorDetailsViewController.swift
//  attempt 2(maybe main)
//
//  Created by admin100 on 18/11/24.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddDoctorDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    @IBOutlet weak var doctorNameTextField: UITextField!
    @IBOutlet weak var specializationButton: UIButton!
    @IBOutlet weak var hospitalNameTextField: UITextField!
    @IBOutlet weak var doctorImage: UIButton!
    
    // MARK: - Properties
       private var selectedDoctorImage: UIImage?
       private let specialists = SpecialistModel.getSpecialists()
       private var ref: DatabaseReference!
       private var progressOverlay: UIView!
       private var progressLabel: UILabel!
       private var progressBar: UIProgressView!
       
       // MARK: - Lifecycle Methods
       override func viewDidLoad() {
           super.viewDidLoad()
           setupUI()
           ref = Database.database().reference()
       }
       
       // MARK: - UI Setup
       private func setupUI() {
           setupProgressOverlay()
           setupSpecializationMenu()
           setupTextFields()
           addDoneButtonOnKeyboard()
           
           // Initial UI configuration
           specializationButton.setTitle("Select Specialization", for: .normal)
           doctorNameTextField.layer.cornerRadius = 10
           hospitalNameTextField.layer.cornerRadius = 10
           doctorImage.layer.cornerRadius = 10
           
           // Add padding to text fields
           doctorNameTextField.setLeftPadding(10)
           hospitalNameTextField.setLeftPadding(10)
       }
       
       private func setupTextFields() {
           doctorNameTextField.delegate = self
           hospitalNameTextField.delegate = self
           
           // Add borders and padding
           [doctorNameTextField, hospitalNameTextField].forEach { textField in
               textField?.layer.borderWidth = 0.5
               textField?.layer.borderColor = UIColor.systemGray4.cgColor
               textField?.backgroundColor = .systemBackground
           }
       }
       
       private func setupSpecializationMenu() {
           var menuItems: [UIAction] = []
           
           for specialist in specialists {
               let action = UIAction(title: specialist) { [weak self] action in
                   self?.specializationButton.setTitle(specialist, for: .normal)
                   self?.specializationButton.layer.borderColor = UIColor.clear.cgColor
                   self?.specializationButton.layer.borderWidth = 0
               }
               menuItems.append(action)
           }
           
           specializationButton.menu = UIMenu(title: "Choose Specialization",
                                            options: .displayInline,
                                            children: menuItems)
           specializationButton.showsMenuAsPrimaryAction = true
           specializationButton.layer.cornerRadius = 10
           specializationButton.layer.borderWidth = 0.5
           specializationButton.layer.borderColor = UIColor.systemGray4.cgColor
           specializationButton.backgroundColor = .systemBackground
       }
       
       private func setupProgressOverlay() {
           // Create blur effect
           let blurEffect = UIBlurEffect(style: .systemMaterial)
           let blurEffectView = UIVisualEffectView(effect: blurEffect)
           blurEffectView.frame = view.bounds
           blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           
           // Setup overlay
           progressOverlay = UIView(frame: view.bounds)
           progressOverlay.addSubview(blurEffectView)
           
           // Content container
           let contentView = UIView()
           contentView.backgroundColor = .secondarySystemBackground
           contentView.layer.cornerRadius = 12
           contentView.translatesAutoresizingMaskIntoConstraints = false
           progressOverlay.addSubview(contentView)
           
           // Title label
           let titleLabel = UILabel()
           titleLabel.text = "Uploading in Progress"
           titleLabel.font = .preferredFont(forTextStyle: .headline)
           titleLabel.textColor = .label
           titleLabel.textAlignment = .center
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(titleLabel)
           
           // Progress bar
           progressBar = UIProgressView(progressViewStyle: .default)
           progressBar.progressTintColor = .systemBlue
           progressBar.trackTintColor = .systemGray5
           progressBar.layer.cornerRadius = 4
           progressBar.clipsToBounds = true
           progressBar.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(progressBar)
           
           // Progress label
           progressLabel = UILabel()
           progressLabel.text = "0%"
           progressLabel.font = .preferredFont(forTextStyle: .subheadline)
           progressLabel.textColor = .secondaryLabel
           progressLabel.textAlignment = .center
           progressLabel.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(progressLabel)
           
           // Layout constraints
           NSLayoutConstraint.activate([
               contentView.centerXAnchor.constraint(equalTo: progressOverlay.centerXAnchor),
               contentView.centerYAnchor.constraint(equalTo: progressOverlay.centerYAnchor),
               contentView.widthAnchor.constraint(equalToConstant: 250),
               contentView.heightAnchor.constraint(equalToConstant: 120),
               
               titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
               titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
               
               progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
               progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
               progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
               progressBar.heightAnchor.constraint(equalToConstant: 8),
               
               progressLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8),
               progressLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
               progressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
           ])
           
           progressOverlay.isHidden = true
           view.addSubview(progressOverlay)
       }
    
    @IBAction func doctorImageTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Doctor Image",
                                            message: "Select an image from the gallery or use the default image.",
                                            preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Select from Gallery", style: .default) { [weak self] _ in
                    self?.openGallery()
                })
                
                alert.addAction(UIAlertAction(title: "Use Default Image", style: .default) { [weak self] _ in
                    self?.selectedDoctorImage = UIImage(named: "Sample Doctor Photo")
                    self?.doctorImage.layer.borderColor = UIColor.clear.cgColor
                    self?.doctorImage.layer.borderWidth = 0
                })
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                // For iPad support
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = sender
                    popoverController.sourceRect = sender.bounds
                }
                
                present(alert, animated: true)
            }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        if !validateFields() {
                   return
               }
               
               // Disable the button to prevent multiple taps
               sender.isEnabled = false
               view.isUserInteractionEnabled = false // Disable all interaction
               
               uploadMedia { [weak self] url in
                   guard let self = self else { return }
                   
                   DispatchQueue.main.async {
                       sender.isEnabled = true
                       self.view.isUserInteractionEnabled = true // Re-enable interaction
                       
                       guard let url = url else {
                           self.showAlert(message: "Failed to upload image. Please try again.")
                           return
                       }
                       
                       let doctor: [String: Any] = [
                           "name": self.doctorNameTextField.text ?? "",
                           "specialization": self.specializationButton.title(for: .normal) ?? "",
                           "Hospital Name": self.hospitalNameTextField.text ?? "",
                           "imageURL": url,
                           "timestamp": ServerValue.timestamp()
                       ]
                       
                       self.ref.child("doctors").childByAutoId().setValue(doctor) { [weak self] error, _ in
                           guard let self = self else { return }
                           
                           DispatchQueue.main.async {
                               if let error = error {
                                   self.showAlert(message: "Failed to save data: \(error.localizedDescription)")
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
               }
           }
    @IBAction func cancelButton(_ sender: Any) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true) // Go back to the previous screen
        } else {
            self.dismiss(animated: true) // Dismiss if presented modally
        }
    }
    

// MARK: - Helper Methods
   private func validateFields() -> Bool {
       var isValid = true
       
       // Validate doctor name
       if let doctorName = doctorNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
          !doctorName.isEmpty {
           doctorNameTextField.layer.borderColor = UIColor.clear.cgColor
           doctorNameTextField.layer.borderWidth = 0
       } else {
           isValid = false
           doctorNameTextField.layer.borderColor = UIColor.red.cgColor
           doctorNameTextField.layer.borderWidth = 1.5
       }
       
       // Validate hospital name
       if let hospitalName = hospitalNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
          !hospitalName.isEmpty {
           hospitalNameTextField.layer.borderColor = UIColor.clear.cgColor
           hospitalNameTextField.layer.borderWidth = 0
       } else {
           isValid = false
           hospitalNameTextField.layer.borderColor = UIColor.red.cgColor
           hospitalNameTextField.layer.borderWidth = 1.5
       }
       
       // Validate specialization
       if let specialization = specializationButton.title(for: .normal),
          specialization != "Select Specialization" {
           specializationButton.layer.borderColor = UIColor.clear.cgColor
           specializationButton.layer.borderWidth = 0
       } else {
           isValid = false
           specializationButton.layer.borderColor = UIColor.red.cgColor
           specializationButton.layer.borderWidth = 1.5
       }
       
       // Validate doctor image
       if selectedDoctorImage == nil {
           isValid = false
           doctorImage.layer.borderColor = UIColor.red.cgColor
           doctorImage.layer.borderWidth = 1.5
       }
       
       if !isValid {
           showAlert(message: "Please fill in all required fields.")
       }
       
       return isValid
   }
   
   private func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
       guard let selectedImage = selectedDoctorImage else {
           completion(nil)
           return
       }
       
       DispatchQueue.main.async {
           self.showProgressOverlay()
       }
       
       let fileName = "image_\(UUID().uuidString).png"
       let storageRef = Storage.storage().reference().child(fileName)
       
       guard let uploadData = selectedImage.jpegData(compressionQuality: 0.8) else {
           completion(nil)
           return
       }
       
       let metadata = StorageMetadata()
       metadata.contentType = "image/jpeg"
       
       let uploadTask = storageRef.putData(uploadData, metadata: metadata) { [weak self] metadata, error in
           guard let self = self else { return }
           
           if let error = error {
               print("Error uploading image: \(error.localizedDescription)")
               DispatchQueue.main.async {
                   self.hideProgressOverlay()
               }
               completion(nil)
               return
           }
           
           storageRef.downloadURL { url, error in
               DispatchQueue.main.async {
                   self.hideProgressOverlay()
               }
               
               if let error = error {
                   print("Error getting download URL: \(error.localizedDescription)")
                   completion(nil)
                   return
               }
               
               completion(url?.absoluteString)
           }
       }
       
       uploadTask.observe(.progress) { [weak self] snapshot in
           guard let self = self else { return }
           let percentComplete = Double(snapshot.progress?.completedUnitCount ?? 0) /
                               Double(snapshot.progress?.totalUnitCount ?? 1) * 100
           
           DispatchQueue.main.async {
               self.updateProgressOverlay(percentage: percentComplete)
           }
       }
   }
   
   private func openGallery() {
       let imagePicker = UIImagePickerController()
       imagePicker.delegate = self
       imagePicker.sourceType = .photoLibrary
       present(imagePicker, animated: true)
   }
   
   private func showProgressOverlay() {
       progressOverlay.isHidden = false
   }
   
   private func hideProgressOverlay() {
       progressOverlay.isHidden = true
   }
   
   private func updateProgressOverlay(percentage: Double) {
       progressBar.setProgress(Float(percentage / 100), animated: true)
       progressLabel.text = String(format: "%.0f%%", percentage)
   }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                selectedDoctorImage = image
                
                // Update button appearance to show selection
                doctorImage.setTitle("Image Selected", for: .normal)
                doctorImage.backgroundColor = .systemGreen.withAlphaComponent(0.1)
                doctorImage.layer.borderColor = UIColor.systemGreen.cgColor
                doctorImage.layer.borderWidth = 1
                
                print("Image selected successfully!")
            }
            dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true)
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
       let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                      target: self,
                                      action: #selector(doneButtonAction))
       
       toolbar.items = [flexSpace, doneButton]
       
       doctorNameTextField.inputAccessoryView = toolbar
       hospitalNameTextField.inputAccessoryView = toolbar
   }
   
   @objc private func doneButtonAction() {
       view.endEditing(true)
   }
}

// MARK: - UITextFieldDelegate
extension AddDoctorDetailsViewController: UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       if textField == doctorNameTextField {
           hospitalNameTextField.becomeFirstResponder()
       } else {
           textField.resignFirstResponder()
       }
       return true
   }
}
extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
