//
//  DDetailsCollectionViewCell.swift
//  OnboardingScreens
//
//  Created by admin100 on 21/12/24.
//

import UIKit

class DDetailsCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: DDetailsCollectionViewCell.self)
    
    @IBOutlet weak var DocImageView: UIImageView!
    @IBOutlet weak var DocNameLabel: UILabel!
    @IBOutlet weak var HosNameLabel: UILabel!
    @IBOutlet weak var DocSpecLabel: UILabel!
    
    func setup(doctor: Doctor){
        DocNameLabel.text = doctor.name
        DocSpecLabel.text = doctor.Spec
        HosNameLabel.text = doctor.hospitalName
        DocImageView.layer.cornerRadius = 20
        DocImageView.clipsToBounds = true // Ensure the image respects the corner radius
        if let imageURL = doctor.imageURL, let url = URL(string: imageURL) {
            loadImage(from: url) // Load image asynchronously
        } else {
            DocImageView.image = UIImage(named: doctor.imageName ?? "default") // Load local/default image
        }
    }
    private func loadImage(from url: URL) {
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.DocImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.DocImageView.image = UIImage(named: "default") // Fallback image
                }
            }
        }
    }
}
