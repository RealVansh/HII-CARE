//
//  ViewController.swift
//  attempt 2(maybe main)
//
//  Created by admin100 on 29/10/24.
//

import UIKit
import Photos
class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIDocumentPickerDelegate {
    var selectedImage: UIImage?
    var imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var CameraButton: UIButton!
    @IBOutlet weak var DocumentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkkPermission()
        imagePickerController.delegate = self
    }
    
    @IBAction func TappedCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func TappedLibraryButton(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Select Source", message: "Choose an option to select your image or file", preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let documents = UIAlertAction(title: "Documents", style: .default) { (action) in
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.image, .pdf], asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            self.present(documentPicker, animated: true)
        }
        actionSheet.addAction(gallery)
        actionSheet.addAction(documents)
        actionSheet.popoverPresentationController?.sourceView = sender
        present(actionSheet, animated: true, completion: nil)
    }
    
    func checkkPermission(){
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization({ status in })
        }
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            print("Access granted")
        }
        else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if status == .authorized {
            print("Access granted")
        } else {
            print("Access denied")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage // Store the selected image if needed in DisplayViewController
        }
        picker.dismiss(animated: true) {
            print("Transitioning to infoViewController") // Debug line to confirm transition
            self.performSegue(withIdentifier: "Document", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Document" {
            if let destinationVC = segue.destination as? DisplayViewController {
                // Pass any data if necessary
                destinationVC.selectedImage = selectedImage // Example if DisplayViewController has a selectedImage property
            }
        }
    }
}
