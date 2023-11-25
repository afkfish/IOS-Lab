//
//  ImagedNoteApp.swift
//  ImagedNote
//
//  Created by Beni Kis on 25/11/2023.
//

import SwiftUI

@main
struct ImagedNoteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
