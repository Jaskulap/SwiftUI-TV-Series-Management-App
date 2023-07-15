//
//  ProjektApp.swift
//  Projekt
//
//  Created by Pawel Jaskula on 28/05/2023.
//

import SwiftUI

@main
struct ProjektApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
