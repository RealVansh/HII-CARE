//
//  PrescriptionListViewController.swift
//  PrescriptionScreen
//
//  Created by admin100 on 16/11/24.
//

import UIKit

class PrescriptionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var diagnosis: Diagnosis?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
            
            // Set title using navigationItem
        if let diagnosisName = diagnosis?.name {
            navigationItem.title = diagnosisName
        }
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diagnosis?.prescriptions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacerView = UIView()
        spacerView.backgroundColor = UIColor.clear
        return spacerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionCell", for: indexPath)
    
            // Reset masks and corners
            cell.layer.cornerRadius = 0
            cell.layer.maskedCorners = []

            let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)

            if numberOfRows == 1 {
                // Single cell: Round all corners
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else if indexPath.row == 0 {
                // First cell in section: Round top corners
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == numberOfRows - 1 {
                // Last cell in section: Round bottom corners
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }

        // Clear overlapping subviews caused by reuse
            cell.contentView.subviews.forEach { subview in
                if subview.tag == 100 || subview.tag == 101 { // Ensure tags match (100 for initials, 101 for blur)
                    subview.removeFromSuperview()
                }
            }

            if let prescription = diagnosis?.prescriptions[indexPath.row] {
            // Set doctor's name
                cell.textLabel?.text = prescription.doctorName
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)

                // Set date
                cell.detailTextLabel?.text = prescription.date
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
                cell.detailTextLabel?.textColor = .gray

                // Create and configure initials label
                let initialsLabel = UILabel()
                initialsLabel.tag = 100
                initialsLabel.translatesAutoresizingMaskIntoConstraints = false
                initialsLabel.textColor = UIColor.systemBlue
                initialsLabel.textAlignment = .center
                initialsLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                initialsLabel.layer.cornerRadius = 20
                initialsLabel.layer.masksToBounds = true

                // Extract initials
                if let nameComponents = prescription.doctorName.split(separator: " ").last {
                    initialsLabel.text = String(nameComponents.prefix(1)).uppercased()
                } else {
                    initialsLabel.text = "?"
                }

                // Create a blur effect for the initials background
                let blurEffect = UIBlurEffect(style: .light) // Use .light for a softer effect
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.translatesAutoresizingMaskIntoConstraints = false
                blurEffectView.layer.cornerRadius = 20
                blurEffectView.layer.masksToBounds = true
                blurEffectView.tag = 101

                // Add a semi-transparent overlay with systemPurple color
                let overlayView = UIView()
                overlayView.translatesAutoresizingMaskIntoConstraints = false
                overlayView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1) // 60% opacity
                overlayView.layer.cornerRadius = 20
                overlayView.layer.masksToBounds = true
                blurEffectView.contentView.addSubview(overlayView)

                // Add initialsLabel on top of the overlay
                overlayView.addSubview(initialsLabel)

                // Add blurEffectView to the cell
                cell.contentView.addSubview(blurEffectView)

                // Add constraints for blurEffectView
                NSLayoutConstraint.activate([
                    blurEffectView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    blurEffectView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                    blurEffectView.widthAnchor.constraint(equalToConstant: 40),
                    blurEffectView.heightAnchor.constraint(equalToConstant: 40)
                ])

                // Add constraints for overlayView
                NSLayoutConstraint.activate([
                    overlayView.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor),
                    overlayView.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor),
                    overlayView.topAnchor.constraint(equalTo: blurEffectView.topAnchor),
                    overlayView.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor)
                ])

                // Add constraints for initialsLabel
                NSLayoutConstraint.activate([
                    initialsLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
                    initialsLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
                    initialsLabel.topAnchor.constraint(equalTo: overlayView.topAnchor),
                    initialsLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor)
                ])

                // Adjust textLabel and detailTextLabel positions
                cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
                cell.detailTextLabel?.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    cell.textLabel!.leadingAnchor.constraint(equalTo: blurEffectView.trailingAnchor, constant: 16),
                    cell.textLabel!.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    cell.detailTextLabel!.leadingAnchor.constraint(equalTo: blurEffectView.trailingAnchor, constant: 16),
                    cell.detailTextLabel!.topAnchor.constraint(equalTo: cell.textLabel!.bottomAnchor, constant: 4)
                ])
            }

            return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showPrescriptionDetail",
               let detailVC = segue.destination as? PresDisplayViewController,
               let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Pass the selected prescription
                detailVC.prescription = diagnosis?.prescriptions[selectedIndexPath.row]
            }
    }
}
