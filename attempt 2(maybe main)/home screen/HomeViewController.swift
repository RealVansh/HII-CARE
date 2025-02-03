//
//  HomeViewController.swift
//  OnboardingScreens
//
//  Created by admin100 on 19/12/24.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController {

    @IBOutlet weak var DoctorVisitedCollectionView: UICollectionView!
    @IBOutlet weak var RecentPresCollectionView: UICollectionView!
    @IBOutlet weak var MedicalInsCollectionView: UICollectionView!
    @IBOutlet weak var Allbut: UIButton!

    var doctors: [Doctor] {
        return DiagnosisData.combinedDoctors
    }
    var recents: [Prescription] {
        return DiagnosisData.recentPrescriptions
    }
    var medical: [MedicalInsurance] {
        return DoctorDataModel().medical
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationTitle()
        registerCells()
        setupCollectionViews()
        fetchAllData()
    }
    
    private func setupCollectionViews() {
        MedicalInsCollectionView.dataSource = self
        MedicalInsCollectionView.delegate = self
        RecentPresCollectionView.dataSource = self
        RecentPresCollectionView.delegate = self
        DoctorVisitedCollectionView.dataSource = self
        DoctorVisitedCollectionView.delegate = self
    }
    
    private func fetchAllData() {
        // Show loading indicator if you have one
        let group = DispatchGroup()
        
        // Fetch prescriptions
        group.enter()
        DiagnosisData.fetchData { [weak self] success in
            defer { group.leave() }
            if !success {
                DispatchQueue.main.async {
                    self?.showAlert(message: "Failed to load prescriptions")
                }
            }
        }
        
        // Fetch doctors
        group.enter()
        DiagnosisData.fetchDoctors { [weak self] result in
            defer { group.leave() }
            switch result {
            case .success:
                break
            case .failure:
                DispatchQueue.main.async {
                    self?.showAlert(message: "Failed to load doctors")
                }
            }
        }
        
        // When all fetches complete
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.DoctorVisitedCollectionView.reloadData()
            self.RecentPresCollectionView.reloadData()
            print("Doctors count: \(self.doctors.count)")
            print("Recent prescriptions count: \(self.recents.count)")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error",
                                    message: message,
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupNavigationTitle() {
            // Fetch the current user's profile asynchronously
            Profile.fetchCurrentUser { [weak self] profile in
                guard let self = self else { return }

                // Create title label with custom styling
                let titleLabel = UILabel()
                if let profile = profile {
                    titleLabel.text = "HII-" + profile.name
                } else {
                    titleLabel.text = "HII-Guest"
                }
                titleLabel.font = .systemFont(ofSize: 28)
                titleLabel.textColor = UIColor(hexCode: "210EA4")
                titleLabel.textAlignment = .left
                titleLabel.adjustsFontSizeToFitWidth = true
                titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font!.pointSize)

                // Set the label as a left-aligned title
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
            }
        }

        private func registerCells() {
            DoctorVisitedCollectionView.register(UINib(nibName: DoctorsDisplayCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DoctorsDisplayCollectionViewCell.identifier)
            RecentPresCollectionView.register(UINib(nibName: RecentPrescriptionsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecentPrescriptionsCollectionViewCell.identifier)
            MedicalInsCollectionView.register(UINib(nibName: MedInsuranceCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MedInsuranceCollectionViewCell.identifier)
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showAllDoctorsSegue" {
                if let destinationVC = segue.destination as? AllDoctorsViewController {
                    destinationVC.doctor = doctors // Pass your array of doctors here
                }
            }
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RecentPresCollectionView.reloadData()
        fetchAllData() // Refresh data when view appears
    }


    @IBAction func allButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let allDoctorsVC = storyboard.instantiateViewController(withIdentifier: "AllDoctorsViewController") as? AllDoctorsViewController {
            allDoctorsVC.doctor = doctors // Pass the doctors list
//            navigationController?.pushViewController(allDoctorsVC, animated: true)
        }
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case DoctorVisitedCollectionView:
            return doctors.count
        case RecentPresCollectionView:
            return recents.count
        case MedicalInsCollectionView:
            return medical.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case DoctorVisitedCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoctorsDisplayCollectionViewCell.identifier, for: indexPath) as! DoctorsDisplayCollectionViewCell
            cell.setup(doctor: doctors[indexPath.row])
            return cell
        case RecentPresCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentPrescriptionsCollectionViewCell.identifier, for: indexPath) as! RecentPrescriptionsCollectionViewCell
            cell.setup(prescription: recents[indexPath.row])
            return cell
        case MedicalInsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MedInsuranceCollectionViewCell.identifier, for: indexPath) as! MedInsuranceCollectionViewCell
            cell.setup(medicalInsurance: medical[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == DoctorVisitedCollectionView {
            // Get the selected doctor
            let selectedDoctor = doctors[indexPath.row]
            
            // Navigate to the detail view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "DoctorDetailViewController") as? DoctorDetailViewController {
                detailVC.doctor = selectedDoctor
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
        else if collectionView == RecentPresCollectionView {
                // Navigate to the prescription display
                let controller = PresDisplayViewController.instantiate()
                controller.prescription = recents[indexPath.row] // Correctly assign the prescription
                navigationController?.pushViewController(controller, animated: true)
        }
    }
}
