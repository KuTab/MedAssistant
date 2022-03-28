//
//  DrugTakeMetaDataCD+CoreDataProperties.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 28.03.2022.
//
//

import Foundation
import CoreData


extension DrugTakeMetaDataCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrugTakeMetaDataCD> {
        return NSFetchRequest<DrugTakeMetaDataCD>(entityName: "DrugTakeMetaDataCD")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var drugTakesCD: NSSet?
    
    public var unwrappedDate: Date {
        date ?? Date.now
    }
    
    public var drugTakesArray: [DrugTakeCD] {
        let drugTakesSet = drugTakesCD as? Set<DrugTakeCD> ?? []
        
        return drugTakesSet.sorted {
            $0.unwrappedTime < $1.unwrappedTime
        }
    }

}

// MARK: Generated accessors for drugTakesCD
extension DrugTakeMetaDataCD {

    @objc(addDrugTakesCDObject:)
    @NSManaged public func addToDrugTakesCD(_ value: DrugTakeCD)

    @objc(removeDrugTakesCDObject:)
    @NSManaged public func removeFromDrugTakesCD(_ value: DrugTakeCD)

    @objc(addDrugTakesCD:)
    @NSManaged public func addToDrugTakesCD(_ values: NSSet)

    @objc(removeDrugTakesCD:)
    @NSManaged public func removeFromDrugTakesCD(_ values: NSSet)

}

extension DrugTakeMetaDataCD : Identifiable {

}
