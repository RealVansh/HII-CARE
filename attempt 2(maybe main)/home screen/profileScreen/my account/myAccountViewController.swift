import UIKit

class myAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userInfo = UserInfo.defaultUser

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bloodGroupButton: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var updateButton: UIButton!
    var isEditingMode = false
            
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            updateUI(with: userInfo)
            
            // Add tap gesture recognizer to the profile image
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
            profileImageView.isUserInteractionEnabled = true
            profileImageView.addGestureRecognizer(tapGesture)
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.clipsToBounds = true
            profileImageView.layer.cornerRadius = 50
            

            // Update the edit button title on load
            updateEditButtonTitle()
        }

        private func updateEditButtonTitle() {
            DispatchQueue.main.async {
                self.editButton.title = self.isEditingMode ? "Save" : "Edit"
            }
        }

        // Setup UI
        private func setupUI() {
            // Disable editing initially
            toggleEditingMode(enabled: false)
            
            // Style the profile image
            profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
            profileImageView.clipsToBounds = true
        }
            
        // Update UI with user data
        private func updateUI(with userInfo: UserInfo) {
            profileImageView.image = userInfo.profileImage
            nameTextField.text = userInfo.name
            ageTextField.text = "\(userInfo.age)"
            emailTextField.text = userInfo.email
            bloodGroupButton.setTitle(userInfo.bloodGroup, for: .normal)
        }

        private func toggleEditingMode(enabled: Bool) {
            nameTextField.isEnabled = enabled
            ageTextField.isEnabled = enabled
            emailTextField.isEnabled = enabled
            bloodGroupButton.isEnabled = enabled
            profileImageView.isUserInteractionEnabled = enabled  // Enable tapping on image
        }

        // Edit Button Action
        @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
            isEditingMode.toggle()
            updateEditButtonTitle()  // Force update the button title
            toggleEditingMode(enabled: isEditingMode)
            
            if !isEditingMode {
                // Save updated data to the model
                userInfo.name = nameTextField.text ?? userInfo.name
                userInfo.age = Int(ageTextField.text ?? "\(userInfo.age)") ?? userInfo.age
                userInfo.email = emailTextField.text ?? userInfo.email
                userInfo.bloodGroup = bloodGroupButton.title(for: .normal) ?? userInfo.bloodGroup
            }
        }

        @IBAction func bloodGroupButtonTapped(_ sender: UIButton) {
            let bloodGroups = ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"]
            let alert = UIAlertController(title: "Select Blood Group", message: nil, preferredStyle: .actionSheet)
            
            for bloodGroup in bloodGroups {
                alert.addAction(UIAlertAction(title: bloodGroup, style: .default, handler: { action in
                    self.bloodGroupButton.setTitle(action.title, for: .normal)
                }))
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }

        @objc func profileImageTapped() {
            guard isEditingMode else { return }  // Only allow changing image in edit mode

            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }

        // UIImagePickerController Delegate
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                profileImageView.image = selectedImage
                userInfo.profileImage = selectedImage
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
                
