//
//  Doctor.swift
//  OnboardingScreens
//
//  Created by admin100 on 20/12/24.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

struct Doctor{
    let name: String
    let Spec: String
    let imageName: String?
    let imageURL: String?     // For Firebase data
    let hospitalName: String
}
struct Prescription {
    let doctorName: String
    let date: String
    let reason: String
    let description: String
    let prescriptionFileName: UIImage? // Placeholder for local images
    let imageURL: String? // For dynamic Firebase data
    
}
struct Diagnosis {
    let name: String                   // Diagnosis name
    let prescriptions: [Prescription] // List of prescriptions related to this diagnosis
}
struct MedicalInsurance{
    let insuranceCompanyName: String
    let beneficiaryName: String
//    let policyNumber: String
    let premium: String
    
}
struct DiagnosisData {
    static let allDiagnoses: [Diagnosis] = [
        Diagnosis(
            name: "Fever",
            prescriptions: [
                Prescription(
                    doctorName: "Dr. Joseph",
                    date: "01-11-2024",
                    reason: "Fever",
                    description: "Regular fever prescription for flu.",
                    prescriptionFileName: UIImage(named: "default"),
                    imageURL: nil
                    
                ),
                Prescription(
                    doctorName: "Dr. Joseph",
                    date: "10-11-2024",
                    reason: "Fever",
                    description: "Follow-up prescription for recurring fever symptoms.",
                    prescriptionFileName: UIImage(named: "default"),
                    imageURL: nil
                    
                )
            ]
        ),
        Diagnosis(
            name: "Asthma",
            prescriptions: [
                Prescription(
                    doctorName: "Dr. Sanjana",
                    date: "01-11-2024",
                    reason: "Asthma",
                    description: "Asthma maintenance prescription.",
                    prescriptionFileName: UIImage(named: "default"),
                    imageURL: nil
                ),
                Prescription(
                    doctorName: "Dr. Sanjana",
                    date: "10-11-2024",
                    reason: "Asthma",
                    description: "Emergency prescription for asthma attack.",
                    prescriptionFileName: UIImage(named: "default"),
                    imageURL: nil
                )
            ]
        ),
        Diagnosis(
            name: "Skin Allergies",
            prescriptions: [
                Prescription(
                    doctorName: "Dr. Adams",
                    date: "10-11-2024",
                    reason: "Skin Allergies",
                    description: "Prescription for rashes and irritation caused by skin allergy.",
                    prescriptionFileName: UIImage(named: "default"),
                    imageURL: nil
                )
            ]
        ),
        Diagnosis(
            name: "Myopia",
            prescriptions: [
                Prescription(
                    doctorName: "Dr. Shubham",
                    date: "01-11-2024",
                    reason: "Myopia",
                    description: "Prescription for corrective lenses for Myopia.",
                    prescriptionFileName: UIImage(named: "default"),
                    imageURL: nil
                )
            ]
        ),
        Diagnosis(
            name: "Ulcer",
            prescriptions: [
                Prescription(
                    doctorName: "Dr. Sanjana",
                    date: "10-11-2024",
                    reason: "Ulcer",
                    description: "Prescription for stomach ulcer medication.",
                    prescriptionFileName: UIImage(named: "default"),
                    imageURL: nil
                )
            ]
        )
        
    ]
    static let doctors: [Doctor] = [
            .init(name: "Dr. Joseph", Spec: "General", imageName: "dr 1",imageURL: nil, hospitalName: "City Hospital"),
            .init(name: "Dr. Sanjana", Spec: "ENT", imageName: "dr 2", imageURL: nil, hospitalName: "Community Care Clinic"),
            .init(name: "Dr. Shubham", Spec: "General", imageName: "dr 3",imageURL: nil, hospitalName: "Health & Wellness Center")
    ]
    
    static var dynamicDoctors: [Doctor] = []
    static var dynamicDiagnoses: [Diagnosis] = []
    static var recentPrescriptions: [Prescription] = []
    
    // Add a computed property that combines both static and dynamic diagnoses
    static var combinedDiagnoses: [Diagnosis] {
        return allDiagnoses + dynamicDiagnoses
    }
    static var combinedDoctors: [Doctor] {
        return doctors + dynamicDoctors
    }

    static func fetchData(completion: @escaping (Bool) -> Void) {
            let ref = Database.database().reference().child("items")

            ref.observeSingleEvent(of: .value) { snapshot in
                var diagnosesDict: [String: [Prescription]] = [:]

                for child in snapshot.children {
                    if let snap = child as? DataSnapshot,
                       let data = snap.value as? [String: Any],
                       let date = data["Date"] as? String,
                       let description = data["Description"] as? String,
                       let diagnosis = data["Diagnosis"] as? String,
                       let doctorName = data["Doctor Name"] as? String,
                       let imageURL = data["Image URL"] as? String {
                        
                        print("Found diagnosis: \(diagnosis)") // Add this debug print
                        
                        let prescription = Prescription(
                            doctorName: doctorName,
                            date: date,
                            reason: diagnosis,
                            description: description,
                            prescriptionFileName: nil,
                            imageURL: imageURL
                        )

                        if var existingPrescriptions = diagnosesDict[diagnosis] {
                            existingPrescriptions.append(prescription)
                            diagnosesDict[diagnosis] = existingPrescriptions
                        } else {
                            diagnosesDict[diagnosis] = [prescription]
                        }
                    }
                }

                // Transform dictionary into Diagnosis array
                dynamicDiagnoses = diagnosesDict.map { Diagnosis(name: $0.key, prescriptions: $0.value) }
                
                print("Dynamic diagnoses count: \(dynamicDiagnoses.count)") // Debug print
                
                // Update recent prescriptions from combined sources
                recentPrescriptions = combinedDiagnoses
                    .flatMap { $0.prescriptions }
                    .sorted(by: { $0.date > $1.date })
                    .prefix(5)
                    .map { $0 }

                completion(true)
            } withCancel: { error in
                print("Error fetching data: \(error.localizedDescription)")
                completion(false)
            }
        }
    static func fetchDoctors(completion: @escaping (Result<[Doctor], Error>) -> Void) {
            let ref = Database.database().reference().child("doctors")
            
            ref.observeSingleEvent(of: .value) { snapshot in
                var fetchedDoctors: [Doctor] = []
                
                for child in snapshot.children {
                    if let snap = child as? DataSnapshot,
                       let data = snap.value as? [String: Any],
                       let name = data["name"] as? String,
                       let specialization = data["specialization"] as? String,
                       let hospitalName = data["Hospital Name"] as? String {
                        
                        let doctor = Doctor(
                            name: name,
                            Spec: specialization,
                            imageName: "default",  // Use a default image name for Firebase doctors
                            imageURL: data["imageURL"] as? String,
                            hospitalName: hospitalName
                        )
                        
                        fetchedDoctors.append(doctor)
                    }
                }
                
                dynamicDoctors = fetchedDoctors
                print("Fetched \(fetchedDoctors.count) doctors from Firebase")
                completion(.success(fetchedDoctors))
                
            } withCancel: { error in
                print("Error fetching doctors: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    
struct DoctorDataModel {
    var medical: [MedicalInsurance] = [
        .init(insuranceCompanyName: "Star Health Insurance", beneficiaryName: "Vansh V", premium: "3000000"),
        .init(insuranceCompanyName: "Max Health Insurance", beneficiaryName: "Roshini Sridharan", premium: "1000000")
    ]
}
