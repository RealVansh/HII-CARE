//
//  Medicine+CoreDataProperties.swift
//  ReminderTrial20wh
//
//  Created by user@25 on 15/12/24.
//
//

import Foundation
import CoreData


extension Medicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine> {
        return NSFetchRequest<Medicine>(entityName: "Medicine")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var repeatChoice: String?
    @NSManaged public var frequencyChoice: String?
    @NSManaged public var foodChoice: String?

}

extension Medicine : Identifiable {

}
