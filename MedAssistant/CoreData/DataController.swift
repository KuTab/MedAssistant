//
//  DataController.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 24.03.2022.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    //tells what model we will use
    let container = NSPersistentContainer(name: "HealthRecords")
    
    //initializer for loading stoared data
    init() {
        container.loadPersistentStores { desription, error in
            if let error = error {
                print("CoreData failed to load with error: \(error.localizedDescription)")
            }
        }
    }
}
