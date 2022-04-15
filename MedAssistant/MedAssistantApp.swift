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
//    @Environment(\.scenePhase) var scenePhase
    
    init(){
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            LoginViewModel.shared.isLoggedIn = false
            UserDefaults.standard.set(false, forKey: "IsLoggedIn")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
//                .onChange(of: scenePhase) { newPhase in
//                    if newPhase == .background {
//                        UserDefaults.standard.set(false, forKey: "IsLoggedIn")
//                    }
//                }
        }
    }
}
