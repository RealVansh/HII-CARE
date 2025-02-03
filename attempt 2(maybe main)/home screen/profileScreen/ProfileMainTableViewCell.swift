//
//  ProfileMainTableViewCell.swift
//  OnboardingScreens
//
//  Created by admin100 on 29/12/24.
//

import UIKit

class ProfileMainTableViewCell: UITableViewCell {

    @IBOutlet weak var viewForSymbol: UIView!
    @IBOutlet weak var symbolImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
