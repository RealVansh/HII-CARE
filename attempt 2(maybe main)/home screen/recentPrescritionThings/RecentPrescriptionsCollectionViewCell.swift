    //
    //  RecentPrescriptionsCollectionViewCell.swift
    //  OnboardingScreens
    //
    //  Created by admin100 on 20/12/24.
    //

import UIKit

class RecentPrescriptionsCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: RecentPrescriptionsCollectionViewCell.self)
        
    @IBOutlet weak var PrescritionImg: UIImageView!
    @IBOutlet weak var PresDate: UILabel!
    @IBOutlet weak var PresDoc: UILabel!
    @IBOutlet weak var PresTitle: UILabel!
    
    func setup(prescription: Prescription) {
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .default) // Customize size and weight
        PrescritionImg.image = UIImage(systemName: "waveform.path.ecg.text.page.fill", withConfiguration: symbolConfig)
        PrescritionImg.tintColor = UIColor.systemBlue

        PresTitle.text = prescription.reason
        PresDoc.text = prescription.doctorName
        PresDate.text = prescription.date
    }
}
