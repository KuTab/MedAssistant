//
//  DrugTakeCD+CoreDataProperties.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 28.03.2022.
//
//

import Foundation
import CoreData


extension DrugTakeCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrugTakeCD> {
        return NSFetchRequest<DrugTakeCD>(entityName: "DrugTakeCD")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var time: Date?
    @NSManaged public var title: String?
    @NSManaged public var metaData: DrugTakeMetaDataCD?
    
    public var unwrappedTime: Date {
        time ?? Date.now
    }
    
    public var unwrappedTiltle: String {
        title ?? ""
    }

}

extension DrugTakeCD : Identifiable {

}
