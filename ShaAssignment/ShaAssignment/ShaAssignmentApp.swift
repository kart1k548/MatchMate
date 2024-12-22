//
//  ShaAssignmentApp.swift
//  ShaAssignment
//
//  Created by Dagar, Kartik on 21/12/24.
//

import SwiftUI

@main
struct ShaAssignmentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
