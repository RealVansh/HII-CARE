//
//  DoctorDetailsViewController.swift
//  OnboardingScreens
//
//  Created by admin100 on 21/12/24.
//

import UIKit
import Firebase
import FirebaseDatabase

class DoctorDetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var prescriptionsTableView: UITableView!
        
        var doctor: Doctor?
        var prescriptions: [Prescription] = []

    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set delegates and data sources
            collectionView.delegate = self
            collectionView.dataSource = self

            prescriptionsTableView.delegate = self
            prescriptionsTableView.dataSource = self
            
            // Register the custom collection view cell for doctor details
            collectionView.register(UINib(nibName: DDetailsCollectionViewCell.identifier, bundle: nil),forCellWithReuseIdentifier: DDetailsCollectionViewCell.identifier)
            
            // Register a UITableViewCell for prescriptions
            prescriptionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PrescriptionCell")
            
            // Filter prescriptions for the selected doctor
            if let selectedDoctor = doctor {
                prescriptions = DiagnosisData.combinedDiagnoses
                    .flatMap { $0.prescriptions }
                    .filter { $0.doctorName.caseInsensitiveCompare(selectedDoctor.name) == .orderedSame }
                print("Prescriptions for \(selectedDoctor.name): \(prescriptions)")
            }

            prescriptionsTableView.reloadData()

        }
    }

    // MARK: - CollectionView Delegate & DataSource
    extension DoctorDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1 // Only one cell for doctor details
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DDetailsCollectionViewCell.identifier, for: indexPath) as? DDetailsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if let doctor = doctor {
                cell.setup(doctor: doctor)
            }
            return cell
        }
    }

    // MARK: - TableView Delegate & DataSource
    extension DoctorDetailViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return prescriptions.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionCell") else {
                return UITableViewCell(style: .subtitle, reuseIdentifier: "PrescriptionCell")
            }
            
            let prescription = prescriptions[indexPath.row]
            
            // Configure paragraph style for line spacing
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            
            // Create attributed text
            let attributedText = NSMutableAttributedString(
                string: "\(prescription.date)\n",
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 16), // Bold font for the date
                    .paragraphStyle: paragraphStyle
                ]
            )
            attributedText.append(NSAttributedString(
                string: prescription.description,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14), // Regular font for the description
                    .paragraphStyle: paragraphStyle
                ]
            ))
            
            
            // Assign the attributed text to the textLabel
            cell.textLabel?.attributedText = attributedText
            cell.textLabel?.numberOfLines = 0 // Allow multiline text
            
            // Optional: Add accessory type
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedPrescription = prescriptions[indexPath.row]
            
            // Navigate to PresDisplayViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let presDisplayVC = storyboard.instantiateViewController(withIdentifier: "PresDisplayViewController") as? PresDisplayViewController {
                presDisplayVC.prescription = selectedPrescription // Pass the selected prescription
                navigationController?.pushViewController(presDisplayVC, animated: true)
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
