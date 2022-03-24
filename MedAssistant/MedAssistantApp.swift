//
//  MedAssistantApp.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 02.01.2022.
//

import SwiftUI

@main
struct MedAssistantApp: App {
    
    //CoreData store for application
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
