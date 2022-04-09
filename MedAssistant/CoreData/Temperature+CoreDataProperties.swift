//
//  Temperature+CoreDataProperties.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 09.04.2022.
//
//

import Foundation
import CoreData


extension Temperature {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Temperature> {
        return NSFetchRequest<Temperature>(entityName: "Temperature")
    }

    @NSManaged public var date: Date?
    @NSManaged public var value: Double
    @NSManaged public var id: UUID?

}

extension Temperature : Identifiable {

}
