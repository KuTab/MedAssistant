//
//  DoctorVisitCD+CoreDataProperties.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 09.04.2022.
//
//

import Foundation
import CoreData


extension DoctorVisitCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DoctorVisitCD> {
        return NSFetchRequest<DoctorVisitCD>(entityName: "DoctorVisitCD")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var metaData: DrugTakeMetaDataCD?
    
    public var unwrappedDate: Date {
       date ?? Date.now
    }
    
    public var unwrappedTiltle: String {
        title ?? ""
    }

}

extension DoctorVisitCD : Identifiable {

}
