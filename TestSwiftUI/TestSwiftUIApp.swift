//
//  TestSwiftUIApp.swift
//  TestSwiftUI
//
//  Created by Kruthay Donapati on 10/1/23.
//

import SwiftUI

@main
struct TestSwiftUIApp: App {
    @StateObject private var persistenceController = PersistenceController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(persistenceController)
        }
    }
}
