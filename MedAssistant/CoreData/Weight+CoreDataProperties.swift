//
//  Weight+CoreDataProperties.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 09.04.2022.
//
//

import Foundation
import CoreData


extension Weight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weight> {
        return NSFetchRequest<Weight>(entityName: "Weight")
    }

    @NSManaged public var date: Date?
    @NSManaged public var value: Double
    @NSManaged public var id: UUID?

}

extension Weight : Identifiable {

}
