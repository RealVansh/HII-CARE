//
//  Appointment+CoreDataProperties.swift
//  ReminderTrial20wh
//
//  Created by user@25 on 16/12/24.
//
//

import Foundation
import CoreData


extension Appointment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Appointment> {
        return NSFetchRequest<Appointment>(entityName: "Appointment")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var details: String?
    @NSManaged public var name: String?
    @NSManaged public var doctorName: String?
    @NSManaged public var hospitalName: String?
    @NSManaged public var time: Date?

}

extension Appointment : Identifiable {

}
