//
//  DrugTakeMetaDataCD+CoreDataProperties.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 09.04.2022.
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
    @NSManaged public var doctorVisitsCD: NSSet?
    
    public var unwrappedDate: Date {
        date ?? Date.now
    }
    
    public var drugTakesArray: [DrugTakeCD] {
        let drugTakesSet = drugTakesCD as? Set<DrugTakeCD> ?? []
        
        return drugTakesSet.sorted {
            $0.unwrappedTime < $1.unwrappedTime
        }
    }
    
    public var doctorVisitsArray: [DoctorVisitCD] {
        let doctorVisitsSet = doctorVisitsCD as? Set<DoctorVisitCD> ?? []
        
        return doctorVisitsSet.sorted {
            $0.unwrappedDate < $1.unwrappedDate
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

// MARK: Generated accessors for doctorVisitsCD
extension DrugTakeMetaDataCD {

    @objc(addDoctorVisitsCDObject:)
    @NSManaged public func addToDoctorVisitsCD(_ value: DoctorVisitCD)

    @objc(removeDoctorVisitsCDObject:)
    @NSManaged public func removeFromDoctorVisitsCD(_ value: DoctorVisitCD)

    @objc(addDoctorVisitsCD:)
    @NSManaged public func addToDoctorVisitsCD(_ values: NSSet)

    @objc(removeDoctorVisitsCD:)
    @NSManaged public func removeFromDoctorVisitsCD(_ values: NSSet)

}

extension DrugTakeMetaDataCD : Identifiable {

}
