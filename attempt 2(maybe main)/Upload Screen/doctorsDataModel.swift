import Foundation
import FirebaseDatabase
import FirebaseStorage

class DoctorModel {
    private static var ref: DatabaseReference! = Database.database().reference()
    
    private static var doctors: [String] = [
        "Dr. Sanjana",
        "Dr. Joseph",
        "Dr. Nikhil"
    ]
    static func fetchDoctors(completion: @escaping ([String]) -> Void) {
        ref.child("doctors").observeSingleEvent(of: .value) { snapshot in
            var fetchedDoctors = doctors
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let doctorDict = childSnapshot.value as? [String: Any], // Expecting dictionary
                   let doctorName = doctorDict["name"] as? String { // Extracting "name"
                    fetchedDoctors.append(doctorName)
                }
            }
            completion(fetchedDoctors)
        }
    }
        
    private static var diagnoses = [
        "Fever",
        "Cough",
        "Myopia",
        "Asthma",
        "Ulcer",
        "Skin Allergies",
        "Diabetes"
    ]
    
    static func addDiagnosis(diagnosis: String) {
        diagnoses.append(diagnosis)
        ref.child("diagnoses").childByAutoId().setValue(diagnosis)
    }
    
    static func getDiagnoses() -> [String] {
        return diagnoses
    }
    
    static func addDoctor(name: String, specialization: String, hospitalName: String, imageURL: String? = nil) {
        let doctorData: [String: Any] = [
            "name": name,
            "specialization": specialization,
            "hospitalName": hospitalName,
            "imageURL": imageURL ?? ""
        ]
        
        doctors.append(name)
        ref.child("doctors").childByAutoId().setValue(doctorData)
        NotificationCenter.default.post(name: NSNotification.Name("DoctorAdded"), object: nil)
    }
    
    static func getDoctors() -> [String] {
        return doctors
    }
}
struct SpecialistModel {
    static let specialists = [
        "Cardiology", "Endocrinology", "Gastroenterology", "Hematology", "Nephrology",
        "Oncology", "Pulmonology", "Rheumatology", "General", "Cardiothoracic Surgery",
        "Neurosurgery", "Orthopedic Surgery", "ENT", "Plastic Surgery", "Urology",
        "Vascular Surgery", "Anesthesiology", "Dermatology", "Genetics", "Neurology",
        "Obstetrics and Gynecology (OB-GYN)", "Ophthalmology", "Pathology", "Pediatrics", "Psychiatry"
    ]
    
    static func getSpecialists() -> [String] {
        return specialists
    }
}
