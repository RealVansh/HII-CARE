import Foundation

// User Profile Data Model
struct UserProfile {
    let name: String
    let age: Int
    let bloodGroup: String
    let gender: String
    let conditions: [String]
}

// Data Source for the Profile
struct UserData {
    static let userProfile = UserProfile(
        name: "Vansh V",
        age: 19,
        bloodGroup: "O+",
        gender: "Male",
        conditions: ["Migraines", "Asthma", "Dust Allergy", "Ulcer"]
    )
}

