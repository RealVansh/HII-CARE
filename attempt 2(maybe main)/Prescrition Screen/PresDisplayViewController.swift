//
//  PresDisplayViewController.swift
//  OnboardingScreens
//
//  Created by admin100 on 23/12/24.
//

import UIKit

class PresDisplayViewController: UIViewController {
    var prescription: Prescription!
    
    @IBOutlet weak var PrescriptionImage: UIImageView!
    @IBOutlet weak var DesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateView()
    }
    
    private func populateView() {
        guard let prescription = prescription else { return }
        
        // Set the prescription image
        if let localImage = prescription.prescriptionFileName {
            // Use local image if available
            PrescriptionImage.image = localImage
        } else if let urlString = prescription.imageURL,
                  let url = URL(string: urlString) {
            // Load image from Firebase URL
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.PrescriptionImage.image = image
                    }
                }
            }.resume()
        } else {
            // Set default image if neither source is available
            PrescriptionImage.image = UIImage(named: "default")
        }
        
        DesLabel.text = prescription.description
        print("Prescription Data: \(prescription)")
    }
    
    @IBAction func shareButton(_ sender: Any) {
        guard let image = PrescriptionImage.image else {
            print("No image available to share")
            return
        }
        
        // Create a temporary file path to store the image
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("prescription.jpg")
            
            do {
                try imageData.write(to: tempURL)
            } catch {
                print("Error saving temporary image: \(error)")
                return
            }
            
            // Create a UIActivityViewController for sharing the file (not the UIImage)
            let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            
            // Present the share sheet
            present(activityVC, animated: true)
        }
    }
}
