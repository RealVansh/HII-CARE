//
//  DoctorsDisplayCollectionViewCell.swift
//  OnboardingScreens
//
//  Created by admin100 on 20/12/24.
//

import UIKit

class DoctorsDisplayCollectionViewCell: UICollectionViewCell {
    static let identifier = "DoctorsDisplayCollectionViewCell"
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorSpecLabel: UILabel!
    func setup(doctor: Doctor) {
        doctorNameLabel.text = doctor.name
        doctorSpecLabel.text = doctor.Spec
        doctorImageView.clipsToBounds = true
        doctorImageView.layer.cornerRadius = 10
            
        if let imageURL = doctor.imageURL, let url = URL(string: imageURL) {
                // Load image from the internet
            loadImage(from: url)
        } else {
                // Load local image or default image
            doctorImageView.image = UIImage(named: doctor.imageName ?? "default")
        }
    }

    // Function to load image asynchronously
    private func loadImage(from url: URL) {
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.doctorImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.doctorImageView.image = UIImage(named: "default") // Fallback image
                }
            }
        }
    }
}
