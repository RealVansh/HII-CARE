//
//  MedicationCell.swift
//  ReminderTrial20wh
//
//  Created by user@25 on 16/12/24.
//

import UIKit

class MedicationCell: UITableViewCell {
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let medicineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pills.fill")
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private let frequencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubview(cardView)
        cardView.addSubview(medicineImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(timeLabel)
        cardView.addSubview(frequencyLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.frame = CGRect(x: 0, y: 10, width: contentView.frame.width, height: 80)
        medicineImageView.frame = CGRect(x: 10, y: 20, width: 40, height: 40)
        nameLabel.frame = CGRect(x: 60, y: 15, width: cardView.frame.width - 70, height: 20)
        timeLabel.frame = CGRect(x: 60, y: 40, width: cardView.frame.width - 70, height: 20)
        frequencyLabel.frame = CGRect(x: 60, y: 60, width: cardView.frame.width - 70, height: 20)
    }
    
    
    func configure(with medicine: Medicine) {
        nameLabel.text = medicine.name
        timeLabel.text = "9:30 AM" // Replace with your actual time logic
        frequencyLabel.text = "Everyday" // Add frequency logic if applicable
        if let date = medicine.createdAt {
               let formatter = DateFormatter()
               formatter.dateStyle = .medium
               formatter.timeStyle = .short
               dateLabel.text = formatter.string(from: date)
           } else {
               dateLabel.text = "No Date"
           }
       
        
    }
    
}
