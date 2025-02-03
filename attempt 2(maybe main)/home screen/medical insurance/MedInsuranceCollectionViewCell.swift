//
//  MedInsuranceCollectionViewCell.swift
//  OnboardingScreens
//
//  Created by admin100 on 24/12/24.
//

import UIKit

class MedInsuranceCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: MedInsuranceCollectionViewCell.self)
    @IBOutlet weak var MedInsImageView: UIImageView!
    
    @IBOutlet weak var MedTitleLabel: UILabel!
    
    @IBOutlet weak var MedNameLabel: UILabel!
    
    @IBOutlet weak var MedAmountLabel: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Add corner radius
            self.contentView.layer.cornerRadius = 15 // Set the desired corner radius
            self.contentView.layer.masksToBounds = true
            
            // Optional: Add shadow (if needed)
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.1
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 4
            self.layer.masksToBounds = false
        }
        
        func setup(medicalInsurance: MedicalInsurance) {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .default)
            MedInsImageView.image = UIImage(systemName: "checkmark.seal.text.page.fill", withConfiguration: symbolConfig)
            MedInsImageView.tintColor = UIColor.systemBlue

            MedTitleLabel.text = medicalInsurance.insuranceCompanyName
            MedNameLabel.text = medicalInsurance.beneficiaryName
            MedAmountLabel.text = "Sum Assured: \(medicalInsurance.premium)"
        }
    }

