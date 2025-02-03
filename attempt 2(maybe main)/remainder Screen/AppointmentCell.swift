//
//  AppointmentCell.swift
//  ReminderTrial20wh
//
//  Created by user@25 on 16/12/24.
//

import UIKit

class AppointmentCell: UITableViewCell {

    // MARK: - UI Elements
    let appointmentLabel = UILabel()
    let dateLabel = UILabel()
    let deleteButton = UIButton(type: .system)
    var onDelete: (() -> Void)?
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    func setupUI() {
        appointmentLabel.font = UIFont.systemFont(ofSize: 16)
        appointmentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(appointmentLabel)
        
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        
        deleteButton.setTitle("🗑", for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            appointmentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            appointmentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            dateLabel.topAnchor.constraint(equalTo: appointmentLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Configure Cell
    func configure(with appointment: Appointment, onDelete: @escaping () -> Void) {
        appointmentLabel.text = appointment.name
        if let date = appointment.createdAt {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            dateLabel.text = formatter.string(from: date)
        }
        self.onDelete = onDelete
    }
    
    @objc func deleteTapped() {
        onDelete?()
    }
}

