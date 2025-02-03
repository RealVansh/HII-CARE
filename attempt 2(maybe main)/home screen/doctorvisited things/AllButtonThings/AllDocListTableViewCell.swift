//
//  AllDocListTableViewCell.swift
//  OnboardingScreens
//
//  Created by admin100 on 29/12/24.
//

import UIKit

class AllDocListTableViewCell: UITableViewCell {

    @IBOutlet weak var DocImgView: UIImageView!
    @IBOutlet weak var DocNameLabel: UILabel!
    @IBOutlet weak var DocSpecLabel: UILabel!
    static let identifier = "AllDocListTableViewCell"

    func setup(doctor: Doctor) {
        DocNameLabel.text = doctor.name
        DocSpecLabel.text = doctor.Spec
        DocImgView.layer.cornerRadius = 20
        DocImgView.clipsToBounds = true // Ensure the image respects the corner radius
            
        if let imageURL = doctor.imageURL, let url = URL(string: imageURL) {
            loadImage(from: url) // Load image asynchronously
        } else {
            DocImgView.image = UIImage(named: doctor.imageName ?? "default") // Load local/default image
        }
    }

        // Function to load image asynchronously
    private func loadImage(from url: URL) {
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.DocImgView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.DocImgView.image = UIImage(named: "default") // Fallback image
                }
            }
        }
    }
}
