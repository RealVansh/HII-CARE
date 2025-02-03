//
//  userInfoDataModel.swift
//  attempt 2(maybe main)
//
//  Created by admin100 on 02/01/25.
//

import UIKit
import Foundation
struct UserInfo {
    var name: String
    var age: Int
    var email: String
//    var contactNumber: String
    var bloodGroup: String
    var profileImage: UIImage
    
    // Default user information
    static var defaultUser: UserInfo {
        return UserInfo(
            name: "Vansh V",
            age: 19,
            email: "itsmeactorvansh@gmail.com",
//            contactNumber: "7010526173",
            bloodGroup: "O+",
            profileImage: UIImage(named: "Photo")!
        )
    }
}
