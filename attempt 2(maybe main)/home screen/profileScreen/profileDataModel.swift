
//  profileDataModel.swift
//  OnboardingScreens
//
//  Created by admin100 on 01/01/25.
//
import Foundation
import FirebaseAuth

struct Profile {
    let name: String
    let email: String
    let imageName: String
    // Static function to fetch the current user's profile dynamically
    static func fetchCurrentUser(completion: @escaping (Profile?) -> Void) {
        if let user = Auth.auth().currentUser {
            let profile = Profile(
                    name: user.displayName ?? "Unknown User", // Use Firebase's displayName or default
                    email: user.email ?? "No Email",         // Use Firebase's email or default
                    imageName: "Photo"                      // Placeholder for image
            )
            completion(profile)
        } else {
            completion(nil) // No user signed in
        }
    }
}
struct ProfileOption {
    let symbolImageName: String
    let name: String
    
    static let options: [ProfileOption] = [
        ProfileOption(symbolImageName: "person.text.rectangle.fill", name: "My Account"),
//        ProfileOption(symbolImageName: "person.2.fill", name: "Family Members"),
        ProfileOption(symbolImageName: "gearshape.fill", name: "Settings"),
        ProfileOption(symbolImageName: "phone.fill", name: "Contact")
    ]
}
